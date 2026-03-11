-- ============================================================================
-- INDEXES for performance optimization
-- Run after 001_create_tables.sql
-- ============================================================================

-- Platform lookups
CREATE INDEX IF NOT EXISTS idx_platforms_category ON platforms(category_id);
CREATE INDEX IF NOT EXISTS idx_platforms_subcategory ON platforms(subcategory_id);
CREATE INDEX IF NOT EXISTS idx_platforms_country ON platforms(country_of_origin);
CREATE INDEX IF NOT EXISTS idx_platforms_status ON platforms(status_id);
CREATE INDEX IF NOT EXISTS idx_platforms_manufacturer ON platforms(manufacturer);
CREATE INDEX IF NOT EXISTS idx_platforms_service_year ON platforms(entered_service_year);
CREATE INDEX IF NOT EXISTS idx_platforms_common_name ON platforms(common_name);

-- Specifications
CREATE INDEX IF NOT EXISTS idx_specs_platform ON specifications(platform_id);

-- Economics
CREATE INDEX IF NOT EXISTS idx_econ_platform ON economics(platform_id);
CREATE INDEX IF NOT EXISTS idx_econ_unit_cost ON economics(unit_cost_usd);

-- Operators
CREATE INDEX IF NOT EXISTS idx_operators_platform ON operators(platform_id);
CREATE INDEX IF NOT EXISTS idx_operators_country ON operators(country_code);

-- Armaments
CREATE INDEX IF NOT EXISTS idx_armaments_platform ON armaments(platform_id);
CREATE INDEX IF NOT EXISTS idx_armaments_munition ON armaments(linked_munition_id);

-- Conflicts
CREATE INDEX IF NOT EXISTS idx_platform_conflicts_platform ON platform_conflicts(platform_id);
CREATE INDEX IF NOT EXISTS idx_platform_conflicts_conflict ON platform_conflicts(conflict_id);

-- Media
CREATE INDEX IF NOT EXISTS idx_media_platform ON media(platform_id);
CREATE INDEX IF NOT EXISTS idx_media_type ON media(media_type);

-- Sources
CREATE INDEX IF NOT EXISTS idx_sources_platform ON sources(platform_id);

-- Changelog
CREATE INDEX IF NOT EXISTS idx_changelog_platform ON changelog(platform_id);
CREATE INDEX IF NOT EXISTS idx_changelog_date ON changelog(changed_at);
