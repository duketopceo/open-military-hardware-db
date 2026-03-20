"""
Load reference enums and platforms into DATABASE_URL.
Run: PYTHONPATH=backend python -m app.seed (from repo root) or from /app in Docker.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

from sqlalchemy import func, select, text
from sqlalchemy.orm import Session

from app.db.models import Category, Platform
from app.db.session import SessionLocal
from app.paths import repo_root
from app.services.data_import import upsert_platform


def _apply_reference_seed_sql(session: Session) -> None:
    """Convert SQLite INSERT OR IGNORE statements to Postgres ON CONFLICT DO NOTHING."""
    path = repo_root() / "schemas" / "003_seed_enums.sql"
    raw = path.read_text(encoding="utf-8")
    dialect = session.get_bind().dialect.name
    if dialect != "postgresql":
        return
    for line in raw.splitlines():
        line = line.strip()
        if not line or line.startswith("--"):
            continue
        if not line.upper().startswith("INSERT"):
            continue
        stmt = line.rstrip(";")
        if "INSERT OR IGNORE" in stmt:
            stmt = stmt.replace("INSERT OR IGNORE", "INSERT", 1) + " ON CONFLICT DO NOTHING"
        session.execute(text(stmt))
    session.commit()


def seed(session: Session | None = None) -> None:
    own_session = session is None
    if own_session:
        session = SessionLocal()
    assert session is not None
    try:
        count = session.scalar(select(func.count()).select_from(Platform)) or 0
        if count > 0:
            print(f"Seed skipped: {count} platforms already present.", file=sys.stderr)
            return

        dialect = session.get_bind().dialect.name
        if dialect == "postgresql":
            ref_count = session.scalar(select(func.count()).select_from(Category)) or 0
            if ref_count == 0:
                print("Applying reference seed (003_seed_enums) for PostgreSQL...", file=sys.stderr)
                _apply_reference_seed_sql(session)

        json_path = repo_root() / "data" / "json" / "platforms.json"
        with open(json_path, encoding="utf-8") as f:
            platforms = json.load(f)
        for p in platforms:
            upsert_platform(session, p)
        print(f"Seeded {len(platforms)} platforms.", file=sys.stderr)
    finally:
        if own_session:
            session.close()


def main() -> None:
    seed()


if __name__ == "__main__":
    main()
