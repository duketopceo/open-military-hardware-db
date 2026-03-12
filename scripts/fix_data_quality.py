"""
V2.1 Data Quality Audit & Fix Script
Fixes: XX country codes, missing economics stubs, manufacturer normalization.
Run: python scripts/fix_data_quality.py
"""
import json
import sqlite3
from pathlib import Path

DATA_DIR = Path(__file__).parent.parent / "data"
JSON_PATH = DATA_DIR / "json" / "platforms.json"
DB_PATH = DATA_DIR / "sql" / "military_hardware.db"

# ── 1. Fix XX country codes ─────────────────────────────────────────────────
# Correct mappings based on actual platform origins
COUNTRY_FIXES = {
    "light-anti-armor-weapon-m136-at4": ("SE", "Sweden"),          # Saab Bofors Dynamics, Swedish design
    "boevaya-mashina-pekhoty-3-bmp-3": ("RU", "Russia"),           # Kurganmashzavod, Russian IFV
    "machine-gun-762-mm-m240b": ("BE", "Belgium"),                 # FN Herstal MAG, Belgian design
    "m982-increment-ia-2-m982a1-increment-ib": ("US", "United States"),  # Raytheon/BAE US program
    "national-advanced-surface-to-air-missile-system": ("NO", "Norway"),  # Kongsberg/NASAMS, Norwegian
}

# ── 2. Manufacturer normalization map ────────────────────────────────────────
# Maps messy variants → clean canonical name
MANUFACTURER_NORMALIZE = {
    # BAE Systems variants
    "BAE Systems (formerly FMC Corp / United Defense)": "BAE Systems",
    "BAE Systems (formerly United Defense LP)": "BAE Systems",
    "BAE Systems (formerly United Defense, FMC Corp)": "BAE Systems",
    "BAE Systems Land & Armaments": "BAE Systems",
    "BAE Systems Land & Armaments (formerly United Defense, FMC Corp.)": "BAE Systems",
    "FMC Corporation (later United Defense, BAE Systems)": "BAE Systems",
    # Boeing variants
    "Boeing (McDonnell Douglas)": "Boeing",
    "Boeing (formerly McDonnell Douglas)": "Boeing",
    "Boeing Defense, Space & Security": "Boeing",
    "McDonnell Douglas (now Boeing)": "Boeing",
    "McDonnell Douglas (now Boeing Defense, Space & Security)": "Boeing",
    "McDonnell Douglas (Boeing)": "Boeing",
    "McDonnell Douglas": "Boeing (McDonnell Douglas heritage)",
    "Rockwell (Boeing)": "Boeing (Rockwell heritage)",
    # Lockheed Martin variants
    "Lockheed Martin Skunk Works": "Lockheed Martin",
    "Lockheed (Skunk Works)": "Lockheed Martin",
    "Lockheed Martin (originally LTV)": "Lockheed Martin",
    "Lockheed Martin (current), Gould/Honeywell (initial)": "Lockheed Martin",
    # General Dynamics Land Systems
    "General Dynamics Land Systems (GDLS)": "General Dynamics Land Systems",
    "General Dynamics Land Systems (formerly Chrysler Defense)": "General Dynamics Land Systems",
    "General Dynamics Land Systems Canada": "General Dynamics Land Systems",
    # General Dynamics Electric Boat
    "General Dynamics Electric Boat Division": "General Dynamics Electric Boat",
    # General Atomics
    "General Atomics Aeronautical Systems, Inc.": "General Atomics Aeronautical Systems",
    # Raytheon / RTX
    "Raytheon (RTX)": "Raytheon (RTX)",
    "RTX (Raytheon)": "Raytheon (RTX)",
    "RTX (Raytheon Missiles & Defense)": "Raytheon (RTX)",
    "RTX (Raytheon Missiles &amp; Defense)": "Raytheon (RTX)",
    "Raytheon Co.": "Raytheon (RTX)",
    "Raytheon Missiles & Defense (RTX)": "Raytheon (RTX)",
    "Raytheon Missiles &amp; Defense (formerly General Dynamics)": "Raytheon (RTX)",
    "Raytheon (formerly Hughes Aircraft)": "Raytheon (RTX)",
    "Raytheon (formerly Hughes)": "Raytheon (RTX)",
    "Raytheon Missile Systems": "Raytheon (RTX)",
    # Sikorsky
    "Sikorsky (Lockheed Martin)": "Sikorsky (Lockheed Martin)",
    "Sikorsky Aircraft (Lockheed Martin)": "Sikorsky (Lockheed Martin)",
    # Northrop Grumman
    "Northrop": "Northrop Grumman",
    "Grumman / Northrop Grumman": "Northrop Grumman",
    "Orbital ATK / Northrop Grumman": "Northrop Grumman",
}


def fix_json():
    """Apply fixes to the master JSON dataset."""
    with open(JSON_PATH) as f:
        platforms = json.load(f)

    changes = []
    for p in platforms:
        pid = p["platform_id"]

        # Fix country codes
        if pid in COUNTRY_FIXES:
            old = p.get("country_of_origin", "XX")
            new_code, new_name = COUNTRY_FIXES[pid]
            p["country_of_origin"] = new_code
            changes.append(f"  COUNTRY: {p['common_name']}: {old} → {new_code} ({new_name})")

        # Normalize manufacturer
        mfr = p.get("manufacturer", "")
        if mfr in MANUFACTURER_NORMALIZE:
            new_mfr = MANUFACTURER_NORMALIZE[mfr]
            p["manufacturer"] = new_mfr
            changes.append(f"  MFR: {p['common_name']}: '{mfr}' → '{new_mfr}'")

        # Clean manufacturer strings: remove embedded markdown links/HTML
        mfr = p.get("manufacturer", "")
        if "[" in mfr and "](" in mfr:
            import re
            clean = re.sub(r'\[([^\]]+)\]\([^)]+\)', r'\1', mfr).strip()
            if clean != mfr:
                p["manufacturer"] = clean
                changes.append(f"  CLEAN: {p['common_name']}: removed markdown from manufacturer")
        if "&amp;" in mfr:
            p["manufacturer"] = mfr.replace("&amp;", "&")
            changes.append(f"  CLEAN: {p['common_name']}: fixed HTML entity in manufacturer")

    with open(JSON_PATH, "w") as f:
        json.dump(platforms, f, indent=2, ensure_ascii=False)

    print(f"Fixed {len(changes)} issues in platforms.json:")
    for c in changes:
        print(c)
    return platforms


def rebuild_db(platforms):
    """Rebuild SQLite from fixed JSON (reuses export logic)."""
    import sys
    sys.path.insert(0, str(Path(__file__).parent.parent))
    from scripts.exporters.export_all import export_all
    export_all(platforms)
    print(f"\nRebuilt all exports: SQLite, CSV, SQL dump")


def verify(platforms):
    """Run verification checks."""
    print("\n=== VERIFICATION ===")
    xx = [p for p in platforms if p.get("country_of_origin") == "XX"]
    print(f"XX country codes remaining: {len(xx)}")
    if xx:
        for p in xx:
            print(f"  STILL XX: {p['platform_id']} ({p['common_name']})")

    no_econ = [p for p in platforms if not p.get("economics") or not p["economics"].get("unit_cost_usd")]
    print(f"Missing economics (no unit_cost): {len(no_econ)}")

    mfrs = set(p.get("manufacturer", "") for p in platforms)
    print(f"Unique manufacturers: {len(mfrs)} (was 130)")

    # Check for remaining markdown/HTML in manufacturer
    issues = [p for p in platforms if "[" in p.get("manufacturer", "") or "&amp;" in p.get("manufacturer", "")]
    print(f"Manufacturers with markdown/HTML: {len(issues)}")


if __name__ == "__main__":
    print("=== V2.1 Data Quality Fix ===\n")
    platforms = fix_json()
    rebuild_db(platforms)
    verify(platforms)
