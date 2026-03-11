-- ============================================================================
-- OPEN MILITARY HARDWARE DATABASE - Schema v1.0
-- PostgreSQL / SQLite compatible (uses standard SQL types)
-- ============================================================================
-- Run order: This file first, then 002_create_indexes.sql, then 003_seed_enums.sql
-- ============================================================================

-- ----------------------------------------------------------------------------
-- ENUM-LIKE REFERENCE TABLES
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS categories (
    category_id     TEXT PRIMARY KEY,           -- 'air', 'land', 'sea', 'munition'
    category_name   TEXT NOT NULL,
    description     TEXT
);

CREATE TABLE IF NOT EXISTS subcategories (
    subcategory_id  TEXT PRIMARY KEY,           -- 'fighter', 'tank', 'destroyer', etc.
    category_id     TEXT NOT NULL REFERENCES categories(category_id),
    subcategory_name TEXT NOT NULL,
    description     TEXT
);

CREATE TABLE IF NOT EXISTS platform_statuses (
    status_id       TEXT PRIMARY KEY,           -- 'in_production', 'active_service', etc.
    status_name     TEXT NOT NULL,
    description     TEXT
);

CREATE TABLE IF NOT EXISTS countries (
    country_code    TEXT PRIMARY KEY,           -- ISO 3166-1 alpha-2
    country_name    TEXT NOT NULL,
    region          TEXT                         -- 'NATO', 'Asia-Pacific', etc.
);

-- ----------------------------------------------------------------------------
-- CORE PLATFORM TABLE
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS platforms (
    platform_id             TEXT PRIMARY KEY,       -- e.g. 'f-35a', 'm1a2-abrams'
    common_name             TEXT NOT NULL,
    official_designation    TEXT,
    nato_reporting_name     TEXT,                   -- for Russian/Chinese systems
    category_id             TEXT NOT NULL REFERENCES categories(category_id),
    subcategory_id          TEXT NOT NULL REFERENCES subcategories(subcategory_id),
    manufacturer            TEXT NOT NULL,
    country_of_origin       TEXT NOT NULL REFERENCES countries(country_code),
    development_start_year  INTEGER,
    first_flight_year       INTEGER,               -- air platforms
    entered_service_year    INTEGER,
    production_start_year   INTEGER,
    production_end_year     INTEGER,                -- NULL if still in production
    units_built             INTEGER,
    units_built_approx      BOOLEAN DEFAULT FALSE,  -- TRUE if estimate
    status_id               TEXT REFERENCES platform_statuses(status_id),
    description             TEXT,                    -- brief operational summary
    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- SPECIFICATIONS TABLE
-- One-to-one with platforms (core physical/performance specs)
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS specifications (
    spec_id                 INTEGER PRIMARY KEY AUTOINCREMENT,
    platform_id             TEXT NOT NULL UNIQUE REFERENCES platforms(platform_id),

    -- Dimensions (metric)
    length_m                REAL,
    width_m                 REAL,                   -- wingspan for aircraft
    height_m                REAL,
    displacement_tons       REAL,                   -- ships
    weight_empty_kg         REAL,
    weight_max_kg           REAL,                   -- MTOW for aircraft, combat weight for vehicles

    -- Performance
    speed_max_kmh           REAL,
    speed_cruise_kmh        REAL,
    range_km                REAL,
    combat_radius_km        REAL,                   -- aircraft
    endurance_hours         REAL,
    ceiling_m               REAL,                   -- service ceiling for aircraft
    dive_depth_m            REAL,                   -- submarines

    -- Crew & Capacity
    crew_min                INTEGER,
    crew_max                INTEGER,
    troop_capacity          INTEGER,                -- APCs, transports
    cargo_capacity_kg       REAL,

    -- Powerplant
    powerplant_type         TEXT,                   -- 'turbofan', 'diesel', 'nuclear', etc.
    powerplant_model        TEXT,
    powerplant_count        INTEGER,
    power_output            TEXT,                   -- '130,000 shp' or '29,000 lbf x2'
    thrust_to_weight        REAL,                   -- aircraft

    -- Protection (land/sea)
    armor_type              TEXT,                   -- 'composite', 'reactive', 'steel', etc.
    armor_thickness_mm      REAL,                   -- equivalent RHA where applicable

    -- Sensors & Electronics
    radar_model             TEXT,
    radar_type              TEXT,                   -- 'AESA', 'PESA', 'mechanically scanned'
    ew_suite                TEXT,                   -- electronic warfare
    fire_control_system     TEXT,

    -- Additional specs as JSON for extensibility
    additional_specs_json   TEXT,                   -- JSON blob for niche specs

    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- ECONOMICS TABLE
-- Unit costs, program costs, maintenance costs
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS economics (
    econ_id                 INTEGER PRIMARY KEY AUTOINCREMENT,
    platform_id             TEXT NOT NULL UNIQUE REFERENCES platforms(platform_id),

    unit_cost_usd           REAL,                   -- flyaway/unit cost in current USD
    unit_cost_year          INTEGER,                -- year of the cost figure
    unit_cost_adjusted_2024 REAL,                   -- inflation-adjusted to 2024 USD
    program_cost_usd        REAL,                   -- total program/development cost
    program_cost_year       INTEGER,
    development_cost_usd    REAL,                   -- R&D only
    maintenance_cost_per_hour REAL,                 -- cost per flight/operational hour
    cost_per_round_usd      REAL,                   -- munitions only
    cost_notes              TEXT,                    -- caveats, variant differences

    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- ARMAMENT TABLE
-- Links platforms to their weapon systems (many-to-many with munitions)
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS armaments (
    armament_id             INTEGER PRIMARY KEY AUTOINCREMENT,
    platform_id             TEXT NOT NULL REFERENCES platforms(platform_id),
    weapon_name             TEXT NOT NULL,           -- 'M256 120mm smoothbore', 'AIM-120 AMRAAM'
    weapon_type             TEXT,                    -- 'cannon', 'missile', 'bomb', 'torpedo'
    caliber_mm              REAL,
    quantity                INTEGER,                 -- number of hardpoints/tubes/mounts
    linked_munition_id      TEXT REFERENCES platforms(platform_id),  -- if munition is its own platform
    notes                   TEXT
);

-- ----------------------------------------------------------------------------
-- OPERATORS TABLE
-- Which countries operate which platforms
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS operators (
    operator_id             INTEGER PRIMARY KEY AUTOINCREMENT,
    platform_id             TEXT NOT NULL REFERENCES platforms(platform_id),
    country_code            TEXT NOT NULL REFERENCES countries(country_code),
    quantity                INTEGER,
    quantity_approx         BOOLEAN DEFAULT FALSE,
    service_entry_year      INTEGER,
    retirement_year         INTEGER,                 -- NULL if still active
    variant                 TEXT,                    -- specific variant operated
    branch                  TEXT,                    -- 'Air Force', 'Navy', 'Army', etc.
    notes                   TEXT,

    UNIQUE(platform_id, country_code, variant, branch)
);

-- ----------------------------------------------------------------------------
-- CONFLICTS TABLE
-- Combat history for platforms
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS conflicts (
    conflict_id             TEXT PRIMARY KEY,        -- 'gulf-war-1991', 'ukraine-2022'
    conflict_name           TEXT NOT NULL,
    start_year              INTEGER NOT NULL,
    end_year                INTEGER,                 -- NULL if ongoing
    region                  TEXT,
    description             TEXT
);

CREATE TABLE IF NOT EXISTS platform_conflicts (
    id                      INTEGER PRIMARY KEY AUTOINCREMENT,
    platform_id             TEXT NOT NULL REFERENCES platforms(platform_id),
    conflict_id             TEXT NOT NULL REFERENCES conflicts(conflict_id),
    role                    TEXT,                     -- 'air superiority', 'CAS', 'convoy escort'
    units_deployed          INTEGER,
    losses                  INTEGER,
    kills                   INTEGER,                  -- air-to-air, vehicle kills, etc.
    notes                   TEXT,
    source_url              TEXT,

    UNIQUE(platform_id, conflict_id, role)
);

-- ----------------------------------------------------------------------------
-- MEDIA TABLE
-- Images, diagrams, videos with attribution
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS media (
    media_id                INTEGER PRIMARY KEY AUTOINCREMENT,
    platform_id             TEXT NOT NULL REFERENCES platforms(platform_id),
    media_type              TEXT NOT NULL,            -- 'image', 'diagram', 'video', 'document'
    media_subtype           TEXT,                     -- 'profile', 'top-down', 'interior', 'action'
    url                     TEXT NOT NULL,
    local_path              TEXT,                     -- path in /images/ if downloaded
    caption                 TEXT,
    attribution             TEXT,                     -- photographer/source credit
    license                 TEXT,                     -- 'public-domain', 'cc-by-sa-4.0', etc.
    source_url              TEXT,                     -- page where media was found
    width_px                INTEGER,
    height_px               INTEGER,
    downloaded              BOOLEAN DEFAULT FALSE,
    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- SOURCES TABLE
-- Citation tracking for all data
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS sources (
    source_id               INTEGER PRIMARY KEY AUTOINCREMENT,
    platform_id             TEXT NOT NULL REFERENCES platforms(platform_id),
    source_name             TEXT NOT NULL,            -- 'Wikipedia', 'GlobalSecurity.org', etc.
    source_url              TEXT NOT NULL,
    access_date             TEXT NOT NULL,            -- ISO 8601 date
    data_fields_sourced     TEXT,                     -- which fields this source covers
    reliability_rating      TEXT,                     -- 'primary', 'secondary', 'tertiary'
    notes                   TEXT
);

-- ----------------------------------------------------------------------------
-- DATA VERSIONING / CHANGELOG
-- Track all spec updates over time
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS changelog (
    change_id               INTEGER PRIMARY KEY AUTOINCREMENT,
    platform_id             TEXT NOT NULL REFERENCES platforms(platform_id),
    table_name              TEXT NOT NULL,
    field_name              TEXT NOT NULL,
    old_value               TEXT,
    new_value               TEXT,
    changed_by              TEXT DEFAULT 'system',
    change_reason           TEXT,
    changed_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
