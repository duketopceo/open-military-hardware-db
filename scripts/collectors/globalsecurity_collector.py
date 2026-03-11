"""
GlobalSecurity.org collector for military hardware data.
Good source for operational details and program history.
"""

import re
import logging
from typing import Optional
from urllib.parse import quote

from bs4 import BeautifulSoup

from .base_collector import BaseCollector

logger = logging.getLogger(__name__)


class GlobalSecurityCollector(BaseCollector):
    """
    Collects military platform data from GlobalSecurity.org.
    Strong on program history, operators, and operational details.
    """

    SOURCE_NAME = "GlobalSecurity.org"
    BASE_URL = "https://www.globalsecurity.org"
    RELIABILITY = "secondary"

    def _extract_specifications(self, soup: BeautifulSoup) -> dict:
        """Extract specifications from GlobalSecurity article format."""
        specs = {}

        # GS often uses definition lists or simple tables
        for table in soup.find_all("table"):
            rows = table.find_all("tr")
            for row in rows:
                cells = row.find_all(["td", "th"])
                if len(cells) >= 2:
                    label = cells[0].get_text(strip=True).lower()
                    value = cells[1].get_text(strip=True)

                    # Map common GS spec labels
                    field_map = {
                        "length": "length_m",
                        "width": "width_m",
                        "wingspan": "width_m",
                        "height": "height_m",
                        "weight": "weight_max_kg",
                        "max speed": "speed_max_kmh",
                        "speed": "speed_max_kmh",
                        "range": "range_km",
                        "ceiling": "ceiling_m",
                        "crew": "crew_min",
                        "armament": "armament_raw",
                        "powerplant": "powerplant_model",
                        "engine": "powerplant_model",
                        "displacement": "displacement_tons",
                    }

                    for key, field in field_map.items():
                        if key in label:
                            num = re.search(r"[\d,.]+", value.replace(",", ""))
                            if num and field not in (
                                "powerplant_model",
                                "armament_raw",
                            ):
                                try:
                                    specs[field] = float(num.group().replace(",", ""))
                                except ValueError:
                                    pass
                            elif field in ("powerplant_model", "armament_raw"):
                                specs[field] = value
                            break

        return specs

    def collect_platform(self, url: str) -> Optional[dict]:
        """Collect platform data from a GlobalSecurity.org article."""
        soup = self.fetch_page(url)
        if not soup:
            return None

        title = soup.find("h1")
        if not title:
            title = soup.find("title")

        platform_name = title.get_text(strip=True) if title else "Unknown"
        # Clean up common GS title suffixes
        platform_name = re.sub(
            r"\s*-\s*GlobalSecurity\.org.*", "", platform_name
        )

        specs = self._extract_specifications(soup)

        # Extract description from first paragraph
        description = ""
        content_div = soup.find("div", id="content") or soup.find("div", class_="content")
        if content_div:
            first_p = content_div.find("p")
            if first_p:
                description = first_p.get_text(strip=True)[:500]

        result = {
            "common_name": platform_name,
            "description": description,
            "specifications": specs,
            "sources": [
                self.make_source_entry(
                    url, "specifications, operational history"
                )
            ],
        }

        return result

    def search_platforms(self, query: str) -> list[dict]:
        """Search GlobalSecurity.org for platform articles."""
        # GS search endpoint
        search_url = f"{self.BASE_URL}/cgi-bin/search.cgi?query={quote(query)}"
        soup = self.fetch_page(search_url, use_cache=False)
        if not soup:
            return []

        results = []
        for link in soup.find_all("a", href=True):
            href = link.get("href", "")
            text = link.get_text(strip=True)
            if text and len(text) > 5 and any(
                section in href
                for section in ["/military/", "/systems/", "/wmd/"]
            ):
                full_url = (
                    href
                    if href.startswith("http")
                    else f"{self.BASE_URL}{href}"
                )
                results.append({"name": text, "url": full_url})

        seen = set()
        unique = []
        for r in results:
            if r["url"] not in seen:
                seen.add(r["url"])
                unique.append(r)

        return unique[:20]
