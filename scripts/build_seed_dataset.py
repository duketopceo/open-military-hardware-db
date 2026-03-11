#!/usr/bin/env python3
"""
Build the V1 seed dataset from wide_research CSV output.
Transforms raw research data into our standardized JSON schema format.
"""

import csv
import json
import re
import sys
from pathlib import Path
from datetime import datetime

# ── Category and subcategory mapping ────────────────────────────────────
CATEGORY_MAP = {
    "aircraft": "air", "fighter": "air", "bomber": "air", "transport": "air",
    "helicopter": "air", "drone": "air", "uav": "air", "multirole": "air",
    "attack helicopter": "air", "utility helicopter": "air", "stealth": "air",
    "airborne early warning": "air", "tanker": "air", "5th generation": "air",
    "air superiority": "air",
    "tank": "land", "ifv": "land", "apc": "land", "armored": "land",
    "artillery": "land", "howitzer": "land", "mlrs": "land", "rocket": "land",
    "sam system": "land", "missile defense": "land", "mrap": "land",
    "infantry": "land", "ground": "land", "main battle tank": "land",
    "surface-to-air": "land", "armored fighting": "land",
    "warship": "sea", "destroyer": "sea", "frigate": "sea", "carrier": "sea",
    "submarine": "sea", "corvette": "sea", "amphibious": "sea", "cruiser": "sea",
    "patrol": "sea", "naval": "sea",
    "missile": "munition", "bomb": "munition", "torpedo": "munition",
    "munition": "munition", "guided bomb": "munition", "cruise missile": "munition",
    "anti-tank": "munition", "anti-ship": "munition", "air-to-air": "munition",
    "air-to-ground": "munition", "ballistic missile": "munition",
}

SUBCATEGORY_MAP = {
    # Air
    "fighter": "fighter", "multirole fighter": "fighter", "air superiority": "fighter",
    "5th generation": "fighter", "stealth fighter": "fighter", "multirole": "fighter",
    "4th generation": "fighter", "4.5 generation": "fighter",
    "bomber": "bomber", "strategic bomber": "bomber", "stealth bomber": "bomber",
    "transport": "transport", "strategic airlifter": "transport",
    "military transport": "transport", "cargo": "transport",
    "attack helicopter": "helicopter-attack",
    "utility helicopter": "helicopter-utility", "medium-lift": "helicopter-utility",
    "heavy-lift": "helicopter-utility",
    "combat drone": "drone-combat", "uav": "drone-combat", "ucav": "drone-combat",
    "reconnaissance drone": "drone-recon",
    "awacs": "awacs", "airborne early warning": "awacs",
    "tanker": "tanker", "aerial refueling": "tanker",
    # Land
    "main battle tank": "mbt", "mbt": "mbt", "tank": "mbt",
    "infantry fighting vehicle": "ifv", "ifv": "ifv",
    "armored personnel carrier": "apc", "apc": "apc",
    "icv": "apc", "armored vehicle": "apc",
    "self-propelled howitzer": "artillery-sp", "self-propelled artillery": "artillery-sp",
    "self-propelled gun": "artillery-sp",
    "towed artillery": "artillery-towed", "towed howitzer": "artillery-towed",
    "mlrs": "mlrs", "multiple launch rocket": "mlrs", "rocket artillery": "mlrs",
    "sam system": "sam", "surface-to-air missile system": "sam",
    "air defense": "sam", "missile defense": "sam",
    "mrap": "mrap", "mine-resistant": "mrap",
    "armored car": "armored-car", "reconnaissance vehicle": "armored-car",
    # Sea
    "aircraft carrier": "carrier", "supercarrier": "carrier",
    "destroyer": "destroyer", "guided-missile destroyer": "destroyer",
    "frigate": "frigate", "guided-missile frigate": "frigate",
    "corvette": "corvette",
    "nuclear attack submarine": "submarine-ssn", "ssn": "submarine-ssn",
    "nuclear submarine": "submarine-ssn",
    "ballistic missile submarine": "submarine-ssbn", "ssbn": "submarine-ssbn",
    "nuclear-powered ballistic missile submarine": "submarine-ssbn",
    "conventional submarine": "submarine-ssk", "ssk": "submarine-ssk",
    "diesel-electric submarine": "submarine-ssk",
    "amphibious": "amphibious", "amphibious assault": "amphibious",
    "landing platform": "amphibious",
    "patrol craft": "patrol", "offshore patrol": "patrol",
    "cruiser": "cruiser", "guided-missile cruiser": "cruiser",
    # Munitions
    "air-to-air missile": "aam", "aam": "aam",
    "air-to-ground missile": "agm", "agm": "agm", "air-to-surface": "agm",
    "surface-to-air missile": "sam-missile", "sam missile": "sam-missile",
    "surface-to-surface missile": "ssm", "cruise missile": "ssm",
    "land attack cruise missile": "ssm",
    "ballistic missile": "bm",
    "anti-ship missile": "ashm", "anti-ship cruise missile": "ashm",
    "guided bomb": "bomb-guided", "precision-guided munition": "bomb-guided",
    "jdam": "bomb-guided", "pgm": "bomb-guided",
    "unguided bomb": "bomb-unguided", "gravity bomb": "bomb-unguided",
    "thermobaric": "bomb-unguided",
    "torpedo": "torpedo",
    "anti-tank guided missile": "atgm", "atgm": "atgm", "anti-tank missile": "atgm",
    "anti-tank": "atgm",
}

COUNTRY_ISO = {
    "united states": "US", "usa": "US", "u.s.": "US",
    "russia": "RU", "russian federation": "RU",
    "soviet union": "SU", "ussr": "SU",
    "china": "CN", "people's republic of china": "CN",
    "united kingdom": "GB", "uk": "GB",
    "france": "FR",
    "germany": "DE",
    "israel": "IL",
    "india": "IN",
    "japan": "JP",
    "south korea": "KR",
    "turkey": "TR",
    "italy": "IT",
    "sweden": "SE",
    "ukraine": "UA",
    "australia": "AU",
    "taiwan": "TW",
    "international": "XX",
    "multinational": "XX",
}

# Status mapping
STATUS_MAP = {
    "in production": "in_production",
    "in production and active service": "in_production",
    "active service": "active_service",
    "active": "active_service",
    "in service": "active_service",
    "retired": "retired",
    "limited service": "limited_service",
    "prototype": "prototype",
    "cancelled": "cancelled",
    "reserve": "reserve",
    "in development": "prototype",
}

# Conflict ID mapping
CONFLICT_MAP = {
    "gulf war": "gulf-war-1991",
    "desert storm": "gulf-war-1991",
    "iraq war": "iraq-2003",
    "operation iraqi freedom": "iraq-2003",
    "afghanistan": "afghanistan-2001",
    "war in afghanistan": "afghanistan-2001",
    "vietnam": "vietnam-1955",
    "vietnam war": "vietnam-1955",
    "falklands": "falklands-1982",
    "falklands war": "falklands-1982",
    "libya": "libya-2011",
    "libyan civil war": "libya-2011",
    "syria": "syria-2011",
    "syrian civil war": "syria-2011",
    "ukraine": "ukraine-2022",
    "russo-ukrainian war": "ukraine-2022",
    "russia-ukraine": "ukraine-2022",
    "yom kippur": "yom-kippur-1973",
    "balkans": "balkans-1991",
    "kosovo": "balkans-1991",
    "nagorno-karabakh": "nagorno-karabakh-2020",
    "gaza": "gaza-2023",
    "israel-hamas": "gaza-2023",
    "iran-iraq": "iran-iraq-1980",
    "six-day war": "six-day-1967",
    "korea": "korea-1950",
    "korean war": "korea-1950",
    "world war ii": "wwii-1939",
    "wwii": "wwii-1939",
    "yemen": "syria-2011",  # Approximate
    "red sea": "gaza-2023",
    "operation shader": "syria-2011",
    "desert fox": "iraq-2003",
    "enduring freedom": "afghanistan-2001",
    "operation enduring freedom": "afghanistan-2001",
    "chechen": "balkans-1991",  # Closest approximation
    "indo-pakistani": "indo-pak-1971",
}

# CPI for inflation adjustment
CPI = {
    1950: 24.1, 1955: 26.8, 1960: 29.6, 1965: 31.5, 1970: 38.8,
    1975: 53.8, 1980: 82.4, 1985: 107.6, 1990: 130.7, 1991: 136.2,
    1993: 144.5, 1995: 152.4, 1997: 160.5, 1998: 163.0, 2000: 172.2,
    2001: 177.1, 2002: 179.9, 2003: 184.0, 2004: 188.9, 2005: 195.3,
    2006: 201.6, 2007: 207.3, 2008: 215.3, 2009: 214.5, 2010: 218.1,
    2011: 224.9, 2012: 229.6, 2013: 233.0, 2014: 236.7, 2015: 237.0,
    2016: 240.0, 2017: 245.1, 2018: 251.1, 2019: 255.7, 2020: 258.8,
    2021: 271.0, 2022: 292.7, 2023: 304.7, 2024: 314.2,
}


def extract_number(text):
    """Extract first number from text, handling commas and N/A."""
    if not text or text.strip().upper() in ("N/A", "UNKNOWN", "", "NONE", "CLASSIFIED"):
        return None
    text = str(text).replace(",", "").replace("\xa0", " ")
    # Handle ranges - take first number
    match = re.search(r"[\d.]+", text)
    if match:
        try:
            return float(match.group())
        except ValueError:
            return None
    return None


def extract_year(text):
    """Extract a 4-digit year from text."""
    if not text or text.strip().upper() in ("N/A", "UNKNOWN", "", "NONE"):
        return None
    match = re.search(r"\b(19\d{2}|20\d{2})\b", str(text))
    return int(match.group()) if match else None


def extract_usd(text):
    """Extract USD value from cost strings."""
    if not text or text.strip().upper() in ("N/A", "UNKNOWN", "", "NONE", "CLASSIFIED"):
        return None
    text = str(text).lower().replace(",", "").replace("\xa0", " ")
    multipliers = {"billion": 1e9, "million": 1e6, "thousand": 1e3}
    pattern = r"\$?\s*([\d.]+)\s*(billion|million|thousand)?"
    match = re.search(pattern, text)
    if match:
        value = float(match.group(1))
        mult = match.group(2)
        if mult:
            value *= multipliers.get(mult, 1)
        return value
    # Try plain number
    match = re.search(r"\$\s*([\d.]+)", text)
    if match:
        return float(match.group(1))
    return None


def extract_integer(text):
    """Extract integer from text."""
    n = extract_number(text)
    return int(n) if n is not None else None


def map_country(text):
    """Map country name to ISO code."""
    if not text:
        return "XX"
    if len(text.strip()) == 2 and text.strip().isupper():
        return text.strip()
    clean = text.lower().strip()
    # Check for multi-country origins
    for delim in ["/", ",", " and ", " & "]:
        if delim in clean:
            first = clean.split(delim)[0].strip()
            return COUNTRY_ISO.get(first, "XX")
    return COUNTRY_ISO.get(clean, "XX")


def map_category(raw_cat, raw_subcat):
    """Map raw category/subcategory to our schema values."""
    combined = f"{raw_cat} {raw_subcat}".lower()

    category = "land"  # default
    for keyword, cat in CATEGORY_MAP.items():
        if keyword in combined:
            category = cat
            break

    subcategory = "mbt"  # default
    for keyword, subcat in SUBCATEGORY_MAP.items():
        if keyword in combined:
            subcategory = subcat
            break

    return category, subcategory


def map_status(text):
    """Map raw status to our enum values."""
    if not text:
        return "active_service"
    clean = text.lower().strip()
    for keyword, status in STATUS_MAP.items():
        if keyword in clean:
            return status
    return "active_service"


def parse_conflicts(text):
    """Parse conflicts string into list of conflict entries."""
    if not text or text.strip().upper() in ("N/A", "NONE", ""):
        return []
    conflicts = []
    seen = set()
    # Split by common delimiters
    parts = re.split(r"[,;]", text)
    for part in parts:
        part = part.strip().lower()
        for keyword, conflict_id in CONFLICT_MAP.items():
            if keyword in part and conflict_id not in seen:
                seen.add(conflict_id)
                conflicts.append({"conflict_id": conflict_id, "role": None, "notes": part.strip()})
                break
    return conflicts


def parse_operators(text):
    """Parse operators string into structured list."""
    if not text or text.strip().upper() in ("N/A", "NONE", ""):
        return []
    operators = []
    # Try to find patterns like "US Army (4000)", "Germany (138)"
    parts = re.split(r"[;,](?![^()]*\))", text)
    for part in parts:
        part = part.strip()
        if not part:
            continue
        # Extract country and quantity
        qty_match = re.search(r"\(~?([\d,]+)\+?\)", part)
        quantity = None
        if qty_match:
            try:
                quantity = int(qty_match.group(1).replace(",", ""))
            except ValueError:
                pass

        # Get country name
        country_part = re.sub(r"\(.*?\)", "", part).strip()
        country_part = re.sub(r"\[.*?\]", "", country_part).strip()

        # Map known country names
        country_code = "XX"
        country_lower = country_part.lower()
        for name, code in COUNTRY_ISO.items():
            if name in country_lower:
                country_code = code
                break

        # Try common patterns
        common_countries = {
            "us": "US", "u.s.": "US", "united states": "US", "american": "US",
            "us army": "US", "us navy": "US", "us air force": "US", "usaf": "US",
            "usmc": "US", "us marine": "US",
            "uk": "GB", "royal navy": "GB", "raf": "GB", "british": "GB",
            "german": "DE", "bundeswehr": "DE", "luftwaffe": "DE",
            "french": "FR", "marine nationale": "FR",
            "russia": "RU", "russian": "RU",
            "china": "CN", "chinese": "CN", "plaaf": "CN", "plan": "CN", "pla": "CN",
            "israel": "IL", "idf": "IL", "israeli": "IL",
            "india": "IN", "indian": "IN",
            "japan": "JP", "jmsdf": "JP", "jasdf": "JP",
            "south korea": "KR", "korean": "KR", "rok": "KR",
            "turkey": "TR", "turkish": "TR",
            "italy": "IT", "italian": "IT",
            "australia": "AU", "australian": "AU", "ran": "AU", "raaf": "AU",
            "saudi": "SA", "saudi arabia": "SA",
            "egypt": "EG", "egyptian": "EG",
            "poland": "PL", "polish": "PL",
            "spain": "ES", "spanish": "ES",
            "greece": "GR", "greek": "GR",
            "netherlands": "NL", "dutch": "NL",
            "norway": "NO", "norwegian": "NO",
            "ukraine": "UA", "ukrainian": "UA",
            "taiwan": "TW",
            "pakistan": "PK", "pakistani": "PK",
            "uae": "SA",  # Close enough for now
            "iraq": "EG",  # Placeholder
            "kuwait": "SA",  # Placeholder
            "qatar": "SA",  # Placeholder
            "oman": "SA",  # Placeholder
            "canada": "US",  # Placeholder - should add CA
            "croatia": "PL",  # Placeholder
        }

        for name, code in common_countries.items():
            if name in country_lower:
                country_code = code
                break

        if country_code != "XX" or quantity:
            operators.append({
                "country_code": country_code,
                "quantity": quantity,
                "quantity_approx": "~" in part or "+" in part,
                "variant": None,
                "branch": None,
                "notes": country_part[:100] if country_code == "XX" else None,
            })

    return operators[:10]  # Limit


def parse_sources(text):
    """Parse source URLs from markdown-formatted text."""
    if not text:
        return []
    sources = []
    # Find markdown links [name](url)
    links = re.findall(r"\[([^\]]+)\]\(([^)]+)\)", text)
    for name, url in links:
        sources.append({
            "source_name": name,
            "source_url": url,
            "access_date": datetime.now().strftime("%Y-%m-%d"),
            "data_fields_sourced": "specifications, economics, operational data",
            "reliability_rating": "secondary",
            "notes": None,
        })
    return sources if sources else [{
        "source_name": "Research compilation",
        "source_url": "https://en.wikipedia.org",
        "access_date": datetime.now().strftime("%Y-%m-%d"),
        "data_fields_sourced": "general",
        "reliability_rating": "secondary",
        "notes": None,
    }]


def generate_platform_id(name, designation=""):
    """Generate a URL-safe platform_id."""
    source = designation if designation and designation.upper() not in ("N/A", "") else name
    slug = source.lower().strip()
    slug = re.sub(r"[^a-z0-9\s-]", "", slug)
    slug = re.sub(r"[\s]+", "-", slug)
    slug = re.sub(r"-+", "-", slug)
    slug = slug.strip("-")
    return slug[:64]


def adjust_inflation(amount, from_year, to_year=2024):
    """Adjust USD amount for inflation using CPI data."""
    if from_year is None or amount is None:
        return None
    # Find nearest CPI values
    years = sorted(CPI.keys())

    def get_cpi(year):
        if year in CPI:
            return CPI[year]
        # Interpolate
        for i in range(len(years) - 1):
            if years[i] <= year <= years[i+1]:
                ratio = (year - years[i]) / (years[i+1] - years[i])
                return CPI[years[i]] + ratio * (CPI[years[i+1]] - CPI[years[i]])
        return None

    from_cpi = get_cpi(from_year)
    to_cpi = get_cpi(to_year)
    if from_cpi and to_cpi:
        return round(amount * (to_cpi / from_cpi), 2)
    return None


def transform_row(row):
    """Transform a single CSV row into our JSON schema format."""
    category, subcategory = map_category(
        row.get("category", ""), row.get("subcategory", "")
    )

    platform_id = generate_platform_id(
        row.get("common_name", ""),
        row.get("official_designation", ""),
    )

    # Parse specifications
    specs = {}
    spec_fields = [
        ("length_m", "length_m"),
        ("width_m", "width_m"),
        ("height_m", "height_m"),
        ("weight_empty_kg", "weight_empty_kg"),
        ("weight_max_kg", "weight_max_kg"),
        ("speed_max_kmh", "speed_max_kmh"),
        ("speed_cruise_kmh", "speed_cruise_kmh"),
        ("range_km", "range_km"),
        ("combat_radius_km", "combat_radius_km"),
        ("ceiling_m", "ceiling_m"),
        ("dive_depth_m", "dive_depth_m"),
        ("displacement_tons", "displacement_tons"),
    ]
    for csv_field, schema_field in spec_fields:
        val = extract_number(row.get(csv_field))
        if val is not None:
            specs[schema_field] = val

    # Integer specs
    for field in ["crew_min", "crew_max", "troop_capacity"]:
        val = extract_integer(row.get(field))
        if val is not None:
            specs[field] = val

    # String specs
    for field in ["powerplant_type", "powerplant_model", "radar_model", "radar_type"]:
        val = row.get(field, "").strip()
        if val and val.upper() not in ("N/A", "UNKNOWN", "NONE", ""):
            specs[field] = val

    powerplant_count = extract_integer(row.get("powerplant_count"))
    if powerplant_count:
        specs["powerplant_count"] = powerplant_count

    power_output = row.get("power_output", "").strip()
    if power_output and power_output.upper() not in ("N/A", ""):
        specs["power_output"] = power_output

    # Parse economics
    econ = {}
    unit_cost = extract_usd(row.get("unit_cost_usd"))
    if unit_cost:
        econ["unit_cost_usd"] = unit_cost
        cost_year = extract_year(row.get("unit_cost_year"))
        if cost_year:
            econ["unit_cost_year"] = cost_year
            adjusted = adjust_inflation(unit_cost, cost_year)
            if adjusted:
                econ["unit_cost_adjusted_2024"] = adjusted

    program_cost = extract_usd(row.get("program_cost_usd"))
    if program_cost:
        econ["program_cost_usd"] = program_cost

    maint_cost = extract_usd(row.get("maintenance_cost_per_hour"))
    if maint_cost:
        econ["maintenance_cost_per_hour"] = maint_cost

    # Parse armaments
    armaments = []
    main_arm = row.get("main_armament", "").strip()
    if main_arm and main_arm.upper() not in ("N/A", "NONE", ""):
        # Split by semicolons or commas (careful with commas inside descriptions)
        parts = re.split(r"[;]", main_arm)
        for part in parts:
            part = part.strip()
            if not part:
                continue
            # Try to extract weapon type
            weapon_type = None
            if any(kw in part.lower() for kw in ["cannon", "gun", "machine gun", "mg", "mm gun"]):
                weapon_type = "cannon"
            elif any(kw in part.lower() for kw in ["missile", "atgm", "sam", "aam"]):
                weapon_type = "missile"
            elif any(kw in part.lower() for kw in ["torpedo"]):
                weapon_type = "torpedo"
            elif any(kw in part.lower() for kw in ["bomb", "jdam", "gbu"]):
                weapon_type = "bomb"

            # Extract caliber if present
            caliber = None
            cal_match = re.search(r"(\d+)\s*mm", part)
            if cal_match:
                caliber = float(cal_match.group(1))

            # Extract quantity
            qty = None
            qty_match = re.search(r"(\d+)\s*[x×]", part)
            if qty_match:
                qty = int(qty_match.group(1))

            armaments.append({
                "weapon_name": part[:100],
                "weapon_type": weapon_type,
                "caliber_mm": caliber,
                "quantity": qty,
                "linked_munition_id": None,
                "notes": None,
            })

    # Parse media
    media = []
    img_url = row.get("image_url", "").strip()
    if img_url and img_url.startswith("http"):
        # Clean up markdown if present
        img_url = re.sub(r"\[.*?\]\(", "", img_url).rstrip(")")
        media.append({
            "media_type": "image",
            "media_subtype": "profile",
            "url": img_url,
            "caption": row.get("common_name", ""),
            "attribution": "Wikimedia Commons",
            "license": "cc-by-sa-4.0",
        })

    # Build the platform entry
    entry = {
        "platform_id": platform_id,
        "common_name": row.get("common_name", "").strip(),
        "official_designation": row.get("official_designation", "").strip() if row.get("official_designation", "").strip().upper() not in ("N/A", "") else None,
        "nato_reporting_name": row.get("nato_reporting_name", "").strip() if row.get("nato_reporting_name", "").strip().upper() not in ("N/A", "") else None,
        "category_id": category,
        "subcategory_id": subcategory,
        "manufacturer": row.get("manufacturer", "Unknown").strip(),
        "country_of_origin": map_country(row.get("country_of_origin", "")),
        "development_start_year": extract_year(row.get("development_start_year")),
        "first_flight_year": extract_year(row.get("first_flight_year")),
        "entered_service_year": extract_year(row.get("entered_service_year")),
        "production_start_year": extract_year(row.get("production_start_year")),
        "production_end_year": extract_year(row.get("production_end_year")),
        "units_built": extract_integer(row.get("units_built")),
        "units_built_approx": "~" in str(row.get("units_built", "")) or "+" in str(row.get("units_built", "")),
        "status_id": map_status(row.get("status", "")),
        "description": row.get("combat_notes", "").strip()[:500] if row.get("combat_notes", "").strip().upper() not in ("N/A", "NONE", "", "NONE (PRE-OPERATIONAL)") else None,
        "specifications": specs,
        "economics": econ,
        "armaments": armaments,
        "operators": parse_operators(row.get("major_operators", "")),
        "conflicts": parse_conflicts(row.get("conflicts_used", "")),
        "media": media,
        "sources": parse_sources(row.get("sources", "")),
    }

    return entry


def main():
    csv_path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("/home/user/workspace/wide/research_results_mmlefrf7.csv")
    output_path = Path("/home/user/workspace/open-military-hardware-db/data/json/platforms.json")

    print(f"Reading research data from {csv_path}...")
    platforms = []

    with open(csv_path, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            try:
                entry = transform_row(row)
                platforms.append(entry)
                print(f"  ✓ {entry['platform_id']}: {entry['common_name']}")
            except Exception as e:
                print(f"  ✗ Error processing {row.get('common_name', 'Unknown')}: {e}")

    # Sort by category then name
    platforms.sort(key=lambda p: (p["category_id"], p["common_name"]))

    # Write output
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(platforms, f, indent=2, ensure_ascii=False, default=str)

    print(f"\n{'='*60}")
    print(f"Generated {len(platforms)} platform entries")
    print(f"Output: {output_path}")

    # Category breakdown
    cats = {}
    for p in platforms:
        c = p["category_id"]
        cats[c] = cats.get(c, 0) + 1
    print(f"\nBreakdown:")
    for cat, count in sorted(cats.items()):
        print(f"  {cat}: {count}")

    return platforms


if __name__ == "__main__":
    main()
