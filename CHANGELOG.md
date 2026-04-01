# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Version numbering follows the project's own V0.0–V5.0 scheme documented in [docs/VERSION_HISTORY.md](docs/VERSION_HISTORY.md).

## [2.5.0] - 2026-04-01

### Added
- **SIPRI data staged** in `data/sipri/`: military expenditure (175 countries, 1949–2024), Top 100 arms companies (2,300 records, 271 companies), US arms transfers (3,006 records, 130 recipients)
- Flag emojis for countries across all pages
- Country-colored bar charts in analytics
- 25+ subcategory SVG icons (fighter, bomber, helicopter, tank, submarine, etc.)
- Production Docker deployment (`Dockerfile.prod`, `docker-compose.swarm.yml`, `start-prod.sh`)
- One-command deploy script (`deploy.sh`) with Docker Swarm support
- Cloudflare Tunnel routing to https://omhdb.luke-the-duke.com
- `docs/DEPLOY.md` deployment guide
- `AGENTS.md` for AI-assisted development standards
- `CONTRIBUTING.md` with contribution workflow and validation guidelines
- `SECURITY.md` vulnerability disclosure policy
- `.commitlintrc.json` for conventional commit enforcement
- `.github/dependabot.yml` for automated dependency updates
- `.github/workflows/release.yml` for automated releases with semantic-release
- `logging_config.py` with structured logging (structlog)
- Issue templates and PR template
- Dev container configuration (`.devcontainer/`)
- `backend/` directory: PostgreSQL/SQLAlchemy/Alembic/Redis/GraphQL scaffolding (not deployed; future V3.0 use)

### Changed
- Readability improvements across UI (contrast, font sizes, padding)
- POSIX-compatible startup script

### Infrastructure
- CI pipeline (`.github/workflows/ci.yml`) — Python 3.11/3.12 matrix, pytest, ruff, Docker build test
- Live deployment at https://omhdb.luke-the-duke.com (183 platforms, running healthy)

## [2.4.0] - 2026-03-15

### Added
- 18 new platforms (165 → 183 total): 6 Palantir software platforms, 12 Anduril systems
- New `software` domain category with 6 subcategories (c2-platform, ai-ml-platform, isr-analytics, data-integration, autonomy-os, cyber-platform)
- Role type classification for all 183 platforms (offensive/defensive/dual/support/intelligence)
- Role filter pills in Explorer toolbar
- Contractor dropdown filter with `/api/v1/manufacturers` endpoint
- Offensive/Defensive classification pie chart on Analytics page
- Font overhaul: Barlow Condensed (UI) + Share Tech Mono (data)
- Custom military SVG icons (`MilitaryIcons.tsx`) replacing generic Lucide icons

## [2.3.0] - 2026-03-12

### Added
- Complete visual overhaul: "liquid glass meets mid-1960s technical blueprint" aesthetic
- 3-pane intelligence console layout (sidebar, content, detail panel)
- Dense sortable table with 9 columns in Explorer
- Integrated right detail pane (replaces standalone detail route)
- Blueprint-themed Recharts with custom glass tooltips
- Single-theme (always dark) — removed light mode toggle

## [2.2.0] - 2026-03-08

### Added
- Full React frontend (`frontend/`): React 19 + Vite 6 + Tailwind CSS 3 + shadcn/ui
- Platform Explorer, Detail, Statistics Dashboard, Compare Tool
- Dark military/defense theme (olive/slate palette)
- Express backend proxy to FastAPI
- TanStack Query v5 for data fetching

## [2.1.0] - 2026-03-05

### Added
- 51-test suite (31 API tests + 20 data integrity tests)
- Pydantic response models for all endpoints
- CI/CD pipeline (GitHub Actions, Python 3.11/3.12 matrix)
- Multi-stage Dockerfile with non-root user and HEALTHCHECK

### Changed
- Data quality audit: fixed 5 XX country codes, normalized 53 manufacturer entries (130 → 95 unique)
- API hardening: request logging middleware, `X-Response-Time-Ms` header, global exception handler

## [2.0.0] - 2026-02-28

### Added
- 115 new US platforms (50 → 165 total) across air, land, sea, munitions
- FastAPI REST API with 7 endpoints: platforms (list/detail), stats, categories, conflicts, compare, health
- 12 filter parameters for platform queries (category, role, country, status, manufacturer, cost range, year range, search, conflict, sort)
- `docs/V2_US_RESEARCH_OUTLINE.md` research methodology

## [1.1.0] - 2026-02-20

### Added
- `docs/ARCHITECTURE.md`, `docs/ROADMAP.md`, `docs/TECH_STACK.md`
- `schemas/004_extended_schema.sql` — PostgreSQL extensions (pgvector, users, API keys, audit log)
- `docker/docker-compose.yml` — multi-service Docker Compose
- Via GitHub Copilot PR #1

## [1.0.0] - 2026-02-15

### Added
- 50 platforms researched from open sources (Wikipedia, GlobalSecurity, Military Factory, CRS reports)
- 4 export formats: JSON, CSV, SQLite, SQL dump
- `docs/sample_queries.sql` — 20+ analytical SQL queries
- Multi-nation coverage: US, Russia, China, France, UK, Germany, Israel, Sweden, South Korea

## [0.2.0] - 2026-02-10

### Added
- Python data collection framework: Wikipedia, Military Factory, GlobalSecurity collectors
- Data validator with country/currency/unit normalization and BLS CPI-U inflation adjustment
- Multi-format export pipeline (JSON → CSV + SQLite + SQL dump)

## [0.1.0] - 2026-02-05

### Added
- 11-table SQL schema with full referential integrity
- 15+ composite/single indexes
- Seed enums: 4 categories, 30+ subcategories, 50+ countries, 15 conflicts
- JSON Schema for platform entry validation

## [0.0.0] - 2026-02-01

### Added
- Initial project scaffold: repository, MIT license, directory structure, requirements.txt, README stub
