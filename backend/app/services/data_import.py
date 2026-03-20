"""Insert/update/delete platforms from JSON-shaped dicts (matches export pipeline)."""

from __future__ import annotations

from typing import Any, Optional

from sqlalchemy import delete
from sqlalchemy.orm import Session

from app.db.models import (
    Armament,
    Economics,
    Media,
    Operator,
    Platform,
    PlatformConflict,
    Source,
    Specification,
)


def delete_platform_cascade(db: Session, platform_id: str) -> bool:
    p = db.get(Platform, platform_id)
    if not p:
        return False
    for model in (Source, Media, PlatformConflict, Operator, Armament, Specification, Economics):
        db.execute(delete(model).where(model.platform_id == platform_id))
    db.delete(p)
    return True


def upsert_platform(db: Session, p: dict[str, Any]) -> Platform:
    """Create or replace a platform and related rows (same shape as platforms.json items)."""
    pid = p.get("platform_id")
    if not pid:
        raise ValueError("platform_id required")

    delete_platform_cascade(db, pid)
    db.flush()

    platform = Platform(
        platform_id=pid,
        common_name=p["common_name"],
        official_designation=p.get("official_designation"),
        nato_reporting_name=p.get("nato_reporting_name"),
        category_id=p["category_id"],
        subcategory_id=p["subcategory_id"],
        manufacturer=p["manufacturer"],
        country_of_origin=p["country_of_origin"],
        development_start_year=p.get("development_start_year"),
        first_flight_year=p.get("first_flight_year"),
        entered_service_year=p.get("entered_service_year"),
        production_start_year=p.get("production_start_year"),
        production_end_year=p.get("production_end_year"),
        units_built=p.get("units_built"),
        units_built_approx=bool(p.get("units_built_approx", False)),
        status_id=p.get("status_id"),
        description=p.get("description"),
    )
    db.add(platform)
    db.flush()

    specs = p.get("specifications") or {}
    if specs:
        spec_kwargs: dict[str, Any] = {"platform_id": pid}
        for col in Specification.__table__.columns.keys():
            if col in ("spec_id", "platform_id", "created_at", "updated_at"):
                continue
            if col in specs:
                spec_kwargs[col] = specs[col]
        db.add(Specification(**spec_kwargs))

    econ = p.get("economics") or {}
    if econ:
        econ_kwargs: dict[str, Any] = {"platform_id": pid}
        for col in Economics.__table__.columns.keys():
            if col in ("econ_id", "platform_id", "created_at", "updated_at"):
                continue
            if col in econ:
                econ_kwargs[col] = econ[col]
        db.add(Economics(**econ_kwargs))

    for arm in p.get("armaments") or []:
        db.add(
            Armament(
                platform_id=pid,
                weapon_name=arm["weapon_name"],
                weapon_type=arm.get("weapon_type"),
                caliber_mm=arm.get("caliber_mm"),
                quantity=arm.get("quantity"),
                linked_munition_id=arm.get("linked_munition_id"),
                notes=arm.get("notes"),
            )
        )

    for op in p.get("operators") or []:
        db.add(
            Operator(
                platform_id=pid,
                country_code=op["country_code"],
                quantity=op.get("quantity"),
                quantity_approx=bool(op.get("quantity_approx", False)),
                service_entry_year=op.get("service_entry_year"),
                retirement_year=op.get("retirement_year"),
                variant=op.get("variant"),
                branch=op.get("branch"),
                notes=op.get("notes"),
            )
        )

    for conf in p.get("conflicts") or []:
        db.add(
            PlatformConflict(
                platform_id=pid,
                conflict_id=conf["conflict_id"],
                role=conf.get("role"),
                units_deployed=conf.get("units_deployed"),
                losses=conf.get("losses"),
                kills=conf.get("kills"),
                notes=conf.get("notes"),
                source_url=conf.get("source_url"),
            )
        )

    for med in p.get("media") or []:
        db.add(
            Media(
                platform_id=pid,
                media_type=med["media_type"],
                media_subtype=med.get("media_subtype"),
                url=med["url"],
                caption=med.get("caption"),
                attribution=med.get("attribution"),
                license=med.get("license"),
            )
        )

    for src in p.get("sources") or []:
        db.add(
            Source(
                platform_id=pid,
                source_name=src["source_name"],
                source_url=src["source_url"],
                access_date=src["access_date"],
                data_fields_sourced=src.get("data_fields_sourced"),
                reliability_rating=src.get("reliability_rating"),
                notes=src.get("notes"),
            )
        )

    try:
        db.commit()
    except Exception:
        db.rollback()
        raise
    db.refresh(platform)
    return platform


def merge_patch_platform(db: Session, platform_id: str, patch: dict[str, Any]) -> Optional[Platform]:
    """Shallow merge top-level fields; nested objects replace if present."""
    p = db.get(Platform, platform_id)
    if not p:
        return None
    for key in (
        "common_name",
        "official_designation",
        "nato_reporting_name",
        "category_id",
        "subcategory_id",
        "manufacturer",
        "country_of_origin",
        "development_start_year",
        "first_flight_year",
        "entered_service_year",
        "production_start_year",
        "production_end_year",
        "units_built",
        "status_id",
        "description",
    ):
        if key in patch:
            setattr(p, key, patch[key])
    if "units_built_approx" in patch:
        p.units_built_approx = bool(patch["units_built_approx"])
    db.commit()
    if "specifications" in patch and patch["specifications"] is not None:
        db.execute(delete(Specification).where(Specification.platform_id == platform_id))
        db.flush()
        specs = patch["specifications"]
        spec_kwargs: dict[str, Any] = {"platform_id": platform_id}
        for col in Specification.__table__.columns.keys():
            if col in ("spec_id", "platform_id", "created_at", "updated_at"):
                continue
            if col in specs:
                spec_kwargs[col] = specs[col]
        db.add(Specification(**spec_kwargs))
        db.commit()
    if "economics" in patch and patch["economics"] is not None:
        db.execute(delete(Economics).where(Economics.platform_id == platform_id))
        db.flush()
        econ = patch["economics"]
        econ_kwargs: dict[str, Any] = {"platform_id": platform_id}
        for col in Economics.__table__.columns.keys():
            if col in ("econ_id", "platform_id", "created_at", "updated_at"):
                continue
            if col in econ:
                econ_kwargs[col] = econ[col]
        db.add(Economics(**econ_kwargs))
        db.commit()
    db.refresh(p)
    return p
