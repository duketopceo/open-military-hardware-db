from fastapi import APIRouter

from app.api.v1 import admin, auth, categories, conflicts, graphql, platforms

api_router = APIRouter()
api_router.include_router(platforms.router, prefix="/platforms", tags=["platforms"])
api_router.include_router(categories.router, prefix="/categories", tags=["categories"])
api_router.include_router(conflicts.router, prefix="/conflicts", tags=["conflicts"])
api_router.include_router(auth.router, prefix="/auth", tags=["auth"])
api_router.include_router(admin.router, prefix="/admin", tags=["admin"])
api_router.include_router(graphql.router, prefix="/graphql", tags=["graphql"])
