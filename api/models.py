"""
Pydantic response models for the military hardware API.
Provides structured, documented responses for all endpoints.
"""
from pydantic import BaseModel, ConfigDict, Field
from typing import Optional


# ── Shared ───────────────────────────────────────────────────────────────────

class ErrorResponse(BaseModel):
    """Standard error response (RFC 7807 inspired)."""
    detail: str = Field(..., description="Human-readable error description")
    status_code: int = Field(..., description="HTTP status code")
    type: str = Field(default="about:blank", description="Error type URI")


# ── Platform Models ──────────────────────────────────────────────────────────

class PlatformSummary(BaseModel):
    """Platform summary for list views."""
    platform_id: str
    common_name: str
    official_designation: Optional[str] = None
    nato_reporting_name: Optional[str] = None
    category_id: str
    subcategory_id: Optional[str] = None
    country_of_origin: str
    manufacturer: str
    status_id: Optional[str] = None
    entered_service_year: Optional[int] = None
    units_built: Optional[int] = None
    description: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)


class PlatformListResponse(BaseModel):
    """Paginated platform list response."""
    platforms: list[dict] = Field(..., description="List of platform records")
    total: int = Field(..., description="Total matching records")
    limit: int = Field(..., description="Page size")
    offset: int = Field(..., description="Current offset")


class Specification(BaseModel):
    """Platform technical specifications."""
    model_config = ConfigDict(extra="allow", from_attributes=True)


class Economics(BaseModel):
    """Platform cost and economic data."""
    model_config = ConfigDict(extra="allow", from_attributes=True)


class PlatformDetail(BaseModel):
    """Full platform detail with all related data."""
    platform_id: str
    common_name: str
    official_designation: Optional[str] = None
    category_id: str
    subcategory_id: Optional[str] = None
    country_of_origin: str
    manufacturer: str
    specifications: dict = Field(default_factory=dict)
    economics: dict = Field(default_factory=dict)
    armaments: list[dict] = Field(default_factory=list)
    operators: list[dict] = Field(default_factory=list)
    conflicts: list[dict] = Field(default_factory=list)
    media: list[dict] = Field(default_factory=list)
    sources: list[dict] = Field(default_factory=list)

    model_config = ConfigDict(extra="allow", from_attributes=True)


# ── Stats ────────────────────────────────────────────────────────────────────

class StatsResponse(BaseModel):
    """Database summary statistics."""
    platforms_count: int
    specifications_count: int
    economics_count: int
    armaments_count: int
    operators_count: int
    platform_conflicts_count: int
    media_count: int
    sources_count: int
    categories: dict[str, int]
    countries: dict[str, int]
    statuses: dict[str, int]
    eras: dict[str, int]


# ── Categories ───────────────────────────────────────────────────────────────

class Subcategory(BaseModel):
    subcategory_id: str
    category_id: str
    subcategory_name: str
    description: Optional[str] = None


class Category(BaseModel):
    category_id: str
    category_name: str
    description: Optional[str] = None
    subcategories: list[Subcategory] = Field(default_factory=list)


# ── Conflicts ────────────────────────────────────────────────────────────────

class Conflict(BaseModel):
    conflict_id: str
    conflict_name: str
    start_year: Optional[int] = None
    end_year: Optional[int] = None
    region: Optional[str] = None
    description: Optional[str] = None
    platform_count: int = 0


# ── Compare ──────────────────────────────────────────────────────────────────

class CompareResponse(BaseModel):
    """Side-by-side platform comparison."""
    count: int
    platforms: list[dict]


# ── Health ───────────────────────────────────────────────────────────────────

class HealthResponse(BaseModel):
    status: str
    database: str
    platforms_count: int


class RootResponse(BaseModel):
    name: str
    version: str
    platforms: int
    docs: str
    endpoints: dict[str, str]
