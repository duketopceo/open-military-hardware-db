from typing import Any

from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.api.deps import get_db
from app.db.models import Category

router = APIRouter()


@router.get("")
def list_categories(db: Session = Depends(get_db)) -> list[dict[str, Any]]:
    rows = db.execute(select(Category).order_by(Category.category_id)).scalars().all()
    return [
        {
            "category_id": c.category_id,
            "category_name": c.category_name,
            "description": c.description,
        }
        for c in rows
    ]
