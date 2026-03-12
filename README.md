# Open Military Hardware Database

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![SQLite](https://img.shields.io/badge/database-SQLite-green.svg)](https://sqlite.org/)
[![FastAPI](https://img.shields.io/badge/api-FastAPI-009688.svg)](https://fastapi.tiangolo.com/)
[![Platforms](https://img.shields.io/badge/platforms-165-orange.svg)](#dataset-coverage)
[![Version](https://img.shields.io/badge/version-2.0-brightgreen.svg)](docs/ROADMAP.md)

A comprehensive, open-source relational database of military hardware systems spanning air, land, sea, and munitions categories. Includes a REST API with flexible filtering, pagination, and side-by-side comparison. Designed for researchers, journalists, analysts, and defense enthusiasts.

All data sourced from publicly available, open-source information with full citation tracking.

---

## Documentation

| Document | Description |
|----------|-------------|
| **[ROADMAP.md](docs/ROADMAP.md)** | Version roadmap (V1.0 → V5.0) with features and timeline |
| **[ARCHITECTURE.md](docs/ARCHITECTURE.md)** | Full system architecture and technical design |
| **[TECH_STACK.md](docs/TECH_STACK.md)** | Complete open-source technology catalog |
| **[V2 Research Outline](docs/V2_US_RESEARCH_OUTLINE.md)** | Full methodology for V2 US systems research |

---

## Quick Start

```bash
# Clone the repo
git clone https://github.com/duketopceo/open-military-hardware-db.git
cd open-military-hardware-db

# Install dependencies
pip install -r requirements.txt

# Start the API
uvicorn api.main:app --reload

# Visit http://localhost:8000/docs for interactive Swagger UI
```

### Direct database access

```bash
# Query the SQLite database
sqlite3 data/sql/military_hardware.db "SELECT common_name, category_id FROM platforms LIMIT 10;"

# Or use the JSON data
python3 -c "import json; data=json.load(open('data/json/platforms.json')); print(f'{len(data)} platforms loaded')"
```

## REST API (V2)

The FastAPI backend provides full read access to the database with filtering, pagination, and comparison.

### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/v1/platforms` | List & filter platforms (pagination, sorting, multi-field filters) |
| `GET` | `/api/v1/platforms/{id}` | Full platform detail with specs, economics, armaments, operators, conflicts, sources |
| `GET` | `/api/v1/stats` | Database summary statistics and breakdowns |
| `GET` | `/api/v1/categories` | All categories with subcategories |
| `GET` | `/api/v1/conflicts` | All tracked conflicts with platform counts |
| `GET` | `/api/v1/compare?ids=a,b,c` | Side-by-side comparison (max 10) |
| `GET` | `/health` | Health check |

### Query Parameters for `/api/v1/platforms`

| Parameter | Type | Description |
|-----------|------|-------------|
| `category` | string | Filter by category: `air`, `land`, `sea`, `munition` |
| `subcategory` | string | Filter by subcategory: `fighter`, `tank`, `destroyer`, `missile`, etc. |
| `country` | string | Filter by ISO country code: `US`, `RU`, `CN`, etc. |
| `status` | string | Filter by status: `active`, `retired`, `in-production` |
| `manufacturer` | string | Partial match on manufacturer name |
| `min_cost` / `max_cost` | float | Unit cost range (USD) |
| `min_year` / `max_year` | int | Service entry year range |
| `search` | string | Full-text search across name, designation, description |
| `conflict` | string | Filter to platforms used in a specific conflict |
| `sort_by` | string | Sort field (default: `common_name`) |
| `sort_order` | string | `asc` or `desc` |
| `limit` | int | Results per page, 1-200 (default: 50) |
| `offset` | int | Pagination offset |

### Example API Calls

```bash
# All US fighter jets
curl "http://localhost:8000/api/v1/platforms?country=US&subcategory=fighter"

# Platforms used in the Russo-Ukrainian War
curl "http://localhost:8000/api/v1/platforms?conflict=ukraine-2022"

# Search for stealth platforms
curl "http://localhost:8000/api/v1/platforms?search=stealth"

# Compare F-35 and F-22
curl "http://localhost:8000/api/v1/compare?ids=f-35a-lightning-ii,f-22-raptor"

# Database statistics
curl "http://localhost:8000/api/v1/stats"
```

## Dataset Coverage

**Version 2.0 — 165 Platforms (US-focused expansion)**

| Category | Count | Examples |
|----------|-------|---------|
| Air | 46 | F-35A, F-22, F-15EX, B-21 Raider, V-22 Osprey, MQ-9 Reaper, AH-64 Apache, C-17, E-2D Hawkeye |
| Land | 67 | M1A2 SEPv3 Abrams, M2A4 Bradley, Stryker, HIMARS, Patriot PAC-3, M777, JLTV, AMPV, M4A1 |
| Sea | 23 | Gerald R. Ford-class, Arleigh Burke, Virginia-class, America-class, Zumwalt, Freedom LCS |
| Munitions | 29 | AIM-120D AMRAAM, AIM-9X, AGM-158 JASSM, Tomahawk, JDAM, GBU-43 MOAB, Javelin, Mk 48 ADCAP |

**Breakdown by country:** 138 US, 6 Russia, 4 France, 3 UK, 2 China, 2 Germany, plus others.

**Data completeness per platform:**
- Specifications (dimensions, performance, crew): 100%
- Economics (unit cost, program cost): 93%
- Source citations: 100%
- Media references: 100%
- Operator data: 100%
- Combat history: 76%

## Data Fields

Each platform entry includes:

| Field Group | Key Fields |
|-------------|-----------|
| **Identity** | platform_id, common_name, official_designation, NATO reporting name |
| **Classification** | category (air/land/sea/munition), subcategory (fighter/tank/destroyer/missile/etc.) |
| **Origin** | manufacturer, country_of_origin (ISO 3166-1), development/service/production years |
| **Specifications** | length, width, height, weight, speed, range, ceiling, crew, powerplant, radar, armor |
| **Economics** | unit_cost_usd, unit_cost_adjusted_2024, program_cost, maintenance_cost_per_hour |
| **Operational** | operators (countries + quantities), conflicts (with roles and losses), status |
| **Media** | image URLs with attribution and licensing (primarily Wikimedia Commons CC-BY-SA) |
| **Sources** | Cited URLs with access dates and reliability ratings |

## Database Schema

```
┌─────────────┐     ┌──────────────┐     ┌───────────┐
│  platforms   │────▶│specifications│     │ categories│
│             │────▶│  economics   │     │subcategories│
│  (core)     │     └──────────────┘     │ statuses  │
│             │                          │ countries │
│             │     ┌──────────────┐     └───────────┘
│             │────▶│  armaments   │
│             │────▶│  operators   │
│             │────▶│platform_conflicts│──▶│conflicts│
│             │────▶│    media     │
│             │────▶│   sources    │
│             │────▶│  changelog   │
└─────────────┘     └──────────────┘
```

**11 tables** with full referential integrity. See `schemas/` for complete DDL.

## Project Structure

```
open-military-hardware-db/
├── api/
│   ├── __init__.py
│   ├── main.py                    # FastAPI app with REST endpoints
│   └── database.py                # SQLite query layer
├── data/
│   ├── csv/
│   │   └── platforms.csv           # Flat CSV export (48 columns)
│   ├── json/
│   │   └── platforms.json          # Full nested JSON dataset (165 platforms)
│   └── sql/
│       ├── military_hardware.db    # SQLite database file
│       └── military_hardware_dump.sql  # SQL text dump
├── schemas/
│   ├── 001_create_tables.sql       # Table definitions
│   ├── 002_create_indexes.sql      # Performance indexes
│   ├── 003_seed_enums.sql          # Reference data (categories, countries, conflicts)
│   ├── 004_extended_schema.sql     # PostgreSQL extension (pgvector, RAG tables)
│   └── platform_schema.json        # JSON Schema for validation
├── scripts/
│   ├── collectors/
│   │   ├── base_collector.py       # Abstract base with rate limiting & caching
│   │   ├── wikipedia_collector.py  # Wikipedia infobox parser
│   │   ├── military_factory_collector.py
│   │   └── globalsecurity_collector.py
│   ├── validators/
│   │   └── data_validator.py       # Cleaning, normalization, inflation adjustment
│   ├── exporters/
│   │   └── export_all.py           # JSON → CSV + SQLite + SQL dump
│   └── build_seed_dataset.py       # Seed data transformation pipeline
├── docker/
│   ├── docker-compose.yml          # Multi-service container setup
│   └── .env.example                # Environment template
├── docs/
│   ├── ROADMAP.md                  # Version roadmap
│   ├── ARCHITECTURE.md             # System architecture
│   ├── TECH_STACK.md               # Technology catalog
│   ├── V2_US_RESEARCH_OUTLINE.md   # V2 research methodology
│   └── sample_queries.sql          # 20+ analytical SQL queries
├── requirements.txt
├── LICENSE
└── README.md
```

## Sample Queries

```sql
-- Most expensive platforms (inflation-adjusted to 2024 USD)
SELECT p.common_name, p.category_id,
       e.unit_cost_adjusted_2024
FROM platforms p
JOIN economics e ON p.platform_id = e.platform_id
WHERE e.unit_cost_adjusted_2024 IS NOT NULL
ORDER BY e.unit_cost_adjusted_2024 DESC LIMIT 5;
```

```sql
-- Platforms used in the Russo-Ukrainian War
SELECT p.common_name, p.category_id, pc.role
FROM platform_conflicts pc
JOIN platforms p ON pc.platform_id = p.platform_id
WHERE pc.conflict_id = 'ukraine-2022'
ORDER BY p.category_id;
```

```sql
-- Fighter jet comparison: speed, range, cost
SELECT p.common_name, sp.speed_max_kmh, sp.combat_radius_km,
       e.unit_cost_adjusted_2024
FROM platforms p
JOIN specifications sp ON p.platform_id = sp.platform_id
LEFT JOIN economics e ON p.platform_id = e.platform_id
WHERE p.subcategory_id = 'fighter'
ORDER BY e.unit_cost_adjusted_2024 DESC;
```

See `docs/sample_queries.sql` for 20+ more analytical queries.

## Data Collection Framework

The `/scripts/collectors/` module provides a pluggable collector framework:

```python
from scripts.collectors.wikipedia_collector import WikipediaCollector

collector = WikipediaCollector(rate_limit=0.5)
data = collector.collect_platform("https://en.wikipedia.org/wiki/F-35_Lightning_II")
```

Each collector implements:
- **Rate limiting** — configurable requests per second
- **Disk caching** — 7-day HTTP response cache
- **Source tracking** — automatic citation generation
- **Error handling** — graceful failure with logging

### Data Validation

```python
from scripts.validators.data_validator import clean_and_validate

entry, warnings = clean_and_validate(raw_data)
# Normalizes: country names → ISO codes, currencies → USD, units → metric
# Validates: against JSON schema, year range sanity, spec bounds
# Adjusts: inflation using BLS CPI-U data (1950–2024)
```

## Export Formats

| Format | File | Use Case |
|--------|------|----------|
| JSON | `data/json/platforms.json` | Programmatic access, full nested structure |
| CSV | `data/csv/platforms.csv` | Spreadsheet analysis, Tableau/Power BI import |
| SQLite | `data/sql/military_hardware.db` | SQL queries, relational analysis |
| SQL Dump | `data/sql/military_hardware_dump.sql` | PostgreSQL import, version control |
| REST API | `http://localhost:8000/docs` | Interactive access, application integration |

## Version History

| Version | Status | Focus |
|---------|--------|-------|
| **V1.0** | Complete | Core schema, 50 platforms, Python toolchain, 4 export formats |
| **V2.0** | Complete | 165 platforms (US focus), FastAPI REST API, expanded research |
| **V3.0** | Planned | RAG system, vector embeddings, semantic search |
| **V4.0** | Planned | Full UI/UX, dashboards, visualizations |
| **V5.0** | Planned | Community features, multi-user, contributions |

### Technology Stack

```
┌─────────────────────────────────────────────────────────────────┐
│                    100% OPEN SOURCE STACK                        │
├─────────────────────────────────────────────────────────────────┤
│  API:       FastAPI • SQLite (PostgreSQL upgrade path)          │
│  Frontend:  Next.js • React • Tailwind CSS • shadcn/ui (V4)    │
│  AI/RAG:    LangChain • ChromaDB • Ollama • Sentence-BERT (V3) │
│  DevOps:    Docker • Kubernetes • Traefik • Prometheus          │
└─────────────────────────────────────────────────────────────────┘
```

## Data Sources

All data is collected from publicly available, open-source information:

- [Wikipedia](https://en.wikipedia.org/) (CC-BY-SA) — Primary reference
- [GlobalSecurity.org](https://www.globalsecurity.org/) — Operational details
- [Military Factory](https://www.militaryfactory.com/) — Specifications
- Official defense ministry publications and press releases
- Congressional Research Service reports
- Jane's (publicly available summaries)

## Contributing

Contributions welcome. To add a new platform:

1. Create a JSON entry matching `schemas/platform_schema.json`
2. Include at least 2 independent sources with URLs
3. Use metric units and USD for costs
4. Specify the year for all cost figures
5. Submit a PR with the platform added to `data/json/platforms.json`

## License

MIT License. See [LICENSE](LICENSE) for details.

Data is sourced from public domain and CC-BY-SA licensed materials. Image attributions are tracked in the media table. When using this dataset, please cite the original sources listed in each platform's `sources` array.

## Disclaimer

This database is for educational and research purposes only. All information is derived from publicly available sources. Specifications may vary by variant, production block, and configuration. Cost figures are approximate and may reflect different contract terms or quantities. Combat data reflects open-source reporting and may be incomplete.
