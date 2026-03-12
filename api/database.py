"""
Database connection and query layer for the military hardware API.
Uses SQLite for V2 (PostgreSQL upgrade path in V3).
"""

import sqlite3
import json
from pathlib import Path
from typing import Optional

DB_PATH = Path(__file__).parent.parent / "data" / "sql" / "military_hardware.db"


def get_connection() -> sqlite3.Connection:
    """Get a database connection with row factory."""
    conn = sqlite3.connect(str(DB_PATH))
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA journal_mode=WAL")
    conn.execute("PRAGMA foreign_keys=ON")
    return conn


def dict_from_row(row: sqlite3.Row) -> dict:
    """Convert a sqlite3.Row to a plain dict."""
    return dict(row) if row else {}


def query_platforms(
    category: Optional[str] = None,
    subcategory: Optional[str] = None,
    country: Optional[str] = None,
    status: Optional[str] = None,
    manufacturer: Optional[str] = None,
    role_type: Optional[str] = None,
    min_cost: Optional[float] = None,
    max_cost: Optional[float] = None,
    min_year: Optional[int] = None,
    max_year: Optional[int] = None,
    search: Optional[str] = None,
    conflict: Optional[str] = None,
    sort_by: str = "common_name",
    sort_order: str = "asc",
    limit: int = 50,
    offset: int = 0,
) -> dict:
    """
    Query platforms with flexible filters.
    Returns {platforms: [...], total: int, limit: int, offset: int}.
    """
    conn = get_connection()
    conditions = []
    params = []

    if category:
        conditions.append("p.category_id = ?")
        params.append(category)
    if subcategory:
        conditions.append("p.subcategory_id = ?")
        params.append(subcategory)
    if country:
        conditions.append("p.country_of_origin = ?")
        params.append(country.upper())
    if status:
        conditions.append("p.status_id = ?")
        params.append(status)
    if manufacturer:
        conditions.append("p.manufacturer LIKE ?")
        params.append(f"%{manufacturer}%")
    if role_type:
        conditions.append("p.role_type = ?")
        params.append(role_type)
    if min_year:
        conditions.append("p.entered_service_year >= ?")
        params.append(min_year)
    if max_year:
        conditions.append("p.entered_service_year <= ?")
        params.append(max_year)
    if search:
        conditions.append(
            "(p.common_name LIKE ? OR p.official_designation LIKE ? OR p.description LIKE ?)"
        )
        params.extend([f"%{search}%"] * 3)
    if conflict:
        conditions.append(
            "p.platform_id IN (SELECT platform_id FROM platform_conflicts WHERE conflict_id = ?)"
        )
        params.append(conflict)

    where_clause = " AND ".join(conditions) if conditions else "1=1"

    # Cost filter requires join
    cost_join = ""
    if min_cost is not None or max_cost is not None:
        cost_join = "LEFT JOIN economics e ON p.platform_id = e.platform_id"
        if min_cost is not None:
            conditions.append("e.unit_cost_usd >= ?")
            params.append(min_cost)
        if max_cost is not None:
            conditions.append("e.unit_cost_usd <= ?")
            params.append(max_cost)
        where_clause = " AND ".join(conditions)

    # Validate sort
    valid_sorts = {
        "common_name", "entered_service_year", "units_built",
        "category_id", "country_of_origin", "manufacturer", "role_type",
    }
    if sort_by not in valid_sorts:
        sort_by = "common_name"
    order = "DESC" if sort_order.lower() == "desc" else "ASC"

    # Count total
    count_sql = f"SELECT COUNT(*) FROM platforms p {cost_join} WHERE {where_clause}"
    total = conn.execute(count_sql, params).fetchone()[0]

    # Fetch page
    query_sql = f"""
        SELECT p.* FROM platforms p {cost_join}
        WHERE {where_clause}
        ORDER BY p.{sort_by} {order}
        LIMIT ? OFFSET ?
    """
    params.extend([limit, offset])
    rows = conn.execute(query_sql, params).fetchall()

    platforms = [dict_from_row(r) for r in rows]
    conn.close()

    return {
        "platforms": platforms,
        "total": total,
        "limit": limit,
        "offset": offset,
    }


def get_platform_detail(platform_id: str) -> Optional[dict]:
    """Get a single platform with all related data."""
    conn = get_connection()

    # Core platform
    row = conn.execute(
        "SELECT * FROM platforms WHERE platform_id = ?", (platform_id,)
    ).fetchone()
    if not row:
        conn.close()
        return None

    platform = dict_from_row(row)

    # Specifications
    spec_row = conn.execute(
        "SELECT * FROM specifications WHERE platform_id = ?", (platform_id,)
    ).fetchone()
    platform["specifications"] = dict_from_row(spec_row) if spec_row else {}

    # Economics
    econ_row = conn.execute(
        "SELECT * FROM economics WHERE platform_id = ?", (platform_id,)
    ).fetchone()
    platform["economics"] = dict_from_row(econ_row) if econ_row else {}

    # Armaments
    arm_rows = conn.execute(
        "SELECT * FROM armaments WHERE platform_id = ?", (platform_id,)
    ).fetchall()
    platform["armaments"] = [dict_from_row(r) for r in arm_rows]

    # Operators
    op_rows = conn.execute(
        "SELECT * FROM operators WHERE platform_id = ?", (platform_id,)
    ).fetchall()
    platform["operators"] = [dict_from_row(r) for r in op_rows]

    # Conflicts
    conf_rows = conn.execute(
        """SELECT pc.*, c.conflict_name, c.start_year, c.end_year
           FROM platform_conflicts pc
           JOIN conflicts c ON pc.conflict_id = c.conflict_id
           WHERE pc.platform_id = ?""",
        (platform_id,),
    ).fetchall()
    platform["conflicts"] = [dict_from_row(r) for r in conf_rows]

    # Media
    media_rows = conn.execute(
        "SELECT * FROM media WHERE platform_id = ?", (platform_id,)
    ).fetchall()
    platform["media"] = [dict_from_row(r) for r in media_rows]

    # Sources
    src_rows = conn.execute(
        "SELECT * FROM sources WHERE platform_id = ?", (platform_id,)
    ).fetchall()
    platform["sources"] = [dict_from_row(r) for r in src_rows]

    conn.close()
    return platform


def get_stats() -> dict:
    """Get database summary statistics."""
    conn = get_connection()

    stats = {}

    # Total counts
    for table in ["platforms", "specifications", "economics", "armaments", "operators", "platform_conflicts", "media", "sources"]:
        stats[f"{table}_count"] = conn.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]

    # Category breakdown
    rows = conn.execute(
        "SELECT c.category_name, COUNT(*) as cnt FROM platforms p "
        "JOIN categories c ON p.category_id = c.category_id "
        "GROUP BY p.category_id ORDER BY c.category_name"
    ).fetchall()
    stats["categories"] = {r["category_name"]: r["cnt"] for r in rows}

    # Country breakdown
    rows = conn.execute(
        "SELECT co.country_name, COUNT(*) as cnt FROM platforms p "
        "JOIN countries co ON p.country_of_origin = co.country_code "
        "GROUP BY p.country_of_origin ORDER BY cnt DESC LIMIT 15"
    ).fetchall()
    stats["countries"] = {r["country_name"]: r["cnt"] for r in rows}

    # Status breakdown
    rows = conn.execute(
        "SELECT ps.status_name, COUNT(*) as cnt FROM platforms p "
        "JOIN platform_statuses ps ON p.status_id = ps.status_id "
        "GROUP BY p.status_id ORDER BY cnt DESC"
    ).fetchall()
    stats["statuses"] = {r["status_name"]: r["cnt"] for r in rows}

    # Era breakdown
    rows = conn.execute(
        """SELECT
            CASE
                WHEN entered_service_year < 1950 THEN 'Pre-1950'
                WHEN entered_service_year < 1970 THEN '1950-1969'
                WHEN entered_service_year < 1990 THEN '1970-1989'
                WHEN entered_service_year < 2010 THEN '1990-2009'
                ELSE '2010+'
            END as era,
            COUNT(*) as cnt
        FROM platforms
        WHERE entered_service_year IS NOT NULL
        GROUP BY era ORDER BY era"""
    ).fetchall()
    stats["eras"] = {r["era"]: r["cnt"] for r in rows}

    # Role type breakdown
    rows = conn.execute(
        "SELECT role_type, COUNT(*) as cnt FROM platforms "
        "WHERE role_type IS NOT NULL GROUP BY role_type ORDER BY cnt DESC"
    ).fetchall()
    stats["role_types"] = {r["role_type"]: r["cnt"] for r in rows}

    conn.close()
    return stats


def list_categories() -> list[dict]:
    """List all categories with subcategories."""
    conn = get_connection()
    cats = conn.execute("SELECT * FROM categories ORDER BY category_name").fetchall()
    result = []
    for cat in cats:
        subs = conn.execute(
            "SELECT * FROM subcategories WHERE category_id = ? ORDER BY subcategory_name",
            (cat["category_id"],),
        ).fetchall()
        result.append({
            **dict_from_row(cat),
            "subcategories": [dict_from_row(s) for s in subs],
        })
    conn.close()
    return result


def list_conflicts() -> list[dict]:
    """List all conflicts with platform counts."""
    conn = get_connection()
    rows = conn.execute(
        """SELECT c.*, COUNT(pc.platform_id) as platform_count
           FROM conflicts c
           LEFT JOIN platform_conflicts pc ON c.conflict_id = pc.conflict_id
           GROUP BY c.conflict_id
           ORDER BY c.start_year DESC"""
    ).fetchall()
    conn.close()
    return [dict_from_row(r) for r in rows]


def list_manufacturers() -> list[dict]:
    """List all manufacturers with platform counts."""
    conn = get_connection()
    rows = conn.execute(
        """SELECT manufacturer, COUNT(*) as platform_count,
               GROUP_CONCAT(DISTINCT category_id) as categories
           FROM platforms
           GROUP BY manufacturer
           ORDER BY platform_count DESC, manufacturer ASC"""
    ).fetchall()
    conn.close()
    return [
        {
            "manufacturer": r["manufacturer"],
            "platform_count": r["platform_count"],
            "categories": r["categories"].split(",") if r["categories"] else [],
        }
        for r in rows
    ]


def compare_platforms(platform_ids: list[str]) -> list[dict]:
    """Get multiple platforms for side-by-side comparison."""
    results = []
    for pid in platform_ids[:10]:  # Max 10 comparisons
        detail = get_platform_detail(pid)
        if detail:
            results.append(detail)
    return results
