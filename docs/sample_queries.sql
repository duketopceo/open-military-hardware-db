-- ============================================================================
-- SAMPLE QUERIES - Open Military Hardware Database
-- Compatible with SQLite and PostgreSQL
-- ============================================================================

-- ── BASIC LOOKUPS ─────────────────────────────────────────────────────

-- All platforms in a category
SELECT p.common_name, p.official_designation, s.subcategory_name, p.entered_service_year
FROM platforms p
JOIN subcategories s ON p.subcategory_id = s.subcategory_id
WHERE p.category_id = 'air'
ORDER BY p.entered_service_year DESC;

-- Search by name
SELECT * FROM platforms
WHERE common_name LIKE '%F-35%' OR official_designation LIKE '%F-35%';

-- Active 5th-gen fighters
SELECT p.common_name, p.manufacturer, co.country_name, p.entered_service_year
FROM platforms p
JOIN countries co ON p.country_of_origin = co.country_code
WHERE p.subcategory_id = 'fighter'
  AND p.entered_service_year >= 2005
  AND p.status_id IN ('in_production', 'active_service')
ORDER BY p.entered_service_year;


-- ── COST ANALYSIS ─────────────────────────────────────────────────────

-- Most expensive platforms (inflation-adjusted)
SELECT p.common_name, p.category_id,
       e.unit_cost_usd,
       e.unit_cost_year,
       e.unit_cost_adjusted_2024,
       e.maintenance_cost_per_hour
FROM platforms p
JOIN economics e ON p.platform_id = e.platform_id
WHERE e.unit_cost_adjusted_2024 IS NOT NULL
ORDER BY e.unit_cost_adjusted_2024 DESC
LIMIT 20;

-- Cost comparison by category
SELECT p.category_id,
       COUNT(*) as platform_count,
       ROUND(AVG(e.unit_cost_adjusted_2024), 0) as avg_cost_2024_usd,
       ROUND(MIN(e.unit_cost_adjusted_2024), 0) as min_cost,
       ROUND(MAX(e.unit_cost_adjusted_2024), 0) as max_cost
FROM platforms p
JOIN economics e ON p.platform_id = e.platform_id
WHERE e.unit_cost_adjusted_2024 IS NOT NULL
GROUP BY p.category_id
ORDER BY avg_cost_2024_usd DESC;

-- Program cost vs unit cost ratio
SELECT p.common_name,
       e.unit_cost_usd,
       e.program_cost_usd,
       CASE WHEN e.unit_cost_usd > 0
            THEN ROUND(e.program_cost_usd / e.unit_cost_usd, 1)
            ELSE NULL END as program_to_unit_ratio
FROM platforms p
JOIN economics e ON p.platform_id = e.platform_id
WHERE e.program_cost_usd IS NOT NULL AND e.unit_cost_usd IS NOT NULL
ORDER BY program_to_unit_ratio DESC;


-- ── COMBAT HISTORY ────────────────────────────────────────────────────

-- Platforms used in a specific conflict
SELECT p.common_name, p.category_id, pc.role, pc.units_deployed, pc.losses
FROM platform_conflicts pc
JOIN platforms p ON pc.platform_id = p.platform_id
WHERE pc.conflict_id = 'ukraine-2022'
ORDER BY p.category_id, p.common_name;

-- Most combat-proven platforms (by number of conflicts)
SELECT p.common_name, p.category_id, COUNT(pc.conflict_id) as conflict_count,
       GROUP_CONCAT(c.conflict_name, ', ') as conflicts
FROM platform_conflicts pc
JOIN platforms p ON pc.platform_id = p.platform_id
JOIN conflicts c ON pc.conflict_id = c.conflict_id
GROUP BY p.platform_id
ORDER BY conflict_count DESC
LIMIT 15;

-- Platforms with combat losses
SELECT p.common_name, c.conflict_name, pc.losses, pc.kills, pc.notes
FROM platform_conflicts pc
JOIN platforms p ON pc.platform_id = p.platform_id
JOIN conflicts c ON pc.conflict_id = c.conflict_id
WHERE pc.losses IS NOT NULL AND pc.losses > 0
ORDER BY pc.losses DESC;


-- ── OPERATOR ANALYSIS ─────────────────────────────────────────────────

-- Platforms by number of operating countries
SELECT p.common_name, p.category_id, COUNT(DISTINCT o.country_code) as operator_count,
       SUM(o.quantity) as total_units_in_service
FROM operators o
JOIN platforms p ON o.platform_id = p.platform_id
GROUP BY p.platform_id
ORDER BY operator_count DESC
LIMIT 15;

-- What does a specific country operate?
SELECT p.common_name, s.subcategory_name, o.quantity, o.variant, o.branch
FROM operators o
JOIN platforms p ON o.platform_id = p.platform_id
JOIN subcategories s ON p.subcategory_id = s.subcategory_id
WHERE o.country_code = 'US'
ORDER BY s.subcategory_name, p.common_name;

-- Countries with the most diverse arsenals
SELECT co.country_name, COUNT(DISTINCT o.platform_id) as platform_types,
       COUNT(DISTINCT p.category_id) as categories_covered
FROM operators o
JOIN countries co ON o.country_code = co.country_code
JOIN platforms p ON o.platform_id = p.platform_id
GROUP BY o.country_code
HAVING platform_types >= 3
ORDER BY platform_types DESC;


-- ── SPECIFICATIONS COMPARISON ─────────────────────────────────────────

-- Fastest platforms by category
SELECT p.common_name, p.category_id, sp.speed_max_kmh
FROM specifications sp
JOIN platforms p ON sp.platform_id = p.platform_id
WHERE sp.speed_max_kmh IS NOT NULL
ORDER BY sp.speed_max_kmh DESC
LIMIT 10;

-- Tank comparison: weight vs speed
SELECT p.common_name, sp.weight_max_kg, sp.speed_max_kmh, sp.range_km,
       sp.crew_min, e.unit_cost_adjusted_2024
FROM platforms p
JOIN specifications sp ON p.platform_id = sp.platform_id
LEFT JOIN economics e ON p.platform_id = e.platform_id
WHERE p.subcategory_id = 'mbt'
ORDER BY sp.weight_max_kg DESC;

-- Fighter comparison: speed, range, cost
SELECT p.common_name, sp.speed_max_kmh, sp.combat_radius_km, sp.ceiling_m,
       sp.radar_model, e.unit_cost_adjusted_2024
FROM platforms p
JOIN specifications sp ON p.platform_id = sp.platform_id
LEFT JOIN economics e ON p.platform_id = e.platform_id
WHERE p.subcategory_id = 'fighter'
ORDER BY e.unit_cost_adjusted_2024 DESC;

-- Naval vessels by displacement
SELECT p.common_name, s.subcategory_name, sp.displacement_tons, sp.speed_max_kmh,
       sp.range_km, sp.crew_min, e.unit_cost_adjusted_2024
FROM platforms p
JOIN specifications sp ON p.platform_id = sp.platform_id
JOIN subcategories s ON p.subcategory_id = s.subcategory_id
LEFT JOIN economics e ON p.platform_id = e.platform_id
WHERE p.category_id = 'sea'
  AND sp.displacement_tons IS NOT NULL
ORDER BY sp.displacement_tons DESC;


-- ── PRODUCTION & AGE ANALYSIS ─────────────────────────────────────────

-- Oldest platforms still in active service
SELECT p.common_name, p.entered_service_year,
       (2026 - p.entered_service_year) as years_in_service,
       p.status_id, p.units_built
FROM platforms p
WHERE p.entered_service_year IS NOT NULL
  AND p.status_id IN ('in_production', 'active_service')
ORDER BY p.entered_service_year ASC
LIMIT 15;

-- Production volume leaders
SELECT p.common_name, p.units_built, p.category_id,
       p.production_start_year, p.production_end_year,
       CASE WHEN p.production_end_year IS NOT NULL
            THEN p.production_end_year - p.production_start_year
            ELSE 2026 - p.production_start_year
       END as production_span_years
FROM platforms p
WHERE p.units_built IS NOT NULL
ORDER BY p.units_built DESC
LIMIT 15;

-- Platforms still in production
SELECT p.common_name, p.manufacturer, co.country_name,
       p.production_start_year,
       (2026 - p.production_start_year) as years_in_production,
       p.units_built
FROM platforms p
JOIN countries co ON p.country_of_origin = co.country_code
WHERE p.status_id = 'in_production'
ORDER BY p.production_start_year;


-- ── CROSS-CATEGORY ANALYSIS ──────────────────────────────────────────

-- Cost per ton (value density by platform type)
SELECT p.common_name, p.category_id,
       e.unit_cost_adjusted_2024,
       COALESCE(sp.weight_max_kg, sp.displacement_tons * 1000) as weight_kg,
       CASE WHEN COALESCE(sp.weight_max_kg, sp.displacement_tons * 1000) > 0
            THEN ROUND(e.unit_cost_adjusted_2024 / (COALESCE(sp.weight_max_kg, sp.displacement_tons * 1000) / 1000), 0)
            ELSE NULL END as cost_per_ton_usd
FROM platforms p
JOIN economics e ON p.platform_id = e.platform_id
JOIN specifications sp ON p.platform_id = sp.platform_id
WHERE e.unit_cost_adjusted_2024 IS NOT NULL
ORDER BY cost_per_ton_usd DESC
LIMIT 15;

-- Source coverage analysis
SELECT p.common_name, COUNT(s.source_id) as source_count,
       GROUP_CONCAT(DISTINCT s.source_name) as sources
FROM platforms p
LEFT JOIN sources s ON p.platform_id = s.platform_id
GROUP BY p.platform_id
ORDER BY source_count DESC;
