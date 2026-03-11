"""
Base collector class for military hardware data sources.
All source-specific collectors inherit from this.
"""

import logging
import time
import hashlib
import json
from abc import ABC, abstractmethod
from pathlib import Path
from datetime import datetime
from typing import Optional

import requests
from bs4 import BeautifulSoup

logger = logging.getLogger(__name__)


class RateLimiter:
    """Simple rate limiter to be respectful to source servers."""

    def __init__(self, requests_per_second: float = 1.0):
        self.min_interval = 1.0 / requests_per_second
        self.last_request_time = 0.0

    def wait(self):
        elapsed = time.time() - self.last_request_time
        if elapsed < self.min_interval:
            time.sleep(self.min_interval - elapsed)
        self.last_request_time = time.time()


class BaseCollector(ABC):
    """
    Abstract base class for data collectors.

    Each collector targets a specific open-source data provider
    (Wikipedia, GlobalSecurity, Military Factory, etc.) and implements
    source-specific parsing logic.
    """

    SOURCE_NAME: str = "Unknown"
    BASE_URL: str = ""
    RELIABILITY: str = "secondary"  # primary, secondary, tertiary

    def __init__(
        self,
        cache_dir: Optional[Path] = None,
        rate_limit: float = 1.0,
        user_agent: str = "OpenMilitaryHardwareDB/1.0 (Research Project; github.com/duketopceo/open-military-hardware-db)",
    ):
        self.session = requests.Session()
        self.session.headers.update(
            {
                "User-Agent": user_agent,
                "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                "Accept-Language": "en-US,en;q=0.5",
            }
        )
        self.rate_limiter = RateLimiter(rate_limit)
        self.cache_dir = cache_dir or Path("cache")
        self.cache_dir.mkdir(parents=True, exist_ok=True)
        self.access_date = datetime.now().strftime("%Y-%m-%d")

    def _cache_key(self, url: str) -> str:
        """Generate a filesystem-safe cache key from URL."""
        return hashlib.md5(url.encode()).hexdigest()

    def _get_cached(self, url: str) -> Optional[str]:
        """Check if we have a cached response for this URL."""
        cache_file = self.cache_dir / f"{self._cache_key(url)}.html"
        if cache_file.exists():
            age_hours = (time.time() - cache_file.stat().st_mtime) / 3600
            if age_hours < 168:  # 7-day cache
                logger.debug(f"Cache hit for {url}")
                return cache_file.read_text(encoding="utf-8")
        return None

    def _save_cache(self, url: str, content: str):
        """Save response to disk cache."""
        cache_file = self.cache_dir / f"{self._cache_key(url)}.html"
        cache_file.write_text(content, encoding="utf-8")

    def fetch_page(self, url: str, use_cache: bool = True) -> Optional[BeautifulSoup]:
        """
        Fetch a page with rate limiting and caching.
        Returns a BeautifulSoup object or None on failure.
        """
        # Check cache first
        if use_cache:
            cached = self._get_cached(url)
            if cached:
                return BeautifulSoup(cached, "lxml")

        # Rate limit and fetch
        self.rate_limiter.wait()
        try:
            response = self.session.get(url, timeout=30)
            response.raise_for_status()

            # Cache the response
            if use_cache:
                self._save_cache(url, response.text)

            return BeautifulSoup(response.text, "lxml")

        except requests.exceptions.RequestException as e:
            logger.error(f"Failed to fetch {url}: {e}")
            return None

    def make_source_entry(self, url: str, fields_sourced: str = "") -> dict:
        """Create a standardized source citation entry."""
        return {
            "source_name": self.SOURCE_NAME,
            "source_url": url,
            "access_date": self.access_date,
            "data_fields_sourced": fields_sourced,
            "reliability_rating": self.RELIABILITY,
            "notes": None,
        }

    @abstractmethod
    def collect_platform(self, url: str) -> Optional[dict]:
        """
        Collect data for a single platform from a URL.
        Returns a dict matching the platform JSON schema, or None on failure.
        Must be implemented by each source-specific collector.
        """
        pass

    @abstractmethod
    def search_platforms(self, query: str) -> list[dict]:
        """
        Search the source for platforms matching a query.
        Returns a list of {name, url} dicts.
        """
        pass

    def collect_batch(self, urls: list[str]) -> list[dict]:
        """Collect data for multiple platforms."""
        results = []
        for url in urls:
            try:
                data = self.collect_platform(url)
                if data:
                    results.append(data)
                    logger.info(f"Collected: {data.get('common_name', 'Unknown')}")
                else:
                    logger.warning(f"No data extracted from {url}")
            except Exception as e:
                logger.error(f"Error collecting {url}: {e}")
        return results
