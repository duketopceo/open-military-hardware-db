from typing import Any

from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.api.deps import get_db
from app.db.models import Conflict

router = APIRouter()


@router.get("")
def list_conflicts(db: Session = Depends(get_db)) -> list[dict[str, Any]]:
    rows = db.execute(select(Conflict).order_by(Conflict.start_year.desc())).scalars().all()
    return [
        {
            "conflict_id": c.conflict_id,
            "conflict_name": c.conflict_name,
            "start_year": c.start_year,
            "end_year": c.end_year,
            "region": c.region,
            "description": c.description,
        }
        for c in rows
    ]
