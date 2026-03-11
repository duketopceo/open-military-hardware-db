"""
Military Factory (militaryfactory.com) collector.
Collects from their comprehensive listing pages.
"""

import re
import logging
from typing import Optional
from urllib.parse import quote

from bs4 import BeautifulSoup

from .base_collector import BaseCollector

logger = logging.getLogger(__name__)


class MilitaryFactoryCollector(BaseCollector):
    """
    Collects military platform data from MilitaryFactory.com.
    Good source for specifications tables and production numbers.
    """

    SOURCE_NAME = "Military Factory"
    BASE_URL = "https://www.militaryfactory.com"
    RELIABILITY = "secondary"

    def _parse_spec_table(self, soup: BeautifulSoup) -> dict:
        """Parse the specifications table common on Military Factory pages."""
        specs = {}
        spec_tables = soup.find_all("table", class_=re.compile(r"spec"))

        if not spec_tables:
            # Try alternate layout: look for specification sections
            spec_divs = soup.find_all("div", class_=re.compile(r"spec"))
            for div in spec_divs:
                rows = div.find_all("tr")
                for row in rows:
                    cells = row.find_all(["td", "th"])
                    if len(cells) >= 2:
                        label = cells[0].get_text(strip=True).lower()
                        value = cells[1].get_text(strip=True)
                        specs[label] = value

        for table in spec_tables:
            rows = table.find_all("tr")
            for row in rows:
                cells = row.find_all(["td", "th"])
                if len(cells) >= 2:
                    label = cells[0].get_text(strip=True).lower()
                    value = cells[1].get_text(strip=True)
                    specs[label] = value

        return specs

    def collect_platform(self, url: str) -> Optional[dict]:
        """
        Collect platform data from a Military Factory article.
        Returns partial data to be merged with other sources.
        """
        soup = self.fetch_page(url)
        if not soup:
            return None

        title_elem = soup.find("h1")
        if not title_elem:
            return None

        platform_name = title_elem.get_text(strip=True)
        specs_raw = self._parse_spec_table(soup)

        # Extract what we can from the page
        result = {
            "common_name": platform_name,
            "specifications": {},
            "sources": [self.make_source_entry(url, "specifications")],
        }

        # Map extracted specs to our schema
        spec_mapping = {
            "overall length": "length_m",
            "length": "length_m",
            "width": "width_m",
            "wingspan": "width_m",
            "height": "height_m",
            "weight": "weight_max_kg",
            "maximum speed": "speed_max_kmh",
            "max speed": "speed_max_kmh",
            "range": "range_km",
            "crew": "crew_min",
        }

        for raw_label, value in specs_raw.items():
            for our_label, our_field in spec_mapping.items():
                if our_label in raw_label:
                    num_match = re.search(r"[\d,.]+", value.replace(",", ""))
                    if num_match:
                        try:
                            result["specifications"][our_field] = float(
                                num_match.group().replace(",", "")
                            )
                        except ValueError:
                            pass

        return result

    def search_platforms(self, query: str) -> list[dict]:
        """Search Military Factory for platforms."""
        search_url = f"{self.BASE_URL}/search-results.php?q={quote(query)}"
        soup = self.fetch_page(search_url, use_cache=False)
        if not soup:
            return []

        results = []
        for link in soup.find_all("a", href=True):
            href = link.get("href", "")
            text = link.get_text(strip=True)
            if (
                text
                and len(text) > 5
                and any(
                    x in href
                    for x in [
                        "/aircraft/",
                        "/armor/",
                        "/navy/",
                        "/smallarms/",
                    ]
                )
            ):
                full_url = href if href.startswith("http") else f"{self.BASE_URL}{href}"
                results.append({"name": text, "url": full_url})

        # Deduplicate
        seen = set()
        unique = []
        for r in results:
            if r["url"] not in seen:
                seen.add(r["url"])
                unique.append(r)

        return unique[:20]
