# Open Military Hardware Database

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![SQLite](https://img.shields.io/badge/database-SQLite-green.svg)](https://sqlite.org/)
[![FastAPI](https://img.shields.io/badge/api-FastAPI-009688.svg)](https://fastapi.tiangolo.com/)
[![React](https://img.shields.io/badge/frontend-React_19-61DAFB.svg)](https://react.dev/)
[![Platforms](https://img.shields.io/badge/platforms-183-orange.svg)](#dataset-coverage)
[![Version](https://img.shields.io/badge/version-2.4-brightgreen.svg)](docs/VERSION_HISTORY.md)

A comprehensive, open-source relational database of military hardware systems — air, land, sea, munitions, and software platforms. Ships with a FastAPI REST API, a React intelligence console frontend, and structured data in JSON/CSV/SQLite formats.

Built for researchers, journalists, analysts, and defense enthusiasts. All data sourced from publicly available, open-source information with full citation tracking.

**[Live Beta →](https://www.perplexity.ai/computer/a/omhdb-open-military-hardware-d-ksEvrWm1RKewmplKmdSK9g)**

---

## What's In the Box

- **183 platforms** across 5 domains (air, land, sea, munitions, software)
- **675 source citations** — every data point traceable to public sources
- **REST API** with filtering, pagination, sorting, comparison, and manufacturer endpoints
- **Intelligence console UI** — dark blueprint aesthetic, 3-pane layout, role/contractor filters
- **Structured exports** — JSON, CSV, SQLite, SQL dump
- **Data collection framework** — pluggable collectors with rate limiting, caching, and validation
- **Role classification** — offensive/defensive/dual/support/intelligence for every platform
- **Contractor filtering** — filter by manufacturer (Boeing, Lockheed Martin, Anduril, Palantir, etc.)

---

## Screenshots

The frontend is a dark-mode intelligence console with a blueprint + liquid glass aesthetic:

- **Platform Explorer** — dense sortable table with domain, role, and contractor filters
- **Analytics Dashboard** — KPI cards, domain distribution, role classification, era breakdown
- **Compare Tool** — side-by-side spec comparison for up to 10 platforms
- **Detail Panel** — specifications, economics, armaments, operators, combat history, sources

---

## Quick Start

```bash
# Clone
git clone https://github.com/duketopceo/open-military-hardware-db.git
cd open-military-hardware-db

# Start the API
pip install -r requirements.txt
uvicorn api.main:app --host 0.0.0.0 --port 8000

# Start the frontend
cd frontend
npm install
npm run dev
# → http://localhost:5000
```

### Direct database access

```bash
# SQLite
sqlite3 data/sql/military_hardware.db "SELECT common_name, category_id, role_type FROM platforms LIMIT 10;"

# JSON
python3 -c "import json; data=json.load(open('data/json/platforms.json')); print(f'{len(data)} platforms loaded')"
```

---

## REST API (v2.4)

Interactive docs at `http://localhost:8000/docs` (Swagger UI).

### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/v1/platforms` | List & filter platforms (pagination, sorting, multi-field filters) |
| `GET` | `/api/v1/platforms/{id}` | Full platform detail with specs, economics, armaments, operators, conflicts, sources |
| `GET` | `/api/v1/stats` | Database statistics with category, status, and role type breakdowns |
| `GET` | `/api/v1/categories` | All categories with subcategories |
| `GET` | `/api/v1/conflicts` | All tracked conflicts with platform counts |
| `GET` | `/api/v1/compare?ids=a,b,c` | Side-by-side comparison (max 10) |
| `GET` | `/api/v1/manufacturers` | All manufacturers with platform counts and categories |
| `GET` | `/health` | Health check |

### Query Parameters for `/api/v1/platforms`

| Parameter | Type | Description |
|-----------|------|-------------|
| `category` | string | Filter by domain: `air`, `land`, `sea`, `munition`, `software` |
| `subcategory` | string | Filter by subcategory: `fighter`, `tank`, `destroyer`, `c2-platform`, etc. |
| `role_type` | string | Filter by role: `offensive`, `defensive`, `dual`, `support`, `intelligence` |
| `country` | string | Filter by ISO country code: `US`, `RU`, `CN`, etc. |
| `status` | string | Filter by status: `active`, `retired`, `in-production` |
| `manufacturer` | string | Partial match on manufacturer name |
| `min_cost` / `max_cost` | float | Unit cost range (USD) |
| `min_year` / `max_year` | int | Service entry year range |
| `search` | string | Full-text search across name, designation, description |
| `conflict` | string | Filter to platforms used in a specific conflict |
| `sort_by` | string | Sort field (default: `common_name`) |
| `sort_order` | string | `asc` or `desc` |
| `limit` | int | Results per page, 1–200 (default: 50) |
| `offset` | int | Pagination offset |

### Example API Calls

```bash
# All US fighter jets
curl "http://localhost:8000/api/v1/platforms?country=US&subcategory=fighter"

# Defensive systems only
curl "http://localhost:8000/api/v1/platforms?role_type=defensive"

# Anduril platforms
curl "http://localhost:8000/api/v1/platforms?manufacturer=Anduril"

# Software platforms
curl "http://localhost:8000/api/v1/platforms?category=software"

# Compare F-35 and F-22
curl "http://localhost:8000/api/v1/compare?ids=f-35a-lightning-ii,f-22-raptor"

# All manufacturers with counts
curl "http://localhost:8000/api/v1/manufacturers"
```

---

## Dataset Coverage

**V2.4 — 183 Platforms**

| Domain | Count | Examples |
|--------|-------|---------|
| Air | 53 | F-35A, F-22, F-15EX, B-21 Raider, V-22 Osprey, MQ-9 Reaper, AH-64 Apache, Fury, Ghost-X |
| Land | 68 | M1A2 SEPv3 Abrams, M2A4 Bradley, Stryker, HIMARS, Patriot PAC-3, Sentry Tower |
| Sea | 25 | Gerald R. Ford-class, Virginia-class, Zumwalt, Dive-LD, Ghost Shark |
| Munitions | 29 | AIM-120D AMRAAM, AIM-9X, AGM-158 JASSM, Tomahawk, Javelin, Altius-600, Roadrunner |
| Software | 8 | Palantir Gotham, Palantir Foundry, Palantir AIP, Lattice OS, Lattice Mission Autonomy |

**Role classification:**

| Role | Count | Description |
|------|-------|-------------|
| Offensive | 122 | Primary strike/attack platforms |
| Dual | 21 | Multi-role offensive + defensive capability |
| Support | 19 | Logistics, transport, C2, ISR support |
| Defensive | 15 | Air defense, counter-UAS, missile defense |
| Intelligence | 6 | ISR, surveillance, reconnaissance |

**Key manufacturers:** Boeing (20), Lockheed Martin (18), Anduril Industries (12), Raytheon/RTX (10), BAE Systems (8), General Dynamics (8+), Northrop Grumman (6), Palantir Technologies (6).

**Data completeness per platform:**
- Specifications: 94%
- Economics (unit cost, program cost): 86%
- Source citations: 100%
- Media references: 90%
- Operator data: 100%
- Combat history: 76%

---

## Data Fields

Each platform entry includes:

| Field Group | Key Fields |
|-------------|-----------|
| **Identity** | platform_id, common_name, official_designation, NATO reporting name |
| **Classification** | category (air/land/sea/munition/software), subcategory, role_type (offensive/defensive/dual/support/intelligence) |
| **Origin** | manufacturer, country_of_origin (ISO 3166-1), development/service/production years |
| **Specifications** | length, width, height, weight, speed, range, ceiling, crew, powerplant, radar, armor |
| **Economics** | unit_cost_usd, unit_cost_adjusted_2024, program_cost, maintenance_cost_per_hour |
| **Operational** | operators (countries + quantities), conflicts (with roles and losses), status |
| **Media** | image URLs with attribution and licensing |
| **Sources** | Cited URLs with access dates and reliability ratings |

---

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

---

## Project Structure

```
open-military-hardware-db/
├── api/
│   ├── main.py                    # FastAPI app (v2.4) with REST endpoints
│   ├── database.py                # SQLite query layer with role/manufacturer support
│   └── models.py                  # Pydantic response models
├── frontend/
│   ├── client/
│   │   └── src/
│   │       ├── components/
│   │       │   ├── AppShell.tsx       # 3-pane intelligence console layout
│   │       │   └── MilitaryIcons.tsx  # Custom SVG military icon system
│   │       ├── pages/
│   │       │   ├── explorer.tsx       # Platform explorer with filters + detail pane
│   │       │   ├── stats.tsx          # Analytics dashboard (6 charts)
│   │       │   └── compare.tsx        # Side-by-side comparison tool
│   │       └── lib/api.ts             # API client + category/status configs
│   └── server/index.ts            # Express proxy server
├── data/
│   ├── csv/platforms.csv          # Flat CSV export
│   ├── json/platforms.json        # Full nested JSON dataset
│   ├── sql/military_hardware.db   # SQLite database
│   └── migrations/                # Version migration scripts
├── schemas/                       # SQL DDL + JSON Schema
├── scripts/
│   ├── collectors/                # Pluggable data collection framework
│   ├── validators/                # Data cleaning + normalization
│   └── exporters/                 # Multi-format export pipeline
├── docs/
│   ├── VERSION_HISTORY.md         # Detailed version-by-version record
│   ├── ARCHITECTURE.md            # System architecture
│   ├── TECH_STACK.md              # Technology catalog
│   └── ROADMAP.md                 # Version roadmap
├── tests/                         # 51-test suite
├── docker/                        # Container setup
├── requirements.txt
└── README.md
```

---

## Technology Stack

```
┌──────────────────────────────────────────────────────────────┐
│                    100% OPEN SOURCE STACK                     │
├──────────────────────────────────────────────────────────────┤
│  Data:      SQLite • JSON • CSV • SQL                        │
│  API:       FastAPI • Pydantic • uvicorn                     │
│  Frontend:  React 19 • TypeScript • Vite • Tailwind CSS 3   │
│             shadcn/ui • Recharts • wouter • TanStack Query   │
│  Fonts:     Barlow Condensed • Share Tech Mono               │
│  Testing:   pytest (51 tests) • GitHub Actions CI            │
│  DevOps:    Docker • Docker Compose                          │
└──────────────────────────────────────────────────────────────┘
```

---

## Sample Queries

```sql
-- Most expensive platforms (inflation-adjusted)
SELECT p.common_name, p.category_id, e.unit_cost_adjusted_2024
FROM platforms p
JOIN economics e ON p.platform_id = e.platform_id
WHERE e.unit_cost_adjusted_2024 IS NOT NULL
ORDER BY e.unit_cost_adjusted_2024 DESC LIMIT 5;

-- All defensive systems
SELECT p.common_name, p.category_id, p.manufacturer
FROM platforms p
WHERE p.role_type = 'defensive'
ORDER BY p.entered_service_year DESC;

-- Software platforms by manufacturer
SELECT p.common_name, p.manufacturer, p.role_type
FROM platforms p
WHERE p.category_id = 'software'
ORDER BY p.manufacturer;

-- Platforms by Anduril Industries
SELECT p.common_name, p.category_id, p.role_type, p.entered_service_year
FROM platforms p
WHERE p.manufacturer = 'Anduril Industries'
ORDER BY p.entered_service_year;
```

See `docs/sample_queries.sql` for 20+ more analytical queries.

---

## Data Sources

All data is collected from publicly available, open-source information:

- [Wikipedia](https://en.wikipedia.org/) (CC-BY-SA) — Primary reference
- [GlobalSecurity.org](https://www.globalsecurity.org/) — Operational details
- [Military Factory](https://www.militaryfactory.com/) — Specifications
- Official defense ministry publications and press releases
- Congressional Research Service (CRS) reports
- Company investor presentations and product pages (Anduril, Palantir, etc.)

---

## Documentation

| Document | Description |
|----------|-------------|
| **[VERSION_HISTORY.md](docs/VERSION_HISTORY.md)** | Complete version-by-version record (V0.0 → V2.4) with future roadmap |
| **[ARCHITECTURE.md](docs/ARCHITECTURE.md)** | System architecture and technical design |
| **[TECH_STACK.md](docs/TECH_STACK.md)** | Technology catalog |
| **[ROADMAP.md](docs/ROADMAP.md)** | Version roadmap (V3.0 → V5.0) |
| **[V2 Research Outline](docs/V2_US_RESEARCH_OUTLINE.md)** | Methodology for V2 US systems research |

---

## Contributing

Contributions welcome. To add a new platform:

1. Create a JSON entry matching `schemas/platform_schema.json`
2. Include at least 2 independent sources with URLs
3. Use metric units and USD for costs
4. Specify the year for all cost figures
5. Submit a PR with the platform added to `data/json/platforms.json`

---

## Version History

| Version | Name | Status |
|---------|------|--------|
| **V0.0–V0.2** | Scaffold → Toolchain | Complete |
| **V1.0** | Seed Dataset | Complete — 50 platforms, schema, toolchain |
| **V1.1** | Framework | Complete — Architecture docs, Docker, extended schema |
| **V2.0** | US Expansion | Complete — 165 platforms, FastAPI REST API |
| **V2.1** | Hardening | Complete — 51-test suite, data quality audit, CI |
| **V2.2** | Beta UI | Complete — React frontend, dark military theme |
| **V2.3** | Intel Console | Complete — Blueprint + liquid glass redesign, 3-pane layout |
| **V2.4** | Software & Roles | Complete — Palantir/Anduril platforms, role classification, contractor filters, military fonts/icons |
| **V3.0** | Global Data | Planned — 500+ platforms, NATO allies + adversaries, PostgreSQL |
| **V3.1** | Intelligence | Planned — Vector embeddings, semantic search, RAG |
| **V4.0** | Experience | Planned — Next.js, interactive dashboards, maps |
| **V5.0** | Community | Planned — Auth, contributions, public API keys |

See [VERSION_HISTORY.md](docs/VERSION_HISTORY.md) for full details.

---

## License

MIT License. See [LICENSE](LICENSE) for details.

Data is sourced from public domain and CC-BY-SA licensed materials. Image attributions are tracked in the media table. When using this dataset, please cite the original sources listed in each platform's `sources` array.

## Disclaimer

This database is for educational and research purposes only. All information is derived from publicly available sources. Specifications may vary by variant, production block, and configuration. Cost figures are approximate and may reflect different contract terms or quantities. Combat data reflects open-source reporting and may be incomplete.
