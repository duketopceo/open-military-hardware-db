"""
V3.0 Migration: Import SIPRI datasets into 4 new SQLite tables.
- country_military_expenditure (from milex_constant_usd_millions.csv)
- arms_companies + company_revenue_history (from top100_arms_companies.csv)
- arms_transfers (from usa_arms_transfers_2000_2025_clean.csv)
"""
import csv
import os
import sqlite3

DB_PATH = os.path.join(os.path.dirname(__file__), "..", "sql", "military_hardware.db")
SIPRI_DIR = os.path.join(os.path.dirname(__file__), "..", "sipri")


def run():
    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys=ON")
    conn.execute("PRAGMA journal_mode=WAL")
    cur = conn.cursor()

    # ── 1. Create tables ─────────────────────────────────────────────────

    cur.execute("""
        CREATE TABLE IF NOT EXISTS country_military_expenditure (
            country_name    TEXT NOT NULL,
            region          TEXT,
            year            INTEGER NOT NULL,
            spending_usd_m  REAL,
            PRIMARY KEY (country_name, year)
        )
    """)
    print("✓ Created country_military_expenditure table")

    cur.execute("""
        CREATE TABLE IF NOT EXISTS arms_companies (
            company_id      INTEGER PRIMARY KEY AUTOINCREMENT,
            company_name    TEXT NOT NULL,
            country         TEXT NOT NULL,
            UNIQUE(company_name)
        )
    """)
    print("✓ Created arms_companies table")

    cur.execute("""
        CREATE TABLE IF NOT EXISTS company_revenue_history (
            company_id          INTEGER REFERENCES arms_companies(company_id),
            year                INTEGER NOT NULL,
            rank                INTEGER,
            arms_revenue_usd_m  REAL,
            total_revenue_usd_m REAL,
            arms_pct_of_total   REAL,
            PRIMARY KEY (company_id, year)
        )
    """)
    print("✓ Created company_revenue_history table")

    cur.execute("""
        CREATE TABLE IF NOT EXISTS arms_transfers (
            transfer_id         INTEGER PRIMARY KEY AUTOINCREMENT,
            supplier            TEXT NOT NULL DEFAULT 'United States',
            recipient           TEXT NOT NULL,
            weapon_designation  TEXT,
            weapon_description  TEXT,
            year_of_order       INTEGER,
            number_ordered      INTEGER,
            number_delivered    INTEGER,
            delivery_years      TEXT,
            status              TEXT,
            comments            TEXT,
            sipri_tiv_per_unit  REAL,
            sipri_tiv_total     REAL,
            sipri_tiv_delivered REAL
        )
    """)
    print("✓ Created arms_transfers table")

    # ── 2. Import milex (wide → long) ────────────────────────────────────

    milex_path = os.path.join(SIPRI_DIR, "milex_constant_usd_millions.csv")
    milex_count = 0
    with open(milex_path, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            country = row["country"].strip()
            region = row["region"].strip() if row.get("region") else None
            if not country:
                continue
            for key, val in row.items():
                if key in ("country", "region"):
                    continue
                try:
                    year = int(key)
                except ValueError:
                    continue
                val = val.strip() if val else ""
                if not val:
                    continue
                try:
                    spending = float(val)
                except ValueError:
                    continue
                cur.execute(
                    "INSERT OR IGNORE INTO country_military_expenditure "
                    "(country_name, region, year, spending_usd_m) VALUES (?, ?, ?, ?)",
                    (country, region, year, spending),
                )
                milex_count += 1
    print(f"✓ Imported {milex_count} military expenditure records")

    # ── 3. Import top-100 arms companies ─────────────────────────────────

    companies_path = os.path.join(SIPRI_DIR, "top100_arms_companies.csv")
    company_count = 0
    revenue_count = 0
    with open(companies_path, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            company_name = row["company"].strip()
            country = row["country"].strip()
            if not company_name:
                continue

            # Upsert company
            cur.execute(
                "INSERT OR IGNORE INTO arms_companies (company_name, country) VALUES (?, ?)",
                (company_name, country),
            )
            if cur.rowcount > 0:
                company_count += 1
            company_id = cur.execute(
                "SELECT company_id FROM arms_companies WHERE company_name = ?",
                (company_name,),
            ).fetchone()[0]

            # Parse revenue fields
            def safe_float(v):
                v = v.strip() if v else ""
                if not v:
                    return None
                try:
                    return float(v)
                except ValueError:
                    return None

            def safe_int(v):
                v = v.strip() if v else ""
                if not v:
                    return None
                try:
                    return int(v)
                except ValueError:
                    return None

            year = safe_int(row["year"])
            rank = safe_int(row["rank"])
            arms_rev = safe_float(row["arms_revenue_usd_m"])
            total_rev = safe_float(row["total_revenue_usd_m"])
            arms_pct = safe_float(row["arms_pct_of_total"])

            if year is not None:
                cur.execute(
                    "INSERT OR IGNORE INTO company_revenue_history "
                    "(company_id, year, rank, arms_revenue_usd_m, total_revenue_usd_m, arms_pct_of_total) "
                    "VALUES (?, ?, ?, ?, ?, ?)",
                    (company_id, year, rank, arms_rev, total_rev, arms_pct),
                )
                revenue_count += 1

    print(f"✓ Imported {company_count} arms companies, {revenue_count} revenue records")

    # ── 4. Import USA arms transfers ─────────────────────────────────────

    transfers_path = os.path.join(SIPRI_DIR, "usa_arms_transfers_2000_2025_clean.csv")
    transfer_count = 0
    with open(transfers_path, "r", encoding="utf-8") as f:
        reader = csv.reader(f)
        header = next(reader)

        # Map column indices by name (skip blank-header spacer columns)
        col_map = {}
        for i, h in enumerate(header):
            h_clean = h.strip()
            if h_clean:
                col_map[h_clean] = i

        for row in reader:
            if not row or len(row) < 10:
                continue

            def get_col(name, default=""):
                idx = col_map.get(name)
                if idx is not None and idx < len(row):
                    return row[idx].strip()
                return default

            def to_int(val):
                val = val.replace("?", "").strip() if val else ""
                if not val:
                    return None
                try:
                    return int(val)
                except ValueError:
                    return None

            def to_float(val):
                val = val.strip() if val else ""
                if not val:
                    return None
                try:
                    return float(val)
                except ValueError:
                    return None

            recipient = get_col("Recipient")
            supplier = get_col("Supplier") or "United States"
            if not recipient:
                continue

            cur.execute(
                "INSERT INTO arms_transfers "
                "(supplier, recipient, weapon_designation, weapon_description, "
                "year_of_order, number_ordered, number_delivered, delivery_years, "
                "status, comments, sipri_tiv_per_unit, sipri_tiv_total, sipri_tiv_delivered) "
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                (
                    supplier,
                    recipient,
                    get_col("Weapon designation") or None,
                    get_col("Weapon description") or None,
                    to_int(get_col("Year of order")),
                    to_int(get_col("Number ordered")),
                    to_int(get_col("Number delivered")),
                    get_col("Year(s) of delivery") or None,
                    get_col("status") or None,
                    get_col("Comments") or None,
                    to_float(get_col("SIPRI TIV per unit")),
                    to_float(get_col("SIPRI TIV for total order")),
                    to_float(get_col("SIPRI TIV of delivered weapons")),
                ),
            )
            transfer_count += 1

    print(f"✓ Imported {transfer_count} arms transfer records")

    conn.commit()

    # ── 5. Summary ───────────────────────────────────────────────────────

    milex_total = cur.execute("SELECT COUNT(*) FROM country_military_expenditure").fetchone()[0]
    companies_total = cur.execute("SELECT COUNT(*) FROM arms_companies").fetchone()[0]
    revenue_total = cur.execute("SELECT COUNT(*) FROM company_revenue_history").fetchone()[0]
    transfers_total = cur.execute("SELECT COUNT(*) FROM arms_transfers").fetchone()[0]

    print(f"\n✓ V3.0 SIPRI integration complete:")
    print(f"  • Military expenditure: {milex_total} records")
    print(f"  • Arms companies:       {companies_total} companies")
    print(f"  • Revenue history:       {revenue_total} records")
    print(f"  • Arms transfers:        {transfers_total} records")

    conn.close()


if __name__ == "__main__":
    run()
