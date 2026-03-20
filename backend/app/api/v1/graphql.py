from typing import Optional

import strawberry
from sqlalchemy import select
from strawberry.fastapi import GraphQLRouter

from app.db.models import Platform
from app.db.session import SessionLocal


@strawberry.type
class GqlPlatform:
    platform_id: str
    common_name: str
    category_id: str
    subcategory_id: str
    manufacturer: str
    country_of_origin: str


@strawberry.type
class Query:
    @strawberry.field
    def platforms(self, limit: int = 50, offset: int = 0, category_id: Optional[str] = None) -> list[GqlPlatform]:
        db = SessionLocal()
        try:
            stmt = select(Platform).order_by(Platform.common_name).limit(min(limit, 500)).offset(offset)
            if category_id:
                stmt = stmt.where(Platform.category_id == category_id)
            rows = db.execute(stmt).scalars().all()
            return [
                GqlPlatform(
                    platform_id=r.platform_id,
                    common_name=r.common_name,
                    category_id=r.category_id,
                    subcategory_id=r.subcategory_id,
                    manufacturer=r.manufacturer,
                    country_of_origin=r.country_of_origin,
                )
                for r in rows
            ]
        finally:
            db.close()

    @strawberry.field
    def platform(self, platform_id: str) -> Optional[GqlPlatform]:
        db = SessionLocal()
        try:
            r = db.get(Platform, platform_id)
            if not r:
                return None
            return GqlPlatform(
                platform_id=r.platform_id,
                common_name=r.common_name,
                category_id=r.category_id,
                subcategory_id=r.subcategory_id,
                manufacturer=r.manufacturer,
                country_of_origin=r.country_of_origin,
            )
        finally:
            db.close()


schema = strawberry.Schema(query=Query)
router = GraphQLRouter(schema, path="")
