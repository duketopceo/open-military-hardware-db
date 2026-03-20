from datetime import datetime
from typing import TYPE_CHECKING, Optional

from sqlalchemy import (
    Boolean,
    DateTime,
    Float,
    ForeignKey,
    Integer,
    String,
    Text,
    UniqueConstraint,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base

if TYPE_CHECKING:
    pass


class Category(Base):
    __tablename__ = "categories"

    category_id: Mapped[str] = mapped_column(String, primary_key=True)
    category_name: Mapped[str] = mapped_column(String, nullable=False)
    description: Mapped[Optional[str]] = mapped_column(Text, nullable=True)


class Subcategory(Base):
    __tablename__ = "subcategories"

    subcategory_id: Mapped[str] = mapped_column(String, primary_key=True)
    category_id: Mapped[str] = mapped_column(String, ForeignKey("categories.category_id"), nullable=False)
    subcategory_name: Mapped[str] = mapped_column(String, nullable=False)
    description: Mapped[Optional[str]] = mapped_column(Text, nullable=True)


class PlatformStatus(Base):
    __tablename__ = "platform_statuses"

    status_id: Mapped[str] = mapped_column(String, primary_key=True)
    status_name: Mapped[str] = mapped_column(String, nullable=False)
    description: Mapped[Optional[str]] = mapped_column(Text, nullable=True)


class Country(Base):
    __tablename__ = "countries"

    country_code: Mapped[str] = mapped_column(String, primary_key=True)
    country_name: Mapped[str] = mapped_column(String, nullable=False)
    region: Mapped[Optional[str]] = mapped_column(Text, nullable=True)


class Conflict(Base):
    __tablename__ = "conflicts"

    conflict_id: Mapped[str] = mapped_column(String, primary_key=True)
    conflict_name: Mapped[str] = mapped_column(String, nullable=False)
    start_year: Mapped[int] = mapped_column(Integer, nullable=False)
    end_year: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    region: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    description: Mapped[Optional[str]] = mapped_column(Text, nullable=True)

    platform_conflicts: Mapped[list["PlatformConflict"]] = relationship(back_populates="conflict_rel")


class Platform(Base):
    __tablename__ = "platforms"

    platform_id: Mapped[str] = mapped_column(String, primary_key=True)
    common_name: Mapped[str] = mapped_column(String, nullable=False)
    official_designation: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    nato_reporting_name: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    category_id: Mapped[str] = mapped_column(String, ForeignKey("categories.category_id"), nullable=False)
    subcategory_id: Mapped[str] = mapped_column(String, ForeignKey("subcategories.subcategory_id"), nullable=False)
    manufacturer: Mapped[str] = mapped_column(String, nullable=False)
    country_of_origin: Mapped[str] = mapped_column(String, ForeignKey("countries.country_code"), nullable=False)
    development_start_year: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    first_flight_year: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    entered_service_year: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    production_start_year: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    production_end_year: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    units_built: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    units_built_approx: Mapped[bool] = mapped_column(Boolean, default=False)
    status_id: Mapped[Optional[str]] = mapped_column(String, ForeignKey("platform_statuses.status_id"), nullable=True)
    description: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    created_at: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)
    updated_at: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)

    specifications: Mapped[Optional["Specification"]] = relationship(back_populates="platform", uselist=False)
    economics: Mapped[Optional["Economics"]] = relationship(back_populates="platform", uselist=False)
    armaments: Mapped[list["Armament"]] = relationship(
        "Armament",
        back_populates="platform",
        primaryjoin="Armament.platform_id==Platform.platform_id",
        foreign_keys="Armament.platform_id",
    )
    operators: Mapped[list["Operator"]] = relationship(back_populates="platform")
    platform_conflicts: Mapped[list["PlatformConflict"]] = relationship(back_populates="platform")
    media: Mapped[list["Media"]] = relationship(back_populates="platform")
    sources: Mapped[list["Source"]] = relationship(back_populates="platform")


class Specification(Base):
    __tablename__ = "specifications"

    spec_id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    platform_id: Mapped[str] = mapped_column(String, ForeignKey("platforms.platform_id"), unique=True, nullable=False)
    length_m: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    width_m: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    height_m: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    displacement_tons: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    weight_empty_kg: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    weight_max_kg: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    speed_max_kmh: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    speed_cruise_kmh: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    range_km: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    combat_radius_km: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    endurance_hours: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    ceiling_m: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    dive_depth_m: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    crew_min: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    crew_max: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    troop_capacity: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    cargo_capacity_kg: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    powerplant_type: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    powerplant_model: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    powerplant_count: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    power_output: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    thrust_to_weight: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    armor_type: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    armor_thickness_mm: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    radar_model: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    radar_type: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    ew_suite: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    fire_control_system: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    additional_specs_json: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    created_at: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)
    updated_at: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)

    platform: Mapped["Platform"] = relationship(back_populates="specifications")


class Economics(Base):
    __tablename__ = "economics"

    econ_id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    platform_id: Mapped[str] = mapped_column(String, ForeignKey("platforms.platform_id"), unique=True, nullable=False)
    unit_cost_usd: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    unit_cost_year: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    unit_cost_adjusted_2024: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    program_cost_usd: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    program_cost_year: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    development_cost_usd: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    maintenance_cost_per_hour: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    cost_per_round_usd: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    cost_notes: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    created_at: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)
    updated_at: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)

    platform: Mapped["Platform"] = relationship(back_populates="economics")


class Armament(Base):
    __tablename__ = "armaments"

    armament_id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    platform_id: Mapped[str] = mapped_column(String, ForeignKey("platforms.platform_id"), nullable=False)
    weapon_name: Mapped[str] = mapped_column(String, nullable=False)
    weapon_type: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    caliber_mm: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    quantity: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    linked_munition_id: Mapped[Optional[str]] = mapped_column(String, ForeignKey("platforms.platform_id"), nullable=True)
    notes: Mapped[Optional[str]] = mapped_column(Text, nullable=True)

    platform: Mapped["Platform"] = relationship(
        "Platform",
        back_populates="armaments",
        foreign_keys="Armament.platform_id",
    )


class Operator(Base):
    __tablename__ = "operators"

    operator_id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    platform_id: Mapped[str] = mapped_column(String, ForeignKey("platforms.platform_id"), nullable=False)
    country_code: Mapped[str] = mapped_column(String, ForeignKey("countries.country_code"), nullable=False)
    quantity: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    quantity_approx: Mapped[bool] = mapped_column(Boolean, default=False)
    service_entry_year: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    retirement_year: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    variant: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    branch: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    notes: Mapped[Optional[str]] = mapped_column(Text, nullable=True)

    __table_args__ = (UniqueConstraint("platform_id", "country_code", "variant", "branch", name="uq_operator"),)

    platform: Mapped["Platform"] = relationship(back_populates="operators")


class PlatformConflict(Base):
    __tablename__ = "platform_conflicts"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    platform_id: Mapped[str] = mapped_column(String, ForeignKey("platforms.platform_id"), nullable=False)
    conflict_id: Mapped[str] = mapped_column(String, ForeignKey("conflicts.conflict_id"), nullable=False)
    role: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    units_deployed: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    losses: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    kills: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    notes: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    source_url: Mapped[Optional[str]] = mapped_column(Text, nullable=True)

    __table_args__ = (UniqueConstraint("platform_id", "conflict_id", "role", name="uq_platform_conflict"),)

    platform: Mapped["Platform"] = relationship(back_populates="platform_conflicts")
    conflict_rel: Mapped["Conflict"] = relationship(back_populates="platform_conflicts")


class Media(Base):
    __tablename__ = "media"

    media_id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    platform_id: Mapped[str] = mapped_column(String, ForeignKey("platforms.platform_id"), nullable=False)
    media_type: Mapped[str] = mapped_column(String, nullable=False)
    media_subtype: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    url: Mapped[str] = mapped_column(Text, nullable=False)
    local_path: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    caption: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    attribution: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    license: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    source_url: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    width_px: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    height_px: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    downloaded: Mapped[bool] = mapped_column(Boolean, default=False)
    created_at: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)

    platform: Mapped["Platform"] = relationship(back_populates="media")


class Source(Base):
    __tablename__ = "sources"

    source_id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    platform_id: Mapped[str] = mapped_column(String, ForeignKey("platforms.platform_id"), nullable=False)
    source_name: Mapped[str] = mapped_column(String, nullable=False)
    source_url: Mapped[str] = mapped_column(Text, nullable=False)
    access_date: Mapped[str] = mapped_column(String, nullable=False)
    data_fields_sourced: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    reliability_rating: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    notes: Mapped[Optional[str]] = mapped_column(Text, nullable=True)

    platform: Mapped["Platform"] = relationship(back_populates="sources")
