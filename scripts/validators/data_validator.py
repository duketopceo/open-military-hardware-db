"""
Data validation and cleaning layer for military hardware entries.
Normalizes units, currencies, dates, and validates against JSON schema.
"""

import json
import logging
import re
from pathlib import Path
from typing import Optional

from jsonschema import validate, ValidationError

logger = logging.getLogger(__name__)

# ── CPI data for inflation adjustment ──────────────────────────────────
# US CPI-U Annual Averages (Bureau of Labor Statistics)
# Base: 1982-84 = 100
CPI_DATA = {
    1950: 24.1, 1955: 26.8, 1960: 29.6, 1965: 31.5, 1970: 38.8,
    1975: 53.8, 1980: 82.4, 1985: 107.6, 1990: 130.7, 1991: 136.2,
    1992: 140.3, 1993: 144.5, 1994: 148.2, 1995: 152.4, 1996: 156.9,
    1997: 160.5, 1998: 163.0, 1999: 166.6, 2000: 172.2, 2001: 177.1,
    2002: 179.9, 2003: 184.0, 2004: 188.9, 2005: 195.3, 2006: 201.6,
    2007: 207.3, 2008: 215.3, 2009: 214.5, 2010: 218.1, 2011: 224.9,
    2012: 229.6, 2013: 233.0, 2014: 236.7, 2015: 237.0, 2016: 240.0,
    2017: 245.1, 2018: 251.1, 2019: 255.7, 2020: 258.8, 2021: 271.0,
    2022: 292.7, 2023: 304.7, 2024: 314.2,
}

# Conversion factors
CONVERSIONS = {
    # Length
    "ft_to_m": 0.3048,
    "in_to_m": 0.0254,
    "mi_to_km": 1.60934,
    "nmi_to_km": 1.852,
    "yd_to_m": 0.9144,
    # Weight
    "lb_to_kg": 0.453592,
    "ton_short_to_kg": 907.185,
    "ton_long_to_kg": 1016.05,
    "ton_metric_to_kg": 1000.0,
    # Speed
    "mph_to_kmh": 1.60934,
    "kn_to_kmh": 1.852,
    "mach_to_kmh": 1234.8,  # at sea level
    # Altitude
    "ft_to_m_alt": 0.3048,
}

# ── Country name → ISO code mapping ──────────────────────────────────
COUNTRY_MAP = {
    "united states": "US", "usa": "US", "u.s.": "US", "america": "US", "u.s.a.": "US",
    "russia": "RU", "russian federation": "RU",
    "soviet union": "SU", "ussr": "SU",
    "china": "CN", "people's republic of china": "CN", "prc": "CN",
    "united kingdom": "GB", "uk": "GB", "britain": "GB", "great britain": "GB",
    "france": "FR",
    "germany": "DE", "west germany": "DE", "federal republic of germany": "DE",
    "israel": "IL",
    "india": "IN",
    "japan": "JP",
    "south korea": "KR", "korea, south": "KR", "republic of korea": "KR",
    "north korea": "KP", "korea, north": "KP", "dprk": "KP",
    "turkey": "TR", "türkiye": "TR",
    "italy": "IT",
    "sweden": "SE",
    "ukraine": "UA",
    "australia": "AU",
    "taiwan": "TW", "republic of china": "TW",
    "saudi arabia": "SA",
    "pakistan": "PK",
    "brazil": "BR",
    "egypt": "EG",
    "poland": "PL",
    "spain": "ES",
    "netherlands": "NL", "holland": "NL",
    "norway": "NO",
    "greece": "GR",
    "iran": "IR",
    "south africa": "ZA",
    "czechoslovakia": "CS",
    "international": "XX",  # Multi-national programs
    "multinational": "XX",
}


def normalize_country(country_str: str) -> str:
    """Convert country name to ISO 3166-1 alpha-2 code."""
    if not country_str:
        return "XX"
    # Already a code?
    if len(country_str) == 2 and country_str.isupper():
        return country_str
    clean = country_str.lower().strip()
    return COUNTRY_MAP.get(clean, "XX")


def adjust_inflation(amount: float, from_year: int, to_year: int = 2024) -> Optional[float]:
    """
    Adjust a USD amount from one year to another using CPI data.
    Returns the inflation-adjusted amount, or None if CPI data is missing.
    """
    if from_year not in CPI_DATA or to_year not in CPI_DATA:
        # Interpolate for missing years
        available = sorted(CPI_DATA.keys())
        if from_year < available[0] or to_year < available[0]:
            return None
        # Find nearest years
        from_cpi = _interpolate_cpi(from_year)
        to_cpi = _interpolate_cpi(to_year)
        if from_cpi is None or to_cpi is None:
            return None
    else:
        from_cpi = CPI_DATA[from_year]
        to_cpi = CPI_DATA[to_year]

    if from_cpi == 0:
        return None
    return round(amount * (to_cpi / from_cpi), 2)


def _interpolate_cpi(year: int) -> Optional[float]:
    """Linearly interpolate CPI for years not in our table."""
    years = sorted(CPI_DATA.keys())
    if year in CPI_DATA:
        return CPI_DATA[year]
    if year < years[0] or year > years[-1]:
        return None
    # Find surrounding years
    for i in range(len(years) - 1):
        if years[i] <= year <= years[i + 1]:
            ratio = (year - years[i]) / (years[i + 1] - years[i])
            return CPI_DATA[years[i]] + ratio * (CPI_DATA[years[i + 1]] - CPI_DATA[years[i]])
    return None


def normalize_speed(value: float, unit: str) -> float:
    """Convert speed to km/h."""
    unit = unit.lower().strip()
    if unit in ("kmh", "km/h", "kph"):
        return value
    elif unit in ("mph", "mi/h"):
        return round(value * CONVERSIONS["mph_to_kmh"], 1)
    elif unit in ("kn", "knots", "kts"):
        return round(value * CONVERSIONS["kn_to_kmh"], 1)
    elif unit in ("mach", "m"):
        return round(value * CONVERSIONS["mach_to_kmh"], 1)
    return value


def normalize_length(value: float, unit: str) -> float:
    """Convert length/distance to meters."""
    unit = unit.lower().strip()
    if unit in ("m", "meters", "metres"):
        return value
    elif unit in ("ft", "feet"):
        return round(value * CONVERSIONS["ft_to_m"], 2)
    elif unit in ("in", "inches"):
        return round(value * CONVERSIONS["in_to_m"], 3)
    elif unit in ("yd", "yards"):
        return round(value * CONVERSIONS["yd_to_m"], 2)
    return value


def normalize_distance(value: float, unit: str) -> float:
    """Convert distance to kilometers."""
    unit = unit.lower().strip()
    if unit in ("km", "kilometers", "kilometres"):
        return value
    elif unit in ("mi", "miles"):
        return round(value * CONVERSIONS["mi_to_km"], 1)
    elif unit in ("nmi", "nm", "nautical miles"):
        return round(value * CONVERSIONS["nmi_to_km"], 1)
    return value


def normalize_weight(value: float, unit: str) -> float:
    """Convert weight to kilograms."""
    unit = unit.lower().strip()
    if unit in ("kg", "kilograms"):
        return value
    elif unit in ("lb", "lbs", "pounds"):
        return round(value * CONVERSIONS["lb_to_kg"], 1)
    elif unit in ("ton", "tons", "short tons"):
        return round(value * CONVERSIONS["ton_short_to_kg"], 1)
    elif unit in ("long ton", "long tons"):
        return round(value * CONVERSIONS["ton_long_to_kg"], 1)
    elif unit in ("t", "tonne", "tonnes", "metric tons"):
        return round(value * CONVERSIONS["ton_metric_to_kg"], 1)
    return value


def generate_platform_id(name: str, designation: str = "") -> str:
    """Generate a URL-safe platform_id from name and designation."""
    source = designation if designation else name
    # Clean and slugify
    slug = source.lower().strip()
    slug = re.sub(r"[^a-z0-9\s-]", "", slug)
    slug = re.sub(r"[\s]+", "-", slug)
    slug = re.sub(r"-+", "-", slug)
    slug = slug.strip("-")
    return slug[:64]  # Limit length


def validate_platform_entry(entry: dict, schema_path: Optional[Path] = None) -> list[str]:
    """
    Validate a platform entry against the JSON schema.
    Returns a list of validation errors (empty if valid).
    """
    if schema_path is None:
        schema_path = Path(__file__).parent.parent.parent / "schemas" / "platform_schema.json"

    try:
        with open(schema_path) as f:
            schema = json.load(f)
        validate(instance=entry, schema=schema)
        return []
    except ValidationError as e:
        return [f"Schema validation error: {e.message} at {'.'.join(str(p) for p in e.absolute_path)}"]
    except FileNotFoundError:
        return [f"Schema file not found: {schema_path}"]
    except json.JSONDecodeError as e:
        return [f"Invalid schema JSON: {e}"]


def clean_and_validate(entry: dict) -> tuple[dict, list[str]]:
    """
    Clean, normalize, and validate a platform entry.
    Returns (cleaned_entry, list_of_warnings).
    """
    warnings = []

    # Generate platform_id if missing
    if not entry.get("platform_id"):
        entry["platform_id"] = generate_platform_id(
            entry.get("common_name", "unknown"),
            entry.get("official_designation", ""),
        )

    # Normalize country
    if "country_of_origin" in entry:
        original = entry["country_of_origin"]
        entry["country_of_origin"] = normalize_country(original)
        if entry["country_of_origin"] == "XX" and original:
            warnings.append(f"Could not map country '{original}' to ISO code")

    # Normalize operator countries
    for op in entry.get("operators", []):
        if "country_code" in op:
            original = op["country_code"]
            if len(original) != 2 or not original.isupper():
                op["country_code"] = normalize_country(original)

    # Inflation-adjust unit cost
    econ = entry.get("economics", {})
    if econ.get("unit_cost_usd") and econ.get("unit_cost_year"):
        adjusted = adjust_inflation(econ["unit_cost_usd"], econ["unit_cost_year"])
        if adjusted:
            econ["unit_cost_adjusted_2024"] = adjusted

    # Validate year ranges make sense
    service_year = entry.get("entered_service_year")
    dev_year = entry.get("development_start_year")
    prod_start = entry.get("production_start_year")

    if dev_year and service_year and dev_year > service_year:
        warnings.append(f"Development year ({dev_year}) is after service year ({service_year})")

    if prod_start and service_year and prod_start > service_year + 5:
        warnings.append(f"Production start ({prod_start}) is much later than service year ({service_year})")

    # Validate specs are in reasonable ranges
    specs = entry.get("specifications", {})
    if specs.get("speed_max_kmh", 0) > 40000:
        warnings.append(f"Speed {specs['speed_max_kmh']} km/h seems unreasonably high")
    if specs.get("length_m", 0) > 500:
        warnings.append(f"Length {specs['length_m']}m seems unreasonably high (check if aircraft carrier)")
    if specs.get("crew_min", 0) > 10000:
        warnings.append(f"Crew {specs['crew_min']} seems unreasonably high (check if carrier)")

    # Schema validation
    schema_errors = validate_platform_entry(entry)
    if schema_errors:
        warnings.extend(schema_errors)

    return entry, warnings
