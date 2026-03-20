import json
from typing import Any, Optional

import jsonschema
from fastapi import APIRouter, Body, Depends, HTTPException, Query, status
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.api.deps import get_db, require_admin
from app.db.models import Platform
from app.paths import repo_root
from app.schemas.platform import PaginatedPlatforms, PlatformSummary, platform_detail_dict
from app.services.data_import import delete_platform_cascade, merge_patch_platform, upsert_platform
from app.services.redis_cache import cache_delete_pattern, cache_get_json, cache_set_json

router = APIRouter()


def _platform_schema() -> dict:
    root = Path(__file__).resolve().parents[4]
    with open(root / "schemas" / "platform_schema.json", encoding="utf-8") as f:
        return json.load(f)


@router.get("", response_model=PaginatedPlatforms)
def list_platforms(
    db: Session = Depends(get_db),
    limit: int = Query(50, ge=1, le=500),
    offset: int = Query(0, ge=0),
    category_id: Optional[str] = None,
) -> dict[str, Any]:
    cache_key = f"pf:list:{category_id or ''}:{limit}:{offset}"
    cached = cache_get_json(cache_key)
    if cached is not None:
        return cached
    base = select(Platform)
    count_stmt = select(func.count()).select_from(Platform)
    if category_id:
        base = base.where(Platform.category_id == category_id)
        count_stmt = count_stmt.where(Platform.category_id == category_id)
    total = db.execute(count_stmt).scalar_one()
    stmt = base.order_by(Platform.common_name).limit(limit).offset(offset)
    rows = db.execute(stmt).scalars().all()
    result = {
        "items": [PlatformSummary.model_validate(r).model_dump() for r in rows],
        "total": total,
        "limit": limit,
        "offset": offset,
    }
    cache_set_json(cache_key, result, ttl_seconds=60)
    return result


@router.get("/{platform_id}")
def get_platform(platform_id: str, db: Session = Depends(get_db)) -> dict[str, Any]:
    p = db.get(Platform, platform_id)
    if not p:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Platform not found")
    return platform_detail_dict(p)


@router.post("", status_code=status.HTTP_201_CREATED, dependencies=[Depends(require_admin)])
def create_platform(
    body: dict = Body(...),
    db: Session = Depends(get_db),
) -> dict[str, Any]:
    try:
        jsonschema.validate(instance=body, schema=_platform_schema())
    except jsonschema.ValidationError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=e.message) from e
    upsert_platform(db, body)
    cache_delete_pattern("pf:list:*")
    p = db.get(Platform, body["platform_id"])
    return platform_detail_dict(p)


@router.patch("/{platform_id}", dependencies=[Depends(require_admin)])
def patch_platform(
    platform_id: str,
    body: dict = Body(...),
    db: Session = Depends(get_db),
) -> dict[str, Any]:
    p = merge_patch_platform(db, platform_id, body)
    if not p:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Platform not found")
    cache_delete_pattern("pf:list:*")
    db.refresh(p)
    return platform_detail_dict(db.get(Platform, platform_id))


@router.delete("/{platform_id}", status_code=status.HTTP_204_NO_CONTENT, dependencies=[Depends(require_admin)])
def remove_platform(platform_id: str, db: Session = Depends(get_db)) -> None:
    if not delete_platform_cascade(db, platform_id):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Platform not found")
    db.commit()
    cache_delete_pattern("pf:list:*")
