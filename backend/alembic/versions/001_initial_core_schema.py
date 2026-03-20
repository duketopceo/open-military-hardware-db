"""Initial core schema (platforms and related tables).

Revision ID: 001_initial
Revises:
Create Date: 2026-03-20

"""

from typing import Sequence, Union

from alembic import op

from app.db.base import Base
import app.db.models  # noqa: F401

revision: str = "001_initial"
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    bind = op.get_bind()
    # Create all tables from ORM metadata (Postgres-compatible via SQLAlchemy).
    Base.metadata.create_all(bind=bind)


def downgrade() -> None:
    bind = op.get_bind()
    Base.metadata.drop_all(bind=bind)
