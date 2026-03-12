"""
Data integrity tests for the military hardware database.
Validates cross-table references, data completeness, and quality constraints.
"""
import pytest
import json
from pathlib import Path


DATA_DIR = Path(__file__).parent.parent / "data"


# ── Referential Integrity ────────────────────────────────────────────────────

class TestReferentialIntegrity:
    def test_all_platforms_have_specifications(self, db_connection):
        rows = db_connection.execute("""
            SELECT p.platform_id FROM platforms p
            LEFT JOIN specifications s ON p.platform_id = s.platform_id
            WHERE s.platform_id IS NULL
        """).fetchall()
        assert len(rows) == 0, f"Platforms without specs: {[r[0] for r in rows]}"

    def test_all_armaments_reference_valid_platforms(self, db_connection):
        rows = db_connection.execute("""
            SELECT a.platform_id FROM armaments a
            LEFT JOIN platforms p ON a.platform_id = p.platform_id
            WHERE p.platform_id IS NULL
        """).fetchall()
        assert len(rows) == 0

    def test_all_operators_reference_valid_platforms(self, db_connection):
        rows = db_connection.execute("""
            SELECT o.platform_id FROM operators o
            LEFT JOIN platforms p ON o.platform_id = p.platform_id
            WHERE p.platform_id IS NULL
        """).fetchall()
        assert len(rows) == 0

    def test_all_platform_conflicts_reference_valid_platforms(self, db_connection):
        rows = db_connection.execute("""
            SELECT pc.platform_id FROM platform_conflicts pc
            LEFT JOIN platforms p ON pc.platform_id = p.platform_id
            WHERE p.platform_id IS NULL
        """).fetchall()
        assert len(rows) == 0

    def test_all_platform_conflicts_reference_valid_conflicts(self, db_connection):
        rows = db_connection.execute("""
            SELECT pc.conflict_id FROM platform_conflicts pc
            LEFT JOIN conflicts c ON pc.conflict_id = c.conflict_id
            WHERE c.conflict_id IS NULL
        """).fetchall()
        assert len(rows) == 0

    def test_all_sources_reference_valid_platforms(self, db_connection):
        rows = db_connection.execute("""
            SELECT s.platform_id FROM sources s
            LEFT JOIN platforms p ON s.platform_id = p.platform_id
            WHERE p.platform_id IS NULL
        """).fetchall()
        assert len(rows) == 0

    def test_all_categories_referenced(self, db_connection):
        """Every category should have at least one platform."""
        rows = db_connection.execute("""
            SELECT c.category_id FROM categories c
            LEFT JOIN platforms p ON c.category_id = p.category_id
            GROUP BY c.category_id
            HAVING COUNT(p.platform_id) = 0
        """).fetchall()
        assert len(rows) == 0

    def test_valid_country_codes(self, db_connection):
        """No XX or empty country codes."""
        rows = db_connection.execute("""
            SELECT platform_id, country_of_origin FROM platforms
            WHERE country_of_origin = 'XX' OR country_of_origin IS NULL OR country_of_origin = ''
        """).fetchall()
        assert len(rows) == 0, f"Invalid country codes: {[dict(r) for r in rows]}"


# ── Data Quality ─────────────────────────────────────────────────────────────

class TestDataQuality:
    def test_no_duplicate_platform_ids(self, db_connection):
        rows = db_connection.execute("""
            SELECT platform_id, COUNT(*) as cnt FROM platforms
            GROUP BY platform_id HAVING cnt > 1
        """).fetchall()
        assert len(rows) == 0

    def test_all_platforms_have_common_name(self, db_connection):
        rows = db_connection.execute("""
            SELECT platform_id FROM platforms
            WHERE common_name IS NULL OR common_name = ''
        """).fetchall()
        assert len(rows) == 0

    def test_all_platforms_have_category(self, db_connection):
        rows = db_connection.execute("""
            SELECT platform_id FROM platforms
            WHERE category_id IS NULL OR category_id = ''
        """).fetchall()
        assert len(rows) == 0

    def test_all_platforms_have_manufacturer(self, db_connection):
        rows = db_connection.execute("""
            SELECT platform_id FROM platforms
            WHERE manufacturer IS NULL OR manufacturer = ''
        """).fetchall()
        assert len(rows) == 0

    def test_minimum_source_citations(self, db_connection):
        """Every platform should have at least 2 source citations."""
        rows = db_connection.execute("""
            SELECT p.platform_id, p.common_name, COUNT(s.source_id) as src_cnt
            FROM platforms p
            LEFT JOIN sources s ON p.platform_id = s.platform_id
            GROUP BY p.platform_id
            HAVING src_cnt < 2
        """).fetchall()
        assert len(rows) == 0, f"Platforms with <2 sources: {[dict(r) for r in rows]}"

    def test_no_markdown_in_manufacturer(self, db_connection):
        """Manufacturer field should not contain markdown links."""
        rows = db_connection.execute("""
            SELECT platform_id, manufacturer FROM platforms
            WHERE manufacturer LIKE '%](http%'
        """).fetchall()
        assert len(rows) == 0, f"Markdown in manufacturer: {[dict(r) for r in rows]}"

    def test_no_html_entities_in_manufacturer(self, db_connection):
        rows = db_connection.execute("""
            SELECT platform_id, manufacturer FROM platforms
            WHERE manufacturer LIKE '%&amp;%' OR manufacturer LIKE '%&lt;%' OR manufacturer LIKE '%&gt;%'
        """).fetchall()
        assert len(rows) == 0

    def test_service_years_reasonable(self, db_connection):
        """Service entry years should be between 1900 and 2030."""
        rows = db_connection.execute("""
            SELECT platform_id, entered_service_year FROM platforms
            WHERE entered_service_year IS NOT NULL
            AND (entered_service_year < 1900 OR entered_service_year > 2035)
        """).fetchall()
        assert len(rows) == 0, f"Unreasonable years: {[dict(r) for r in rows]}"

    def test_unit_costs_positive(self, db_connection):
        """All unit costs should be positive."""
        rows = db_connection.execute("""
            SELECT platform_id, unit_cost_usd FROM economics
            WHERE unit_cost_usd IS NOT NULL AND unit_cost_usd <= 0
        """).fetchall()
        assert len(rows) == 0


# ── JSON/SQLite Consistency ──────────────────────────────────────────────────

class TestExportConsistency:
    def test_json_count_matches_sqlite(self, db_connection):
        json_path = DATA_DIR / "json" / "platforms.json"
        with open(json_path) as f:
            json_count = len(json.load(f))
        db_count = db_connection.execute("SELECT COUNT(*) FROM platforms").fetchone()[0]
        assert json_count == db_count

    def test_csv_count_matches_sqlite(self, db_connection):
        csv_path = DATA_DIR / "csv" / "platforms.csv"
        with open(csv_path) as f:
            csv_lines = sum(1 for _ in f) - 1  # minus header
        db_count = db_connection.execute("SELECT COUNT(*) FROM platforms").fetchone()[0]
        assert csv_lines == db_count

    def test_json_platform_ids_match_sqlite(self, db_connection):
        json_path = DATA_DIR / "json" / "platforms.json"
        with open(json_path) as f:
            json_ids = {p["platform_id"] for p in json.load(f)}
        db_ids = {r[0] for r in db_connection.execute("SELECT platform_id FROM platforms").fetchall()}
        assert json_ids == db_ids
