import json

import jsonschema
from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, Field
from sqlalchemy.orm import Session

from app.api.deps import get_db, require_admin
from app.paths import repo_root
from app.services.data_import import upsert_platform
from app.services.redis_cache import cache_delete_pattern

router = APIRouter()


def _platform_schema() -> dict:
    path = repo_root() / "schemas" / "platform_schema.json"
    with open(path, encoding="utf-8") as f:
        return json.load(f)


class BulkImportBody(BaseModel):
    platforms: list[dict] = Field(..., min_length=1)


@router.post("/import", status_code=status.HTTP_200_OK)
def bulk_import(
    body: BulkImportBody,
    _admin: dict = Depends(require_admin),
    db: Session = Depends(get_db),
) -> dict:
    schema = _platform_schema()
    for i, item in enumerate(body.platforms):
        try:
            jsonschema.validate(instance=item, schema=schema)
        except jsonschema.ValidationError as e:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Item {i}: {e.message}",
            ) from e
    for item in body.platforms:
        upsert_platform(db, item)
    cache_delete_pattern("pf:list:*")
    return {"imported": len(body.platforms)}
