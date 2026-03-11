"""
Export military hardware data to CSV, JSON, and SQL dump formats.
Reads from the master JSON dataset and produces all output formats.
"""

import csv
import json
import logging
import sqlite3
from pathlib import Path
from datetime import datetime

logger = logging.getLogger(__name__)

PROJECT_ROOT = Path(__file__).parent.parent.parent
DATA_DIR = PROJECT_ROOT / "data"
SCHEMA_DIR = PROJECT_ROOT / "schemas"


def load_dataset(json_path: Path) -> list[dict]:
    """Load the master JSON dataset."""
    with open(json_path) as f:
        return json.load(f)


# ── JSON Export ────────────────────────────────────────────────────────

def export_json(platforms: list[dict], output_path: Path):
    """Export platforms as pretty-printed JSON."""
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, "w") as f:
        json.dump(platforms, f, indent=2, ensure_ascii=False, default=str)
    logger.info(f"Exported {len(platforms)} platforms to {output_path}")


# ── CSV Export ─────────────────────────────────────────────────────────

def flatten_platform(p: dict) -> dict:
    """Flatten a nested platform dict into a single-level dict for CSV."""
    flat = {
        "platform_id": p.get("platform_id"),
        "common_name": p.get("common_name"),
        "official_designation": p.get("official_designation"),
        "nato_reporting_name": p.get("nato_reporting_name"),
        "category_id": p.get("category_id"),
        "subcategory_id": p.get("subcategory_id"),
        "manufacturer": p.get("manufacturer"),
        "country_of_origin": p.get("country_of_origin"),
        "development_start_year": p.get("development_start_year"),
        "first_flight_year": p.get("first_flight_year"),
        "entered_service_year": p.get("entered_service_year"),
        "production_start_year": p.get("production_start_year"),
        "production_end_year": p.get("production_end_year"),
        "units_built": p.get("units_built"),
        "units_built_approx": p.get("units_built_approx", False),
        "status_id": p.get("status_id"),
        "description": (p.get("description") or "")[:200],  # Truncate for CSV
    }

    # Flatten specifications
    specs = p.get("specifications", {})
    for key, val in specs.items():
        flat[f"spec_{key}"] = val

    # Flatten economics
    econ = p.get("economics", {})
    for key, val in econ.items():
        flat[f"econ_{key}"] = val

    # Operators as comma-separated country codes
    operators = p.get("operators", [])
    flat["operator_countries"] = ", ".join(
        op.get("country_code", "") for op in operators
    )
    flat["total_operators"] = len(operators)

    # Conflicts as comma-separated names
    conflicts = p.get("conflicts", [])
    flat["conflicts_list"] = ", ".join(
        c.get("conflict_id", "") for c in conflicts
    )

    # Source count
    flat["source_count"] = len(p.get("sources", []))

    # Primary image URL
    media = p.get("media", [])
    if media:
        flat["primary_image_url"] = media[0].get("url", "")
    else:
        flat["primary_image_url"] = ""

    return flat


def export_csv(platforms: list[dict], output_path: Path):
    """Export platforms as a flat CSV file."""
    if not platforms:
        logger.warning("No platforms to export")
        return

    flat_data = [flatten_platform(p) for p in platforms]

    # Collect all possible columns
    all_keys = set()
    for row in flat_data:
        all_keys.update(row.keys())

    # Sort columns logically
    priority_cols = [
        "platform_id", "common_name", "official_designation", "category_id",
        "subcategory_id", "manufacturer", "country_of_origin", "status_id",
        "entered_service_year", "units_built",
    ]
    other_cols = sorted(all_keys - set(priority_cols))
    columns = [c for c in priority_cols if c in all_keys] + other_cols

    output_path.parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=columns, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(flat_data)

    logger.info(f"Exported {len(flat_data)} platforms to {output_path}")


# ── SQL Dump Export ────────────────────────────────────────────────────

def export_sql_dump(platforms: list[dict], output_dir: Path):
    """
    Create a SQLite database and export as SQL dump.
    Produces both the .db file and a .sql text dump.
    """
    db_path = output_dir / "military_hardware.db"
    sql_path = output_dir / "military_hardware_dump.sql"
    output_dir.mkdir(parents=True, exist_ok=True)

    # Remove existing DB
    if db_path.exists():
        db_path.unlink()

    conn = sqlite3.connect(str(db_path))
    cursor = conn.cursor()

    # Execute schema creation
    schema_files = ["001_create_tables.sql", "002_create_indexes.sql", "003_seed_enums.sql"]
    for schema_file in schema_files:
        schema_path = SCHEMA_DIR / schema_file
        if schema_path.exists():
            sql = schema_path.read_text()
            cursor.executescript(sql)
            logger.info(f"Executed {schema_file}")

    # Insert platform data
    for p in platforms:
        _insert_platform(cursor, p)

    conn.commit()

    # Generate SQL text dump
    with open(sql_path, "w", encoding="utf-8") as f:
        f.write(f"-- Military Hardware Database SQL Dump\n")
        f.write(f"-- Generated: {datetime.now().isoformat()}\n")
        f.write(f"-- Platforms: {len(platforms)}\n\n")
        for line in conn.iterdump():
            f.write(f"{line}\n")

    conn.close()
    logger.info(f"Exported SQLite DB to {db_path}")
    logger.info(f"Exported SQL dump to {sql_path}")


def _insert_platform(cursor, p: dict):
    """Insert a single platform and its related records into SQLite."""
    # Main platform record
    cursor.execute(
        """INSERT OR REPLACE INTO platforms
        (platform_id, common_name, official_designation, nato_reporting_name,
         category_id, subcategory_id, manufacturer, country_of_origin,
         development_start_year, first_flight_year, entered_service_year,
         production_start_year, production_end_year, units_built, units_built_approx,
         status_id, description)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""",
        (
            p.get("platform_id"),
            p.get("common_name"),
            p.get("official_designation"),
            p.get("nato_reporting_name"),
            p.get("category_id"),
            p.get("subcategory_id"),
            p.get("manufacturer"),
            p.get("country_of_origin"),
            p.get("development_start_year"),
            p.get("first_flight_year"),
            p.get("entered_service_year"),
            p.get("production_start_year"),
            p.get("production_end_year"),
            p.get("units_built"),
            p.get("units_built_approx", False),
            p.get("status_id"),
            p.get("description"),
        ),
    )

    pid = p.get("platform_id")

    # Specifications
    specs = p.get("specifications", {})
    if specs:
        cols = list(specs.keys())
        vals = [specs[c] for c in cols]
        cols_str = ", ".join(cols)
        placeholders = ", ".join(["?"] * len(cols))
        cursor.execute(
            f"INSERT OR REPLACE INTO specifications (platform_id, {cols_str}) VALUES (?, {placeholders})",
            [pid] + vals,
        )

    # Economics
    econ = p.get("economics", {})
    if econ:
        cols = list(econ.keys())
        vals = [econ[c] for c in cols]
        cols_str = ", ".join(cols)
        placeholders = ", ".join(["?"] * len(cols))
        cursor.execute(
            f"INSERT OR REPLACE INTO economics (platform_id, {cols_str}) VALUES (?, {placeholders})",
            [pid] + vals,
        )

    # Armaments
    for arm in p.get("armaments", []):
        cursor.execute(
            """INSERT INTO armaments
            (platform_id, weapon_name, weapon_type, caliber_mm, quantity, linked_munition_id, notes)
            VALUES (?, ?, ?, ?, ?, ?, ?)""",
            (
                pid,
                arm.get("weapon_name"),
                arm.get("weapon_type"),
                arm.get("caliber_mm"),
                arm.get("quantity"),
                arm.get("linked_munition_id"),
                arm.get("notes"),
            ),
        )

    # Operators
    for op in p.get("operators", []):
        cursor.execute(
            """INSERT OR REPLACE INTO operators
            (platform_id, country_code, quantity, quantity_approx,
             service_entry_year, retirement_year, variant, branch, notes)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)""",
            (
                pid,
                op.get("country_code"),
                op.get("quantity"),
                op.get("quantity_approx", False),
                op.get("service_entry_year"),
                op.get("retirement_year"),
                op.get("variant"),
                op.get("branch"),
                op.get("notes"),
            ),
        )

    # Conflicts
    for conf in p.get("conflicts", []):
        cursor.execute(
            """INSERT OR REPLACE INTO platform_conflicts
            (platform_id, conflict_id, role, units_deployed, losses, kills, notes, source_url)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)""",
            (
                pid,
                conf.get("conflict_id"),
                conf.get("role"),
                conf.get("units_deployed"),
                conf.get("losses"),
                conf.get("kills"),
                conf.get("notes"),
                conf.get("source_url"),
            ),
        )

    # Media
    for med in p.get("media", []):
        cursor.execute(
            """INSERT INTO media
            (platform_id, media_type, media_subtype, url, caption, attribution, license)
            VALUES (?, ?, ?, ?, ?, ?, ?)""",
            (
                pid,
                med.get("media_type"),
                med.get("media_subtype"),
                med.get("url"),
                med.get("caption"),
                med.get("attribution"),
                med.get("license"),
            ),
        )

    # Sources
    for src in p.get("sources", []):
        cursor.execute(
            """INSERT INTO sources
            (platform_id, source_name, source_url, access_date,
             data_fields_sourced, reliability_rating, notes)
            VALUES (?, ?, ?, ?, ?, ?, ?)""",
            (
                pid,
                src.get("source_name"),
                src.get("source_url"),
                src.get("access_date"),
                src.get("data_fields_sourced"),
                src.get("reliability_rating"),
                src.get("notes"),
            ),
        )


# ── Main entry point ──────────────────────────────────────────────────

def export_all(json_input_path: Path, output_dir: Path = DATA_DIR):
    """Run all exports from a master JSON file."""
    platforms = load_dataset(json_input_path)
    logger.info(f"Loaded {len(platforms)} platforms from {json_input_path}")

    export_json(platforms, output_dir / "json" / "platforms.json")
    export_csv(platforms, output_dir / "csv" / "platforms.csv")
    export_sql_dump(platforms, output_dir / "sql")

    logger.info("All exports complete")


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
    import sys

    if len(sys.argv) > 1:
        input_path = Path(sys.argv[1])
    else:
        input_path = DATA_DIR / "json" / "platforms.json"

    export_all(input_path)
