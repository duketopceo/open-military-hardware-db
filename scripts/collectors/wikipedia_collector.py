"""
Wikipedia collector for military hardware data.
Uses Wikipedia's structured infoboxes as a semi-reliable data source.
Cross-reference with other sources for verification.
"""

import re
import logging
from typing import Optional
from urllib.parse import quote

from bs4 import BeautifulSoup, Tag

from .base_collector import BaseCollector

logger = logging.getLogger(__name__)


class WikipediaCollector(BaseCollector):
    """
    Collects military platform data from Wikipedia infoboxes.
    Parses structured specification tables and general article content.
    """

    SOURCE_NAME = "Wikipedia"
    BASE_URL = "https://en.wikipedia.org"
    RELIABILITY = "secondary"

    # ── Infobox field mappings ──────────────────────────────────────────
    # Maps Wikipedia infobox labels → our schema fields
    SPEC_FIELD_MAP = {
        # Dimensions
        "length": "length_m",
        "beam": "width_m",
        "wingspan": "width_m",
        "width": "width_m",
        "height": "height_m",
        "draught": "dive_depth_m",
        "draft": "dive_depth_m",
        "displacement": "displacement_tons",
        # Weight
        "empty weight": "weight_empty_kg",
        "gross weight": "weight_max_kg",
        "max takeoff weight": "weight_max_kg",
        "maximum takeoff weight": "weight_max_kg",
        "loaded weight": "weight_max_kg",
        "combat weight": "weight_max_kg",
        "curb weight": "weight_max_kg",
        "weight": "weight_max_kg",
        # Performance
        "maximum speed": "speed_max_kmh",
        "max speed": "speed_max_kmh",
        "speed": "speed_max_kmh",
        "cruise speed": "speed_cruise_kmh",
        "range": "range_km",
        "combat range": "combat_radius_km",
        "combat radius": "combat_radius_km",
        "ferry range": "range_km",
        "endurance": "endurance_hours",
        "service ceiling": "ceiling_m",
        "test depth": "dive_depth_m",
        # Crew
        "crew": "crew_min",
        "capacity": "troop_capacity",
        # Power
        "powerplant": "powerplant_model",
        "engine": "powerplant_model",
        "propulsion": "powerplant_model",
        "power/weight": "thrust_to_weight",
        "thrust/weight": "thrust_to_weight",
        # Sensors
        "radar": "radar_model",
        "fire control": "fire_control_system",
        "sensors": "radar_model",
    }

    ECON_FIELD_MAP = {
        "unit cost": "unit_cost_usd",
        "programme cost": "program_cost_usd",
        "program cost": "program_cost_usd",
        "development cost": "development_cost_usd",
        "cost per flight hour": "maintenance_cost_per_hour",
        "cost per unit": "unit_cost_usd",
    }

    PLATFORM_FIELD_MAP = {
        "manufacturer": "manufacturer",
        "designer": "manufacturer",
        "builder": "manufacturer",
        "designed by": "manufacturer",
        "national origin": "country_of_origin",
        "place of origin": "country_of_origin",
        "origin": "country_of_origin",
        "first flight": "first_flight_year",
        "introduction": "entered_service_year",
        "in service": "entered_service_year",
        "entered service": "entered_service_year",
        "produced": "production_years",
        "number built": "units_built",
        "no. built": "units_built",
        "number constructed": "units_built",
        "built": "units_built",
        "status": "status_raw",
        "primary users": "operators_raw",
        "primary user": "operators_raw",
        "used by": "operators_raw",
    }

    def _extract_number(self, text: str) -> Optional[float]:
        """Extract the first number from a text string, handling commas."""
        if not text:
            return None
        text = text.replace(",", "").replace("\xa0", " ")
        match = re.search(r"[\d.]+", text)
        if match:
            try:
                return float(match.group())
            except ValueError:
                return None
        return None

    def _extract_year(self, text: str) -> Optional[int]:
        """Extract a 4-digit year from text."""
        if not text:
            return None
        match = re.search(r"\b(19\d{2}|20\d{2})\b", text)
        return int(match.group()) if match else None

    def _extract_usd(self, text: str) -> Optional[float]:
        """Extract USD value from cost strings like 'US$78 million' or '$1.7 billion'."""
        if not text:
            return None
        text = text.lower().replace(",", "").replace("\xa0", " ")

        multipliers = {
            "billion": 1_000_000_000,
            "million": 1_000_000,
            "thousand": 1_000,
        }

        # Look for patterns like $78 million, US$1.7 billion, etc.
        pattern = r"\$\s*([\d.]+)\s*(billion|million|thousand)?"
        match = re.search(pattern, text)
        if match:
            value = float(match.group(1))
            multiplier_word = match.group(2)
            if multiplier_word:
                value *= multipliers.get(multiplier_word, 1)
            return value
        return None

    def _clean_text(self, element) -> str:
        """Extract clean text from a BeautifulSoup element, removing citations."""
        if element is None:
            return ""
        # Remove citation references [1], [2], etc.
        for sup in element.find_all("sup"):
            sup.decompose()
        text = element.get_text(strip=True)
        text = re.sub(r"\[.*?\]", "", text)
        return text.strip()

    def _parse_infobox(self, soup: BeautifulSoup) -> dict:
        """Parse a Wikipedia infobox into a flat dict of label→value."""
        infobox = soup.find("table", class_=re.compile(r"infobox"))
        if not infobox:
            logger.warning("No infobox found on page")
            return {}

        data = {}
        rows = infobox.find_all("tr")
        for row in rows:
            header = row.find("th")
            value = row.find("td")
            if header and value:
                label = self._clean_text(header).lower().strip()
                val_text = self._clean_text(value)
                if label and val_text:
                    data[label] = val_text
        return data

    def _parse_production_years(self, text: str) -> tuple[Optional[int], Optional[int]]:
        """Parse production year ranges like '1998–present' or '1970–1990'."""
        if not text:
            return None, None
        years = re.findall(r"\b(19\d{2}|20\d{2})\b", text)
        start = int(years[0]) if years else None
        end = None
        if len(years) >= 2:
            end = int(years[1])
        if "present" in text.lower() or "current" in text.lower():
            end = None  # Still in production
        return start, end

    def collect_platform(self, url: str) -> Optional[dict]:
        """
        Collect platform data from a Wikipedia article URL.
        Returns a dict matching our JSON schema.
        """
        soup = self.fetch_page(url)
        if not soup:
            return None

        infobox = self._parse_infobox(soup)
        if not infobox:
            logger.warning(f"Could not parse infobox from {url}")
            return None

        # Build platform entry
        title = soup.find("h1")
        platform_name = self._clean_text(title) if title else "Unknown"

        # Extract specifications from infobox
        specs = {}
        econ = {}
        platform_data = {"common_name": platform_name}

        for label, value in infobox.items():
            # Check spec fields
            for wiki_label, our_field in self.SPEC_FIELD_MAP.items():
                if wiki_label in label:
                    num = self._extract_number(value)
                    if num is not None:
                        specs[our_field] = num
                    elif our_field in ("powerplant_model", "radar_model", "fire_control_system"):
                        specs[our_field] = value
                    break

            # Check economic fields
            for wiki_label, our_field in self.ECON_FIELD_MAP.items():
                if wiki_label in label:
                    usd = self._extract_usd(value)
                    if usd is not None:
                        econ[our_field] = usd
                        year = self._extract_year(value)
                        if year and our_field == "unit_cost_usd":
                            econ["unit_cost_year"] = year
                    break

            # Check platform metadata fields
            for wiki_label, our_field in self.PLATFORM_FIELD_MAP.items():
                if wiki_label in label:
                    if our_field in ("first_flight_year", "entered_service_year"):
                        year = self._extract_year(value)
                        if year:
                            platform_data[our_field] = year
                    elif our_field == "units_built":
                        num = self._extract_number(value)
                        if num:
                            platform_data["units_built"] = int(num)
                    elif our_field == "production_years":
                        start, end = self._parse_production_years(value)
                        platform_data["production_start_year"] = start
                        platform_data["production_end_year"] = end
                    else:
                        platform_data[our_field] = value
                    break

        # Extract first paragraph as description
        content = soup.find("div", class_="mw-parser-output")
        if content:
            first_p = content.find("p", recursive=False)
            if first_p:
                platform_data["description"] = self._clean_text(first_p)[:500]

        # Extract images from infobox
        media = []
        infobox_table = soup.find("table", class_=re.compile(r"infobox"))
        if infobox_table:
            for img in infobox_table.find_all("img"):
                src = img.get("src", "")
                if src and "wiki" in src:
                    if not src.startswith("http"):
                        src = "https:" + src
                    # Get higher resolution version
                    src = re.sub(r"/\d+px-", "/800px-", src)
                    media.append(
                        {
                            "media_type": "image",
                            "media_subtype": "profile",
                            "url": src,
                            "caption": img.get("alt", platform_name),
                            "attribution": "Wikimedia Commons",
                            "license": "cc-by-sa-4.0",
                        }
                    )

        # Build final entry
        result = {
            **platform_data,
            "specifications": specs,
            "economics": econ,
            "media": media,
            "sources": [self.make_source_entry(url, "specifications, economics, operational data")],
        }

        return result

    def search_platforms(self, query: str) -> list[dict]:
        """Search Wikipedia for military platform articles."""
        search_url = f"{self.BASE_URL}/w/index.php?search={quote(query)}&title=Special:Search"
        soup = self.fetch_page(search_url, use_cache=False)
        if not soup:
            return []

        results = []
        for result in soup.find_all("div", class_="mw-search-result"):
            link = result.find("a")
            if link:
                title = link.get_text(strip=True)
                href = link.get("href", "")
                if href.startswith("/wiki/"):
                    results.append(
                        {"name": title, "url": f"{self.BASE_URL}{href}"}
                    )

        return results[:20]  # Limit results
