# Open Military Hardware Database — Version History & Roadmap

> Definitive version-by-version plan from V0.0 through V5.0.
> Each version builds on the last. Every version ships working code.

---

## Version Summary

| Version | Name | Status | What Ships |
|---------|------|--------|------------|
| **V0.0** | Scaffold | Complete | Repo, license, .gitignore, directory structure, README stub |
| **V0.1** | Schema | Complete | 11-table SQL schema, indexes, seed enums, JSON Schema |
| **V0.2** | Toolchain | Complete | Python collectors, validators, exporters (no data yet) |
| **V1.0** | Seed | Complete | 50 platforms researched, JSON/CSV/SQLite/SQL exports, sample queries |
| **V1.1** | Framework | Complete | Copilot PR merged — ARCHITECTURE.md, ROADMAP.md, TECH_STACK.md, Docker compose, extended PostgreSQL schema |
| **V2.0** | US Expansion | Complete | 165 platforms (115 new US systems), FastAPI REST API (6 endpoints), updated README |
| **V2.1** | Hardening | **Next Up** | Tests, CI/CD, data quality audit, Dockerfile, API rate limiting |
| **V3.0** | Intelligence | Planned | RAG pipeline, vector embeddings, semantic search, Ollama integration |
| **V4.0** | Experience | Planned | Next.js frontend, dashboards, visualizations, maps |
| **V5.0** | Community | Planned | Auth, user contributions, moderation, hosted deployment |

---

## V0.0 — Scaffold (Complete)

**Commit:** `ca157a8 feat: initialize project structure and scaffolding`

**What shipped:**
- GitHub repository at `duketopceo/open-military-hardware-db`
- MIT LICENSE
- `.gitignore` (Python, Node, IDE, OS files)
- Directory structure with `.gitkeep` placeholders:
  ```
  data/{json,csv,sql}/
  schemas/
  scripts/{collectors,validators,exporters}/
  docs/
  images/{profiles,diagrams,action}/
  ```
- `requirements.txt` with core Python dependencies
- README.md skeleton

**Lines of code:** ~150
**Data:** None

---

## V0.1 — Schema (Complete)

**Commit:** `13d4fdd feat: add relational database schema (11 tables)`

**What shipped:**
- `schemas/001_create_tables.sql` — 11 normalized tables:
  - `categories`, `subcategories`, `platform_statuses`, `countries` (reference)
  - `platforms` (core entity)
  - `specifications`, `economics` (1:1 detail)
  - `armaments`, `operators`, `platform_conflicts`, `media`, `sources`, `changelog` (1:many)
  - `conflicts` (standalone reference)
- `schemas/002_create_indexes.sql` — Composite and single-column indexes for query performance
- `schemas/003_seed_enums.sql` — Seed data for categories (air/land/sea/munition), 30+ subcategories, 50+ countries, 15 conflicts, platform statuses
- `schemas/platform_schema.json` — JSON Schema for validating platform entries

**Tables:** 11 + 4 reference tables
**Indexes:** 15+
**Lines of code:** ~600

---

## V0.2 — Toolchain (Complete)

**Commits:**
- `a2afcea feat: add pluggable data collection framework`
- `501f73f feat: add data validation and normalization layer`
- `76f1699 feat: add multi-format export pipeline`
- `e7e6d34 feat: add seed dataset transformation pipeline`

**What shipped:**
- **Collectors** (`scripts/collectors/`):
  - `base_collector.py` — Abstract base class with rate limiting (configurable req/sec), 7-day HTTP disk cache, automatic source citation generation, error handling
  - `wikipedia_collector.py` — Wikipedia infobox parser, extracts specifications/history/media
  - `military_factory_collector.py` — MilitaryFactory.com specification extractor
  - `globalsecurity_collector.py` — GlobalSecurity.org data collector
- **Validators** (`scripts/validators/`):
  - `data_validator.py` — Country name → ISO code normalization, currency → USD conversion, metric unit standardization, JSON Schema validation, year range sanity checks, BLS CPI-U inflation adjustment (1950–2024)
- **Exporters** (`scripts/exporters/`):
  - `export_all.py` — JSON → CSV (flat 48-column), SQLite (full schema), SQL dump pipeline
- **Build pipeline** (`scripts/build_seed_dataset.py`):
  - Transforms raw wide_research CSV output into schema-compliant JSON format

**Lines of code:** ~2,200
**Data:** None (tools only)

---

## V1.0 — Seed Dataset (Complete)

**Commits:**
- `063bcaa data: add V1 seed dataset (50 platforms, 4 categories)`
- `f4ff251 docs: add sample queries and analytical examples`

**What shipped:**
- **50 platforms** researched from open sources:
  - Air (15): F-35A, F-22, Su-57, B-2, MQ-9 Reaper, AH-64 Apache, C-17, etc.
  - Land (16): M1A2 Abrams, Leopard 2, T-72, HIMARS, Patriot, S-400, Iron Dome, etc.
  - Sea (10): Nimitz-class, Arleigh Burke, Virginia-class, Type 055, FREMM, etc.
  - Munitions (9): AIM-120 AMRAAM, Tomahawk, Javelin, JDAM, Hellfire, Storm Shadow, etc.
- **4 export formats:** JSON (platforms.json), CSV (platforms.csv), SQLite (military_hardware.db), SQL dump
- **20+ sample queries** (`docs/sample_queries.sql`)
- Multi-nation coverage: US, Russia, China, France, UK, Germany, Israel, Sweden, South Korea

**Data quality:**
| Metric | Coverage |
|--------|----------|
| Specifications | 100% |
| Economics | 96% |
| Sources | 100% |
| Media | 100% |
| Operators | 95% |
| Combat history | 70% |

**Database size:** ~200 KB (SQLite)

---

## V1.1 — Framework (Complete)

**Commit:** `d93aa5e Add comprehensive application framework, roadmap, architecture, and tech stack documentation`

**What shipped:** (via GitHub Copilot PR #1, merged)
- `docs/ARCHITECTURE.md` — 1,155-line system architecture document covering all layers
- `docs/ROADMAP.md` — Full V1–V5 roadmap with tech stack tables, schema evolution, release criteria
- `docs/TECH_STACK.md` — 448-line complete open-source technology catalog
- `schemas/004_extended_schema.sql` — PostgreSQL extensions: pgvector, users table, API keys, audit log, RAG tables (embeddings, conversations, messages), embedding jobs
- `docker/docker-compose.yml` — Multi-service setup (PostgreSQL, Redis, API, frontend, ChromaDB, Ollama, Traefik, Prometheus, Grafana)
- `docker/.env.example` — Environment variable template

**Lines of code:** ~3,000 (docs + config)

---

## V2.0 — US Expansion + API (Complete)

**Commits:**
- `4c0c69c data: expand to 165 platforms with US-focused V2 research`
- `06626c6 docs: add V2 US systems research outline and methodology`
- `a618066 feat: add FastAPI REST API with 6 endpoints`
- `dad293c docs: update README for V2`

**What shipped:**

### Data (115 new platforms, 165 total)
- **US Air (32 new):** F-15EX, B-21 Raider, V-22 Osprey, MQ-25 Stingray, E-2D Hawkeye, C-5M Galaxy, KC-46, AC-130J, AH-1Z Viper, CH-47F, UH-60M, RQ-4 Global Hawk, Switchblade 300/600, etc.
- **US Land (35 new):** Stryker, JLTV, AMPV, M777, M109A7, M270 MLRS, THAAD, AN/TWQ-1 Avenger, M4A1, M240, M110A1, Mk 19, Carl Gustaf M3E1, M2 .50 cal, etc.
- **US Sea (17 new):** Gerald R. Ford-class, Zumwalt-class, America-class LHA, San Antonio-class LPD, Freedom-class LCS, Independence-class LCS, Ohio SSGN, Columbia-class, Ticonderoga-class, Cyclone-class, etc.
- **US Munitions (31 new):** AIM-9X Sidewinder, AGM-158 JASSM, AGM-179 JAGM, GBU-43 MOAB, GBU-39 SDB, Mk 48 ADCAP, Mk 54 torpedo, M795 155mm, Hydra 70, AGM-88 HARM, AGM-84 Harpoon, RIM-174 SM-6, RIM-162 ESSM, etc.

### API (`api/`)
- `api/database.py` — SQLite query layer with parameterized queries, pagination, sorting
- `api/main.py` — FastAPI application with CORS, Swagger UI:
  - `GET /api/v1/platforms` — List/filter with 12 query params (category, country, manufacturer, cost range, year range, text search, conflict, sort, pagination)
  - `GET /api/v1/platforms/{id}` — Full detail (specs, economics, armaments, operators, conflicts, media, sources)
  - `GET /api/v1/stats` — Database summary (counts, category/country/status/era breakdowns)
  - `GET /api/v1/categories` — Category taxonomy with subcategories
  - `GET /api/v1/conflicts` — Tracked conflicts with platform counts
  - `GET /api/v1/compare?ids=a,b,c` — Side-by-side comparison (max 10)
  - `GET /health` — Health check

### Docs
- `docs/V2_US_RESEARCH_OUTLINE.md` — 395-line research methodology for 145 US platforms
- Updated README with API documentation, query parameter reference, example calls

**Database stats:**
| Table | Records |
|-------|---------|
| platforms | 165 |
| specifications | 165 |
| economics | 153 |
| armaments | 223 |
| operators | 665 |
| platform_conflicts | 313 |
| sources | 653 |

**Breakdown:** 138 US, 6 Russia, 4 France, 3 UK, 2 China, 2 Germany, 2 Soviet Union, 1 Israel, 1 South Korea, 1 Sweden, 5 other

**Database size:** 748 KB (SQLite)

---

## V2.1 — Hardening (Next Up)

**Goal:** Production-readiness. Tests, CI, Docker, data quality.

### Planned deliverables

**Testing:**
- [ ] `tests/test_api.py` — pytest suite for all 6 API endpoints + edge cases
- [ ] `tests/test_database.py` — Unit tests for query layer
- [ ] `tests/test_validators.py` — Validation/normalization tests
- [ ] `tests/test_data_integrity.py` — Cross-table referential integrity checks
- [ ] Coverage target: 90%+

**CI/CD:**
- [ ] `.github/workflows/ci.yml` — GitHub Actions: lint, test, build on push/PR
- [ ] `.github/workflows/release.yml` — Tag-triggered release with changelog
- [ ] Pre-commit hooks: ruff (lint), black (format), mypy (types)

**Data quality audit:**
- [ ] Fix `XX` country codes (5 platforms with unknown/placeholder origins)
- [ ] Validate all `unit_cost_usd` values against sources
- [ ] Ensure every platform has ≥2 independent source citations
- [ ] Normalize manufacturer names (deduplicate variants)
- [ ] Fill missing economics records (12 platforms lacking cost data)

**Docker:**
- [ ] `Dockerfile` — Multi-stage Python image (slim, <200MB)
- [ ] Update `docker/docker-compose.yml` to include API service
- [ ] Health check integration

**API hardening:**
- [ ] Request validation with Pydantic models
- [ ] Structured JSON logging
- [ ] Basic rate limiting (in-memory or Redis)
- [ ] Error response standardization (RFC 7807 Problem Details)
- [ ] CORS configuration (restrict in production)

---

## V3.0 — Intelligence (Planned)

**Goal:** AI-powered semantic search using RAG (Retrieval-Augmented Generation).

### Planned deliverables

**Embedding pipeline:**
- [ ] Generate vector embeddings for all 165+ platform descriptions, specs, combat history
- [ ] Multi-field chunking strategy (separate vectors for different data types)
- [ ] Sentence-Transformers (all-MiniLM-L6-v2 or BAAI/bge-base) for embedding model
- [ ] ChromaDB or pgvector for vector storage
- [ ] Incremental update pipeline (re-embed only changed records)

**Semantic search API:**
- [ ] `POST /api/v1/search` — Natural language query endpoint
- [ ] Hybrid search: vector similarity + SQL filters combined
- [ ] Cross-encoder reranking for precision
- [ ] Intent detection (comparison vs. lookup vs. aggregation)

**LLM integration:**
- [ ] Ollama for local inference (Llama 3.2, Mistral, Phi-3)
- [ ] LangChain orchestration with retrieval chain
- [ ] Citation generation — every answer links to source platforms/URLs
- [ ] Confidence scoring
- [ ] Optional external API fallback (OpenAI, Anthropic)

**Comparison engine:**
- [ ] `POST /api/v1/ask` — "Compare F-35 vs Su-57 in cost and speed"
- [ ] Structured comparison output with source references
- [ ] Aggregation queries — "How many NATO fighters cost over $100M?"

**PostgreSQL migration:**
- [ ] Migrate from SQLite to PostgreSQL 16 with pgvector
- [ ] Alembic migration framework
- [ ] Schema: `platform_embeddings`, `rag_conversations`, `rag_messages`, `embedding_jobs`

---

## V4.0 — Experience (Planned)

**Goal:** Beautiful, responsive web frontend with rich data visualization.

### Planned deliverables

**Next.js application:**
- [ ] Platform explorer — browse, filter, sort with instant results
- [ ] Platform detail pages — full-page cards with specs, images, combat history
- [ ] Side-by-side comparison tool (select 2–10 platforms)
- [ ] AI chat interface — conversational search powered by V3 RAG
- [ ] Global search bar with autocomplete
- [ ] Dark/light mode

**Visualizations:**
- [ ] Interactive charts (Recharts) — cost timelines, performance comparisons
- [ ] World map (Leaflet) — operator locations, conflict zones, deployment areas
- [ ] Timeline view — production and service history
- [ ] Specification radar charts — multi-axis performance comparison
- [ ] Cost breakdowns — program vs. unit cost, inflation-adjusted

**Dashboard:**
- [ ] Analytics overview — key database metrics
- [ ] Category summaries — Air/Land/Sea/Munitions at a glance
- [ ] Cost rankings by category
- [ ] Recently added platforms
- [ ] Conflict coverage summary

**Design:**
- [ ] Tailwind CSS + shadcn/ui component library
- [ ] Mobile-first responsive design
- [ ] WCAG 2.1 AA accessibility
- [ ] Core Web Vitals targets (Lighthouse 90+)

---

## V5.0 — Community (Planned)

**Goal:** Multi-user platform with crowdsourced contributions and moderation.

### Planned deliverables

**Authentication:**
- [ ] User registration (email + OAuth via Auth.js or Keycloak)
- [ ] JWT session management
- [ ] Role-based access: admin, moderator, contributor, viewer
- [ ] API key management for programmatic access

**User features:**
- [ ] User profiles with contribution history
- [ ] Platform favorites/watchlists
- [ ] Saved searches and comparisons
- [ ] Per-platform discussion threads
- [ ] Notification system (Novu)

**Contribution system:**
- [ ] User-submitted data corrections and new platforms
- [ ] Review queue with moderator workflow
- [ ] Edit history with full audit trail
- [ ] Reputation/karma system for contributors
- [ ] Crowdsourced source verification

**Moderation:**
- [ ] Admin dashboard
- [ ] Content flagging and review
- [ ] Automated spam detection
- [ ] Bulk moderation tools

**Deployment:**
- [ ] Self-hosted on cluster1 via Tailscale
- [ ] Cloudflare CDN/proxy
- [ ] Docker Compose or K3s production setup
- [ ] Prometheus + Grafana monitoring
- [ ] Automated backups

---

## Commit History (to date)

```
dad293c docs: update README for V2 — 165 platforms, API docs, new structure
a618066 feat: add FastAPI REST API with 6 endpoints
06626c6 docs: add V2 US systems research outline and methodology
4c0c69c data: expand to 165 platforms with US-focused V2 research
d93aa5e Add comprehensive application framework, roadmap, architecture, and tech stack documentation
f4ff251 docs: add sample queries and analytical examples
063bcaa data: add V1 seed dataset (50 platforms, 4 categories)
e7e6d34 feat: add seed dataset transformation pipeline
76f1699 feat: add multi-format export pipeline
501f73f feat: add data validation and normalization layer
a2afcea feat: add pluggable data collection framework
13d4fdd feat: add relational database schema (11 tables)
ca157a8 feat: initialize project structure and scaffolding
```

---

*Last updated: March 12, 2026*
