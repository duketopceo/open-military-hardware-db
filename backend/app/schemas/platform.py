from datetime import datetime
from typing import Any, Optional

from pydantic import BaseModel, ConfigDict, Field


class PlatformSummary(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    platform_id: str
    common_name: str
    official_designation: Optional[str] = None
    category_id: str
    subcategory_id: str
    manufacturer: str
    country_of_origin: str
    status_id: Optional[str] = None
    entered_service_year: Optional[int] = None


def _orm_to_dict(obj: Any) -> dict[str, Any]:
    from sqlalchemy import inspect as sa_inspect

    out: dict[str, Any] = {}
    for col in sa_inspect(obj).mapper.column_attrs:
        v = getattr(obj, col.key)
        if isinstance(v, datetime):
            out[col.key] = v.isoformat() if v else None
        else:
            out[col.key] = v
    return out


def platform_detail_dict(platform: Any) -> dict[str, Any]:
    """Build nested dict for GET /platforms/{id} matching JSON dataset shape."""
    base = _orm_to_dict(platform)
    spec = platform.specifications
    econ = platform.economics
    base["specifications"] = _orm_to_dict(spec) if spec else None
    if base["specifications"]:
        base["specifications"].pop("spec_id", None)
        base["specifications"].pop("platform_id", None)
        base["specifications"].pop("created_at", None)
        base["specifications"].pop("updated_at", None)
        base["specifications"] = {k: v for k, v in base["specifications"].items() if v is not None}
    base["economics"] = _orm_to_dict(econ) if econ else None
    if base["economics"]:
        base["economics"].pop("econ_id", None)
        base["economics"].pop("platform_id", None)
        base["economics"].pop("created_at", None)
        base["economics"].pop("updated_at", None)
        base["economics"] = {k: v for k, v in base["economics"].items() if v is not None}
    base["armaments"] = []
    for a in platform.armaments:
        d = _orm_to_dict(a)
        for k in ("armament_id", "platform_id"):
            d.pop(k, None)
        base["armaments"].append({k: v for k, v in d.items() if v is not None})
    base["operators"] = []
    for o in platform.operators:
        d = _orm_to_dict(o)
        for k in ("operator_id", "platform_id"):
            d.pop(k, None)
        base["operators"].append({k: v for k, v in d.items() if v is not None})
    base["conflicts"] = []
    for pc in platform.platform_conflicts:
        d = {
            "conflict_id": pc.conflict_id,
            "role": pc.role,
            "units_deployed": pc.units_deployed,
            "losses": pc.losses,
            "kills": pc.kills,
            "notes": pc.notes,
            "source_url": pc.source_url,
        }
        base["conflicts"].append({k: v for k, v in d.items() if v is not None})
    base["media"] = []
    for m in platform.media:
        d = _orm_to_dict(m)
        for k in ("media_id", "platform_id", "local_path", "source_url", "width_px", "height_px", "downloaded", "created_at"):
            d.pop(k, None)
        base["media"].append({k: v for k, v in d.items() if v is not None})
    base["sources"] = []
    for s in platform.sources:
        d = _orm_to_dict(s)
        for k in ("source_id", "platform_id"):
            d.pop(k, None)
        base["sources"].append({k: v for k, v in d.items() if v is not None})
    for k in ("created_at", "updated_at"):
        base.pop(k, None)
    return base


class PaginatedPlatforms(BaseModel):
    items: list[PlatformSummary]
    total: int
    limit: int = Field(ge=1, le=500)
    offset: int = Field(ge=0)
