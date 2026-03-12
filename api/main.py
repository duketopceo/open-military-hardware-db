"""
Open Military Hardware Database — REST API
FastAPI application with read-only endpoints for querying the SQLite database.
V2: 165 platforms, flexible filters, pagination, comparison.
"""

from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from typing import Optional

from . import database as db

# ── App ──────────────────────────────────────────────────────────────────────

app = FastAPI(
    title="Open Military Hardware Database",
    description=(
        "Free, open-source REST API for military hardware data. "
        "165 platforms across air, land, sea, and munitions categories. "
        "All data sourced from public-domain references with full citations."
    ),
    version="2.0.0",
    license_info={"name": "MIT", "url": "https://opensource.org/licenses/MIT"},
    docs_url="/docs",
    redoc_url="/redoc",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ── Health ───────────────────────────────────────────────────────────────────

@app.get("/", tags=["meta"])
def root():
    """API root — basic info and navigation."""
    return {
        "name": "Open Military Hardware Database",
        "version": "2.0.0",
        "platforms": 165,
        "docs": "/docs",
        "endpoints": {
            "platforms": "/api/v1/platforms",
            "platform_detail": "/api/v1/platforms/{platform_id}",
            "stats": "/api/v1/stats",
            "categories": "/api/v1/categories",
            "conflicts": "/api/v1/conflicts",
            "compare": "/api/v1/compare",
        },
    }


@app.get("/health", tags=["meta"])
def health():
    """Health check for monitoring."""
    try:
        stats = db.get_stats()
        return {
            "status": "healthy",
            "database": "connected",
            "platforms_count": stats.get("platforms_count", 0),
        }
    except Exception as e:
        return JSONResponse(
            status_code=503,
            content={"status": "unhealthy", "error": str(e)},
        )


# ── Platforms ────────────────────────────────────────────────────────────────

@app.get("/api/v1/platforms", tags=["platforms"])
def list_platforms(
    category: Optional[str] = Query(None, description="Filter by category ID (e.g., 'air', 'land', 'sea', 'munition')"),
    subcategory: Optional[str] = Query(None, description="Filter by subcategory ID (e.g., 'fighter', 'tank')"),
    country: Optional[str] = Query(None, description="Filter by country code (e.g., 'US', 'RU')"),
    status: Optional[str] = Query(None, description="Filter by status ID (e.g., 'active', 'retired')"),
    manufacturer: Optional[str] = Query(None, description="Partial match on manufacturer name"),
    min_cost: Optional[float] = Query(None, description="Minimum unit cost in USD"),
    max_cost: Optional[float] = Query(None, description="Maximum unit cost in USD"),
    min_year: Optional[int] = Query(None, description="Earliest service entry year"),
    max_year: Optional[int] = Query(None, description="Latest service entry year"),
    search: Optional[str] = Query(None, description="Full-text search across name, designation, description"),
    conflict: Optional[str] = Query(None, description="Filter to platforms used in a specific conflict ID"),
    sort_by: str = Query("common_name", description="Sort field: common_name, entered_service_year, units_built, category_id, country_of_origin, manufacturer"),
    sort_order: str = Query("asc", description="Sort direction: asc or desc"),
    limit: int = Query(50, ge=1, le=200, description="Results per page (max 200)"),
    offset: int = Query(0, ge=0, description="Pagination offset"),
):
    """
    List and filter military platforms.

    Supports pagination, sorting, and multi-field filtering.
    Combine any number of filters — they are applied with AND logic.
    """
    return db.query_platforms(
        category=category,
        subcategory=subcategory,
        country=country,
        status=status,
        manufacturer=manufacturer,
        min_cost=min_cost,
        max_cost=max_cost,
        min_year=min_year,
        max_year=max_year,
        search=search,
        conflict=conflict,
        sort_by=sort_by,
        sort_order=sort_order,
        limit=limit,
        offset=offset,
    )


@app.get("/api/v1/platforms/{platform_id}", tags=["platforms"])
def get_platform(platform_id: str):
    """
    Get full detail for a single platform.

    Returns the platform record with all related data:
    specifications, economics, armaments, operators, conflicts, media, and sources.
    """
    result = db.get_platform_detail(platform_id)
    if not result:
        raise HTTPException(status_code=404, detail=f"Platform '{platform_id}' not found")
    return result


# ── Stats ────────────────────────────────────────────────────────────────────

@app.get("/api/v1/stats", tags=["analytics"])
def get_stats():
    """
    Database summary statistics.

    Returns record counts, category/country/status breakdowns, and era distribution.
    """
    return db.get_stats()


# ── Categories ───────────────────────────────────────────────────────────────

@app.get("/api/v1/categories", tags=["reference"])
def get_categories():
    """
    List all platform categories with their subcategories.

    Useful for building filter UIs or understanding the taxonomy.
    """
    return db.list_categories()


# ── Conflicts ────────────────────────────────────────────────────────────────

@app.get("/api/v1/conflicts", tags=["reference"])
def get_conflicts():
    """
    List all conflicts tracked in the database.

    Each conflict includes a count of associated platforms.
    """
    return db.list_conflicts()


# ── Compare ──────────────────────────────────────────────────────────────────

@app.get("/api/v1/compare", tags=["platforms"])
def compare_platforms(
    ids: str = Query(
        ...,
        description="Comma-separated platform IDs to compare (max 10). Example: ids=f-15e-strike-eagle,f-16-fighting-falcon",
    ),
):
    """
    Side-by-side comparison of multiple platforms.

    Pass comma-separated platform IDs. Returns full detail for each (max 10).
    """
    platform_ids = [pid.strip() for pid in ids.split(",") if pid.strip()]
    if not platform_ids:
        raise HTTPException(status_code=400, detail="Provide at least one platform ID")
    if len(platform_ids) > 10:
        raise HTTPException(status_code=400, detail="Maximum 10 platforms per comparison")

    results = db.compare_platforms(platform_ids)
    if not results:
        raise HTTPException(status_code=404, detail="No matching platforms found")

    return {
        "count": len(results),
        "platforms": results,
    }
