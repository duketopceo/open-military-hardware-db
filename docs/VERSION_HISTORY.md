# Open Military Hardware Database — Version History & Roadmap

> Definitive version-by-version record from V0.0 through V5.0.
> Each version builds on the last. Every version ships working code.
> Last updated after V2.3 push.

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
| **V2.1** | Hardening | Complete | 51-test suite, data quality audit (0 XX codes, 130→95 mfrs), Pydantic models, Dockerfile, GitHub Actions CI |
| **V2.2** | Beta UI | Complete | React frontend (Explorer, Detail, Compare, Stats Dashboard), dark military theme, deployed beta |
| **V2.3** | Intel Console | Complete | Blueprint + liquid glass visual redesign, 3-pane intelligence console, dense sortable table, integrated detail pane |
| **V3.0** | Global Data | Next Up | 500+ platforms (NATO allies, adversaries, regional powers), PostgreSQL migration, international research |
| **V3.1** | Intelligence | Planned | Vector embeddings, semantic search API, RAG pipeline with Ollama |
| **V4.0** | Experience | Planned | Next.js frontend, interactive dashboards, maps, comparison tool UI |
| **V4.1** | Deployment | Planned | Self-hosted on cluster1 via Tailscale, Cloudflare proxy, Docker Compose production |
| **V5.0** | Community | Planned | Auth, user contributions, moderation queue, public API keys |

---

## Completed Versions

### V0.0 — Scaffold

**Commit:** `ca157a8 feat: initialize project structure and scaffolding`

**Shipped:**
- GitHub repository at `duketopceo/open-military-hardware-db`
- MIT LICENSE
- `.gitignore` (Python, Node, IDE, OS files)
- Directory tree with `.gitkeep` placeholders: `data/{json,csv,sql}/`, `schemas/`, `scripts/{collectors,validators,exporters}/`, `docs/`, `images/{profiles,diagrams,action}/`
- `requirements.txt` (requests, beautifulsoup4, lxml, pandas, jsonschema, pydantic, sqlalchemy, openpyxl, dateutil, tqdm, rich, dotenv)
- README.md skeleton

---

### V0.1 — Schema

**Commit:** `13d4fdd feat: add relational database schema (11 tables)`

**Shipped:**
- `schemas/001_create_tables.sql` — 11 normalized tables with full referential integrity
  - Reference tables: `categories`, `subcategories`, `platform_statuses`, `countries`
  - Core: `platforms` (platform_id PK, common_name, official_designation, nato_reporting_name, category_id FK, subcategory_id FK, country_of_origin FK, manufacturer, status_id FK, entered_service_year, units_built, description)
  - Detail 1:1: `specifications` (33 columns: dimensions, performance, propulsion, sensors, armor), `economics` (unit_cost_usd, unit_cost_adjusted_2024, program_cost, maintenance_cost_per_hour, cost_year)
  - Detail 1:many: `armaments`, `operators`, `platform_conflicts`, `media`, `sources`, `changelog`
  - Standalone: `conflicts` (conflict_id, conflict_name, start_year, end_year, region)
- `schemas/002_create_indexes.sql` — 15+ composite/single indexes
- `schemas/003_seed_enums.sql` — 4 categories, 30+ subcategories, 50+ countries, 15 conflicts, platform statuses
- `schemas/platform_schema.json` — JSON Schema for validating platform entries

---

### V0.2 — Toolchain

**Commits:** `a2afcea`, `501f73f`, `76f1699`, `e7e6d34`

**Shipped:**
- `scripts/collectors/base_collector.py` — Abstract base: configurable rate limiting (req/sec), 7-day HTTP disk cache, automatic source citation generation, structured error handling
- `scripts/collectors/wikipedia_collector.py` — Wikipedia infobox parser (extracts specs, history, media from wiki articles)
- `scripts/collectors/military_factory_collector.py` — MilitaryFactory.com specification extractor
- `scripts/collectors/globalsecurity_collector.py` — GlobalSecurity.org data collector
- `scripts/validators/data_validator.py` — Country name→ISO code, currency→USD, metric unit standardization, JSON Schema validation, year range sanity, BLS CPI-U inflation adjustment (1950–2024)
- `scripts/exporters/export_all.py` — JSON → CSV (48 flat columns) + SQLite (full schema) + SQL dump pipeline
- `scripts/build_seed_dataset.py` — Transforms wide_research CSV output into schema-compliant nested JSON

---

### V1.0 — Seed Dataset

**Commits:** `063bcaa`, `f4ff251`

**Shipped:**
- 50 platforms researched from open sources (Wikipedia, GlobalSecurity, Military Factory, CRS reports)
  - Air (15): F-35A, F-22, Su-57, B-2, MQ-9 Reaper, AH-64 Apache, C-17, Eurofighter, Rafale, Su-35, J-20, etc.
  - Land (16): M1A2 Abrams, Leopard 2, T-72, HIMARS, Patriot, S-400, Iron Dome, K2 Black Panther, etc.
  - Sea (10): Nimitz-class, Arleigh Burke, Virginia-class, Type 055, FREMM, Astute-class, etc.
  - Munitions (9): AIM-120 AMRAAM, Tomahawk, Javelin, JDAM, Hellfire, Storm Shadow, etc.
- 4 export formats: JSON, CSV, SQLite, SQL dump
- `docs/sample_queries.sql` — 20+ analytical SQL queries
- Multi-nation: US, Russia, China, France, UK, Germany, Israel, Sweden, South Korea

---

### V1.1 — Framework

**Commit:** `d93aa5e` (via GitHub Copilot PR #1, merged)

**Shipped:**
- `docs/ARCHITECTURE.md` — 1,155-line system architecture (all layers, data flow, security)
- `docs/ROADMAP.md` — V1–V5 roadmap with tech stack tables, schema evolution, release criteria
- `docs/TECH_STACK.md` — 448-line open-source technology catalog
- `schemas/004_extended_schema.sql` — PostgreSQL extensions: pgvector, users, API keys, audit log, RAG tables
- `docker/docker-compose.yml` — Multi-service: PostgreSQL, Redis, API, frontend, ChromaDB, Ollama, Traefik, Prometheus, Grafana
- `docker/.env.example` — Environment variable template

---

### V2.0 — US Expansion + API

**Commits:** `4c0c69c`, `06626c6`, `a618066`, `dad293c`

**Shipped:**

**Data (50 → 165 platforms):**
- US Air (32 new): F-15EX, B-21 Raider, B-1B, V-22 Osprey, MQ-25 Stingray, E-2D Hawkeye, C-5M, KC-46, AC-130J, AH-1Z Viper, CH-47F, CH-53K, UH-60M, MH-60R, RQ-4, RQ-170, Switchblade, etc.
- US Land (35 new): Stryker, Stryker Dragoon, JLTV, AMPV, M777, M109, M119, M120, THAAD, Avenger, M4A1, M240, M110A1, M2A1 .50 cal, Mk 19, Carl Gustaf, M2A4 Bradley, M10 Booker, LAV-25, XM30, etc.
- US Sea (17 new): Gerald R. Ford, Zumwalt, America-class, San Antonio, Freedom LCS, Independence LCS, Ohio SSGN, Columbia-class, Ticonderoga, DDG(X), Cyclone, Sentinel FRC, Whidbey Island, etc.
- US Munitions (31 new): AIM-9X, AGM-158 JASSM, AGM-179 JAGM, AGM-88 HARM/AARGM, AGM-65 Maverick, AGM-154 JSOW, GBU-43 MOAB, GBU-39 SDB, GBU-53B StormBreaker, Mk 48 ADCAP, Mk 54, M795 155mm, Hydra 70, RIM-174 SM-6, RIM-162 ESSM, ATACMS, etc.

**API (`api/` package):**
- `api/database.py` — SQLite query layer: `query_platforms()` (12 filter params, pagination, sorting), `get_platform_detail()`, `get_stats()`, `list_categories()`, `list_conflicts()`, `compare_platforms()`
- `api/main.py` — FastAPI with CORS, Swagger UI at `/docs`:
  - `GET /api/v1/platforms` — list/filter
  - `GET /api/v1/platforms/{id}` — full detail
  - `GET /api/v1/stats` — summary stats
  - `GET /api/v1/categories` — taxonomy
  - `GET /api/v1/conflicts` — conflict list
  - `GET /api/v1/compare?ids=a,b` — side-by-side (max 10)
  - `GET /health` — health check
- `docs/V2_US_RESEARCH_OUTLINE.md` — 395-line research methodology

**Database stats after V2.0:** 165 platforms, 165 specifications, 153 economics, 223 armaments, 665 operators, 313 conflict records, 653 sources. 138 US, 6 RU, 4 FR, 3 GB, 2 CN, 2 DE, 2 SU, 1 IL, 1 KR, 1 SE, 5 other.

---

### V2.1 — Hardening (Just Completed)

**Commits:** `a5d5329`, `8fcb4c4`, `1c572ff`, `32fe052`

**Shipped:**

**Data quality audit** (`scripts/fix_data_quality.py`):
- Fixed 5 XX country codes: AT4→SE (Sweden), BMP-3→RU (Russia), M240B→BE (Belgium), M982 Excalibur→US, NASAMS→NO (Norway)
- Normalized 53 manufacturer entries (130→95 unique). Canonical forms: Boeing, Lockheed Martin, Raytheon (RTX), BAE Systems, Northrop Grumman, General Dynamics Land Systems, Sikorsky (Lockheed Martin), etc.
- Cleaned markdown links and HTML entities (`&amp;`, `[text](url)`) from manufacturer fields
- Rebuilt all 4 export formats

**Pydantic response models** (`api/models.py`):
- `PlatformSummary`, `PlatformListResponse`, `PlatformDetail`, `StatsResponse`, `Category`, `Subcategory`, `Conflict`, `CompareResponse`, `HealthResponse`, `RootResponse`, `ErrorResponse`
- All endpoints now declare `response_model=` for auto-generated OpenAPI docs

**API hardening** (`api/main.py`):
- Request logging middleware — logs method, path, status, response time
- `X-Response-Time-Ms` response header
- Global exception handler — 500 errors logged with traceback, clean JSON to client
- Version bumped to 2.1.0

**Test suite** (`tests/`):
- `tests/conftest.py` — shared fixtures (TestClient, db_connection, all_platforms)
- `tests/test_api.py` — 31 tests: root, health, list platforms (pagination, filters, sorting, search, empty result, max limit, validation), platform detail (found, 404, nested data), stats, categories, conflicts, compare (two, single, missing, nonexistent)
- `tests/test_data_integrity.py` — 20 tests: referential integrity (all FK relationships), no duplicate IDs, no null names/categories/manufacturers, ≥2 sources per platform, no markdown/HTML in manufacturers, reasonable service years, positive unit costs, JSON↔SQLite↔CSV consistency
- All 51 tests passing

**CI/CD** (`.github/workflows/ci.yml`):
- Runs on push to main + PRs
- Python 3.11 + 3.12 matrix
- `pytest` with coverage report
- `ruff` linting
- Docker build + container health check test

**Dockerfile:**
- Multi-stage build (~120MB final)
- Non-root `appuser`
- Built-in HEALTHCHECK
- 2 uvicorn workers

---

### V2.2 — Beta UI (Just Completed)

**Commit:** `63303cc feat: add React frontend — V2.2 beta UI`

**Shipped:**
- Full React frontend at `frontend/` — React + Vite + Tailwind CSS v3 + shadcn/ui
- Dark military/defense theme (olive/slate palette, green primary accent, amber chart accent)
- Four pages:
  1. **Platform Explorer** — card grid with search, filter by category/status, sort (6 options), pagination (25/page)
  2. **Platform Detail** — full specs, economics, armaments, operators, combat history, sources with external links
  3. **Statistics Dashboard** — 8 KPI cards, category/status donut charts, era bar chart, top-countries horizontal bar chart (Recharts)
  4. **Compare Tool** — search-to-add interface, side-by-side comparison table with specs, supports 2–10 platforms
- Sidebar navigation with category quick-filters (Air, Land, Sea, Munitions)
- Express backend proxies to FastAPI on port 8000
- Hash-based routing for SPA deployment
- Dark/light theme toggle (defaults dark)
- Skeleton loaders for all data-fetching states
- Empty states with icons and action prompts
- Tabular numbers on all data displays (font-variant-numeric: tabular-nums)
- Monospace font for technical designations and spec values
- TanStack Query v5 for data fetching with cache management
- Inter (body) + JetBrains Mono (data) font pairing
- Custom SVG shield+database logo mark
- Perplexity Computer attribution in sidebar footer

**Tech stack:** React 19, Vite 6, Tailwind CSS 3, shadcn/ui, Recharts, wouter (hash routing), TanStack Query v5, Express (proxy), TypeScript

**Beta deployment:** Published to Perplexity Computer hosting

---

### V2.3 — Intel Console (Just Completed)

**Commit:** `713bb4a feat: blueprint intelligence console redesign — V2.3`

**Shipped:**
- Complete visual overhaul: "liquid glass meets mid-1960s technical blueprint" aesthetic
- Design system:
  - Blueprint palette: deep navy base (#0a1628), warm amber accents (38° HSL)
  - Liquid glass surfaces via backdrop-filter blur + semi-transparent panels
  - CSS grid background with layered major/minor gridlines
  - Custom utility classes: `.glass`, `.glass-hover`, `.glass-active`, `.glass-heavy`
  - `.tag-chip`, `.label-caps`, `.data-mono`, `.intel-table` for consistent intel styling
  - `.timeline-strip` component for service history visualization
  - Stagger-in and fade-in micro-animations
  - Custom scrollbar theming
- 3-pane intelligence console layout:
  - Left sidebar: navigation + domain filters (AIR/LAND/SEA/MUNITION) with counts
  - Center: primary content (table, charts, compare)
  - Right: selected platform detail pane (Explorer only)
- Explorer rebuilt:
  - Dense sortable table with 9 columns (System, Designation, Type, Manufacturer, Origin, IOC, Built, Status)
  - Click-to-select row opens integrated right detail pane
  - Detail panel: description, timeline strip, specifications, economics, armaments, operators, conflicts, sources
  - Null value filtering — only populated fields displayed
  - Monospaced search input with syntax hints
  - Record count and pagination footer
- Stats rebuilt:
  - 8 glass KPI cards with stagger animation
  - Donut charts (domain distribution, operational status)
  - Bar charts (platforms by era, top countries of origin with proper label width)
  - Blueprint-themed Recharts with custom glass tooltips
- Compare rebuilt:
  - Glass-styled search dropdown
  - Active tag chips for selected platforms
  - Blueprint comparison table with sticky field column
  - Specification section headers with icons
- Routing simplified:
  - Each page wraps its own AppShell (Explorer passes rightPanel prop)
  - Removed ThemeProvider (always-dark — intelligence console has no light mode)
  - Removed standalone platform-detail route (integrated into Explorer right pane)
  - Blueprint-themed 404 page ("SIGNAL NOT FOUND")
- SVG shield+grid logo updated with amber accent
- Single-theme (always dark) — removed light mode toggle

**Tech stack:** Same as V2.2 (React 19, Vite, Tailwind CSS 3, shadcn/ui, Recharts, wouter, TanStack Query v5, Express proxy, TypeScript)

**Figma integration:** Connected for future design iteration

**Beta deployment:** Updated at same Perplexity Computer URL

---

## Future Versions — Detailed Plan

---

## V3.0 — Global Data Expansion

**Goal:** Scale from 165 to 500+ platforms covering NATO allies, near-peer adversaries, and key regional powers. Migrate from SQLite to PostgreSQL for production readiness.

### V3.0.1 — NATO Allies Research

**New platforms (~80):**

| Country | Count | Key Systems |
|---------|-------|-------------|
| United Kingdom | 15 | Challenger 3, Type 26 frigate, Tempest (GCAP), Astute-class SSN, Boxer MRAV, Apache AH-64E (UK), NLAW, Brimstone, Meteor BVRAAM, Type 45 destroyer, Queen Elizabeth carrier, Wildcat, A400M (UK), Storm Shadow/SCALP, Starstreak |
| France | 12 | Rafale F4, Leclerc MBT, CAESAR 155mm SPH, Barracuda-class SSN, Mistral-class LHD, Horizon-class destroyer, VBCI, Griffon, Jaguar EBRC, MICA missile, SCALP Naval, Aster 30 |
| Germany | 12 | Leopard 2A7+, Puma IFV, PzH 2000, IRIS-T SLM, Boxer GTK, Type 212CD submarine, F125 Baden-Württemberg frigate, Wiesel AWC, Tornado IDS/ECR, MANTIS C-RAM, Taurus KEPD 350, NH90 |
| Italy | 8 | Centauro II, Freccia IFV, Ariete C1, Trieste LHD, Bergamini FREMM, Type 212A (Todaro), AW101 Merlin, Aster 15/30 |
| Poland | 6 | K2PL Black Panther, K9PL Thunder, FA-50PL, Krab SPH, AHS Kryl, Borsuk IFV |
| Turkey | 8 | KAAN (TF-X), Bayraktar TB2, Bayraktar Akıncı, Altay MBT, T129 ATAK, TCG Anadolu LHD, Bayraktar TB3, HISAR O+ |
| South Korea | 6 | K2 Black Panther (detailed), K9 Thunder, KF-21 Boramae, Sejong the Great DDG, Dosan Ahn Changho SSX, Hyunmoo-5 |
| Japan | 6 | Type 10 MBT, F-X (next-gen fighter), Mogami-class FFM, Sōryū-class submarine, Type 12 SSM (extended), AAV-7 (Japan) |
| Australia | 4 | Boxer CRV, Hunter-class frigate, Hobart-class DDG, MQ-28 Ghost Bat |
| Canada | 3 | LAV 6.0, Halifax-class frigate, CP-140 Aurora |

**Data collection method:**
- Create entities files per country batch (as in V2)
- Use `wide_research` for each batch (parallel web research)
- Transform via `scripts/build_seed_dataset.py`
- Validate via `scripts/validators/data_validator.py`
- Each batch: ~30 min research, ~10 min transform/validate

### V3.0.2 — Adversary/Competitor Research

**New platforms (~70):**

| Country | Count | Key Systems |
|---------|-------|-------------|
| Russia | 20 | Su-57 Felon (detailed), Su-34 Fullback, MiG-35 Fulcrum-F, Tu-160M2, Ka-52 Alligator, T-14 Armata, T-90M Proryv, BMP-T Terminator, 2S35 Koalitsiya, Pantsir-S1, Tor-M2, Iskander-M, Kh-101, Kinzhal, Zircon, Kalibr, Admiral Gorshkov (detailed), Yasen-M SSN, Borei-A SSBN, Lada-class SSK |
| China | 20 | J-20 (detailed), J-16, J-10C, H-20, WZ-10, Type 99A, ZTZ-15, Type 04A IFV, PCL-191, HQ-9B, HQ-22, DF-17, DF-21D, DF-26, YJ-18, PL-15, Type 052D Luyang III, Type 055 (detailed), Type 039C, Type 096 SSBN |
| Iran | 8 | Kowsar fighter, Karrar tank, Bavar-373, Shahed-136, Fateh-110, Khalij Fars ASBM, Mohajer-6, Ghadir-class submarine |
| North Korea | 4 | Hwasong-17, Hwasong-18, KN-23, Pukguksong-3 |
| India | 10 | Tejas Mk 1A, Arjun Mk 2, BrahMos, Agni-V, INS Vikrant, Kolkata-class DDG, Kalvari-class SSK, HAL Prachand, Akash-NG, Pinaka MLRS |
| Israel | 8 | Merkava Mk 4M, Iron Dome (detailed), David's Sling, Arrow 3, Namer IFV, Sa'ar 6 corvette, Hermes 900, Spike NLOS |

### V3.0.3 — PostgreSQL Migration

**Files to create/modify:**

| File | Description |
|------|-------------|
| `docker/docker-compose.dev.yml` | Dev environment: PostgreSQL 16, Redis 7, API |
| `api/database_pg.py` | PostgreSQL query layer (asyncpg or psycopg3, connection pooling) |
| `api/database.py` | Refactor to abstract interface — `DatabaseBackend` base class with `SQLiteBackend` and `PostgresBackend` |
| `scripts/migrate_sqlite_to_pg.py` | One-shot migration: reads SQLite, writes to PostgreSQL, verifies counts |
| `alembic/` | Alembic migration framework: `env.py`, `versions/001_initial.py` |
| `schemas/005_postgres_optimizations.sql` | JSONB columns, GIN indexes, partial indexes, materialized views for stats |

**Migration steps:**
1. Create `DatabaseBackend` ABC with methods matching current `database.py` functions
2. Implement `SQLiteBackend` (wraps existing code) and `PostgresBackend`
3. Environment variable `DATABASE_URL` selects backend (SQLite path or PostgreSQL URI)
4. Run `migrate_sqlite_to_pg.py` to transfer all data
5. Add Alembic for future schema changes
6. Update Docker Compose to start PostgreSQL
7. All 51 existing tests must still pass against both backends

**API changes:**
- Add `DATABASE_URL` env var support
- Connection pooling for PostgreSQL (min=2, max=10)
- Async query support (optional, prepare for V4 frontend)

### V3.0.4 — Data Quality Pass

- Fill remaining 12 missing economics records
- Cross-reference V1 international platforms with new research (update specs if better data found)
- Add `data_quality_score` field to platforms table (0.0–1.0 based on field completeness)
- Generate `docs/DATA_QUALITY_REPORT.md` — per-category completeness percentages

**Target after V3.0:** 500+ platforms, 40+ countries, PostgreSQL backend, all tests green.

---

## V3.1 — Intelligence (RAG System)

**Goal:** AI-powered semantic search using vector embeddings and local LLM inference.

### V3.1.1 — Embedding Pipeline

**Files to create:**

| File | Description |
|------|-------------|
| `rag/__init__.py` | RAG package |
| `rag/embedder.py` | Embedding generation using Sentence-Transformers |
| `rag/chunker.py` | Document chunking strategy per field type |
| `rag/vector_store.py` | ChromaDB or pgvector interface |
| `rag/config.py` | Model selection, chunk sizes, overlap settings |
| `scripts/embed_all.py` | CLI: embed all platforms, show progress, report stats |

**Embedding strategy:**
- Model: `all-MiniLM-L6-v2` (384 dimensions, fast, good quality) or `BAAI/bge-base-en-v1.5` (768d, better accuracy)
- Chunk types per platform:
  1. **Identity chunk** — name + designation + description + manufacturer + country (1 vector)
  2. **Specifications chunk** — all specs as structured text "Speed: 2,410 km/h | Range: 3,200 km | ..." (1 vector)
  3. **Economics chunk** — cost data as narrative (1 vector)
  4. **Combat history chunk** — conflicts + roles + operational history (1 vector per conflict)
  5. **Operator chunk** — list of operators with quantities (1 vector)
- Estimated vectors: 500 platforms × ~5 chunks = ~2,500 vectors
- Storage: ChromaDB (file-based, zero-config) or pgvector (if PostgreSQL already running)

**Incremental update logic:**
- Hash each platform's JSON content
- On re-embed, only process platforms where hash changed
- Track in `embedding_metadata` table: platform_id, content_hash, embedded_at, model_version

### V3.1.2 — Semantic Search API

**New endpoints:**

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST /api/v1/search` | Natural language search | Takes `{"query": "fastest fighter jet", "limit": 10}`, returns ranked platforms with relevance scores |
| `POST /api/v1/ask` | RAG question answering | Takes `{"question": "Compare F-35 and Su-57 costs"}`, returns generated answer with source citations |
| `GET /api/v1/search/suggestions` | Autocomplete/typeahead | Returns top matches as user types |

**Files to create:**

| File | Description |
|------|-------------|
| `api/routes/search.py` | Search endpoint implementations |
| `rag/retriever.py` | Hybrid retrieval: vector similarity + SQL filters combined |
| `rag/reranker.py` | Cross-encoder reranking for top-k precision (sentence-transformers cross-encoder) |
| `rag/intent.py` | Query intent classification: comparison, lookup, aggregation, factual |

**Search pipeline:**
1. User query → embed with same model
2. Vector similarity search → top 20 candidates
3. Cross-encoder rerank → top 5
4. (If SQL filters provided) intersect with SQL results
5. Return ranked results with relevance scores and highlighted snippets

### V3.1.3 — LLM Integration (RAG Answering)

**Files to create:**

| File | Description |
|------|-------------|
| `rag/generator.py` | LLM response generation with retrieved context |
| `rag/prompts.py` | System prompts, few-shot examples, output format templates |
| `rag/citations.py` | Source extraction and citation formatting |
| `rag/conversation.py` | Multi-turn conversation state management |

**Architecture:**
- Primary: Ollama (local inference) — Llama 3.2 8B or Mistral 7B
- Fallback: OpenAI/Anthropic API (optional, env var `LLM_PROVIDER`)
- Orchestration: LangChain `RetrievalQA` chain

**Prompt template:**
```
You are a military hardware analyst. Answer questions using ONLY the provided context.
Always cite your sources by platform name and source URL.
If the answer is not in the context, say "I don't have sufficient data to answer that."

Context:
{retrieved_chunks}

Question: {user_question}
```

**Response format:**
```json
{
  "answer": "The F-22 Raptor has a top speed of Mach 2.25...",
  "confidence": 0.92,
  "sources": [
    {"platform_id": "f-22-raptor", "source_url": "https://...", "relevance": 0.95}
  ],
  "tokens_used": 342
}
```

### V3.1.4 — RAG Tests

**Files to create:**

| File | Description |
|------|-------------|
| `tests/test_embedder.py` | Embedding generation and dimension validation |
| `tests/test_retriever.py` | Search ranking accuracy (known-good queries) |
| `tests/test_rag_e2e.py` | End-to-end: question in → cited answer out |
| `tests/fixtures/rag_golden_set.json` | 30+ test questions with expected platform matches |

**Golden test queries:**
- "Which fighter has the highest service ceiling?" → expects MiG-31 or F-22
- "Compare Abrams and Leopard 2 armor" → expects both platforms in results
- "How much does a Tomahawk missile cost?" → expects economics data
- "What weapons were used in the Russo-Ukrainian War?" → expects conflict-linked platforms
- "Name all US stealth aircraft" → expects F-22, F-35, B-2, F-117, B-21

**Target after V3.1:** Semantic search working, RAG answers with citations, local Ollama inference, 30+ golden test queries passing.

---

## V4.0 — Experience (Frontend)

**Goal:** Production web application with rich data visualization, accessible at a public URL.

### V4.0.1 — Next.js Application Scaffold

**Tech stack:**
- Next.js 14+ (App Router, React Server Components)
- Tailwind CSS 3+ with custom design tokens
- shadcn/ui component library
- TanStack Query for data fetching
- Zustand for client state
- Framer Motion for animations

**Directory structure:**
```
frontend/
├── app/
│   ├── layout.tsx              # Root layout, theme provider, fonts
│   ├── page.tsx                # Landing page / dashboard
│   ├── platforms/
│   │   ├── page.tsx            # Platform explorer (list + filters)
│   │   └── [id]/
│   │       └── page.tsx        # Platform detail page
│   ├── compare/
│   │   └── page.tsx            # Comparison tool
│   ├── search/
│   │   └── page.tsx            # AI search / RAG chat
│   ├── stats/
│   │   └── page.tsx            # Analytics dashboard
│   ├── conflicts/
│   │   └── page.tsx            # Conflict explorer
│   └── api/                    # Next.js API routes (proxy to FastAPI)
├── components/
│   ├── ui/                     # shadcn/ui components
│   ├── platform-card.tsx       # Platform summary card
│   ├── platform-table.tsx      # TanStack Table with sorting/filtering
│   ├── filter-sidebar.tsx      # Category/country/year filter panel
│   ├── search-bar.tsx          # Global search with autocomplete
│   ├── comparison-grid.tsx     # Side-by-side platform comparison
│   ├── stat-card.tsx           # Metric display card
│   ├── spec-radar-chart.tsx    # Multi-axis radar chart
│   ├── cost-bar-chart.tsx      # Cost comparison chart
│   ├── timeline-chart.tsx      # Service history timeline
│   ├── operator-map.tsx        # World map with operator dots
│   └── chat-interface.tsx      # RAG conversational search
├── lib/
│   ├── api-client.ts           # Typed FastAPI client (auto-generated from OpenAPI)
│   ├── hooks.ts                # Custom React hooks
│   ├── utils.ts                # Formatting, date, currency helpers
│   └── store.ts                # Zustand state (selected filters, comparison list)
├── styles/
│   └── globals.css             # Tailwind config, custom properties
├── public/
│   └── og-image.png            # OpenGraph social preview
├── next.config.ts
├── tailwind.config.ts
├── tsconfig.json
└── package.json
```

### V4.0.2 — Platform Explorer Page

**Features:**
- **Filter sidebar:** Category checkboxes, country dropdown, year range slider, manufacturer search, status toggles, cost range
- **Results grid:** Card view (image, name, category badge, country flag, key stat) or table view (TanStack Table with sortable columns)
- **Pagination:** Infinite scroll or numbered pages
- **URL state:** All filters reflected in URL params (shareable links)
- **Responsive:** 1-column on mobile, 2-column on tablet, 3-4 column on desktop

**Data flow:**
1. Filter sidebar state → Zustand store
2. TanStack Query watches store → calls `GET /api/v1/platforms` with params
3. Server response → renders cards/table
4. Debounced search input → same pipeline

### V4.0.3 — Platform Detail Page

**Sections (scrollable single page):**
1. **Hero header** — Name, designation, manufacturer, country flag, status badge, hero image
2. **Quick stats row** — Speed, range, cost, crew, units built (icon + number cards)
3. **Specifications table** — Full specs in grouped sections (dimensions, performance, propulsion, sensors, armor)
4. **Economics panel** — Unit cost, program cost, maintenance cost (bar chart if multiple data points)
5. **Armaments list** — Weapon name, type, quantity, description
6. **Operators map** — World map with dots for each operating country, hover for details
7. **Combat history timeline** — Horizontal timeline of conflicts with role annotations
8. **Sources section** — Numbered source list with clickable URLs and access dates
9. **Related platforms** — "Similar platforms" recommendations (same subcategory or manufacturer)

### V4.0.4 — Comparison Tool

**UX flow:**
1. User adds platforms from explorer (click "Compare" button on cards)
2. Comparison page shows 2-4 platforms side by side
3. **Spec comparison table** — rows for each spec, columns for each platform, color-coded (green=best, red=worst)
4. **Radar chart** — overlaid performance polygons (speed, range, ceiling, payload, cost)
5. **Cost comparison** — bar chart with inflation-adjusted prices
6. **Shared/unique features** — what they have in common vs. what's different

### V4.0.5 — Analytics Dashboard

**Widgets:**
- **Category breakdown** — donut chart (Air/Land/Sea/Munitions)
- **Country distribution** — bar chart top 15 countries
- **Era distribution** — stacked bar chart by decade
- **Cost rankings** — top 10 most expensive platforms
- **Status breakdown** — active vs. retired vs. in-production
- **Conflict coverage** — which conflicts have the most platform data
- **Data quality score** — overall database completeness meter

### V4.0.6 — AI Chat Interface

**UX:**
- Chat panel (slide-out or dedicated page)
- User types natural language question
- System shows thinking indicator
- Response renders as formatted markdown with inline platform links
- Source citations shown as clickable chips
- Conversation history persisted in localStorage
- Example questions shown as suggestion chips

### V4.0.7 — Design System

**Typography:**
- Headings: Inter or Geist Sans (bold)
- Body: Inter or Geist Sans (regular)
- Monospace: JetBrains Mono (specs, IDs, code)

**Colors:**
- Background: slate-950 (dark mode default), white (light)
- Primary: blue-600
- Category colors: Air=sky-500, Land=amber-600, Sea=blue-500, Munitions=red-500
- Status: active=green-500, retired=gray-500, in-production=yellow-500

**Components (shadcn/ui):**
- Button, Card, Badge, Table, Dialog, Sheet, Command, Tooltip, Tabs, Accordion, Avatar, DropdownMenu, Select, Slider, Toggle

---

## V4.1 — Deployment

**Goal:** Self-hosted production deployment on cluster1 via Tailscale, fronted by Cloudflare.

### V4.1.1 — Production Docker Compose

**File:** `docker/docker-compose.prod.yml`

**Services:**

| Service | Image | Port | Purpose |
|---------|-------|------|---------|
| `api` | `mildb-api:latest` (custom Dockerfile) | 8000 | FastAPI backend |
| `frontend` | `mildb-frontend:latest` (Next.js standalone) | 3000 | Web application |
| `postgres` | `postgres:16-alpine` | 5432 | Primary database |
| `redis` | `redis:7-alpine` | 6379 | Query cache, session store |
| `chromadb` | `chromadb/chroma:latest` | 8001 | Vector database |
| `ollama` | `ollama/ollama:latest` | 11434 | Local LLM inference |
| `traefik` | `traefik:v3` | 80, 443 | Reverse proxy, TLS termination |

**Volumes:**
- `pg_data` — PostgreSQL persistent data
- `chroma_data` — ChromaDB embeddings
- `ollama_models` — Downloaded LLM models
- `redis_data` — Redis AOF persistence

### V4.1.2 — Tailscale + Cloudflare Setup

**Steps:**
1. SSH to cluster1 via Tailscale: `ssh cluster1`
2. Install Docker, Docker Compose on cluster1
3. Clone repo, `docker compose -f docker/docker-compose.prod.yml up -d`
4. Configure Cloudflare:
   - DNS A record → Tailscale IP (or Cloudflare Tunnel)
   - SSL: Full (strict)
   - Caching rules: cache `/api/v1/stats`, `/api/v1/categories`, `/api/v1/conflicts` (5 min TTL)
   - WAF: rate limit API to 100 req/min per IP
5. Traefik handles internal routing: `/api/*` → API service, `/*` → frontend

### V4.1.3 — Monitoring

**Prometheus metrics (via `prometheus-fastapi-instrumentator`):**
- Request count by endpoint and status code
- Request duration histograms (p50, p95, p99)
- Active connections
- Database query latency
- Embedding generation time

**Grafana dashboard panels:**
- Request rate over time
- Error rate
- Response time percentiles
- Database size growth
- Top accessed platforms
- Search query volume

### V4.1.4 — Backup Strategy

- PostgreSQL: `pg_dump` daily to compressed archive, retain 30 days
- ChromaDB: snapshot embeddings directory daily
- Git: all schema and config in version control
- Automated via cron on cluster1

**Target after V4.1:** Live production site accessible via custom domain, Cloudflare CDN, monitoring dashboard, automated backups.

---

## V5.0 — Community

**Goal:** Multi-user platform with authentication, user contributions, and content moderation.

### V5.0.1 — Authentication System

**Files to create:**

| File | Description |
|------|-------------|
| `api/auth/__init__.py` | Auth package |
| `api/auth/jwt.py` | JWT token creation/validation (python-jose) |
| `api/auth/password.py` | bcrypt password hashing |
| `api/auth/dependencies.py` | FastAPI dependency injection for `get_current_user` |
| `api/auth/oauth.py` | GitHub/Google OAuth2 flow |
| `api/routes/auth.py` | `POST /auth/register`, `POST /auth/login`, `POST /auth/refresh`, `GET /auth/me` |

**Database tables:**
```sql
CREATE TABLE users (
    user_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email           TEXT UNIQUE NOT NULL,
    username        TEXT UNIQUE NOT NULL,
    password_hash   TEXT,
    display_name    TEXT,
    avatar_url      TEXT,
    role            TEXT DEFAULT 'viewer' CHECK (role IN ('admin', 'moderator', 'contributor', 'viewer')),
    oauth_provider  TEXT,  -- 'github', 'google', or NULL
    oauth_id        TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    last_login      TIMESTAMPTZ
);

CREATE TABLE api_keys (
    key_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID REFERENCES users(user_id) ON DELETE CASCADE,
    key_hash        TEXT NOT NULL,
    name            TEXT NOT NULL,
    permissions     TEXT[] DEFAULT '{read}',
    rate_limit      INTEGER DEFAULT 100,  -- requests per minute
    expires_at      TIMESTAMPTZ,
    last_used_at    TIMESTAMPTZ,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE sessions (
    session_id      UUID PRIMARY KEY,
    user_id         UUID REFERENCES users(user_id) ON DELETE CASCADE,
    refresh_token   TEXT NOT NULL,
    ip_address      INET,
    user_agent      TEXT,
    expires_at      TIMESTAMPTZ NOT NULL,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);
```

**Auth flow:**
1. Register: email + password → bcrypt hash → store → return JWT
2. Login: email + password → verify bcrypt → return JWT + refresh token
3. OAuth: redirect to GitHub/Google → callback → create/link user → return JWT
4. API keys: generate in UI → store hash → user sends in `Authorization: Bearer` header
5. JWT claims: `{sub: user_id, role: "contributor", exp: ...}`

### V5.0.2 — User Features

**Database tables:**
```sql
CREATE TABLE user_favorites (
    user_id         UUID REFERENCES users(user_id) ON DELETE CASCADE,
    platform_id     TEXT REFERENCES platforms(platform_id) ON DELETE CASCADE,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (user_id, platform_id)
);

CREATE TABLE saved_comparisons (
    comparison_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID REFERENCES users(user_id) ON DELETE CASCADE,
    name            TEXT NOT NULL,
    platform_ids    TEXT[] NOT NULL,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE saved_searches (
    search_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID REFERENCES users(user_id) ON DELETE CASCADE,
    name            TEXT NOT NULL,
    query_params    JSONB NOT NULL,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE user_activity (
    activity_id     BIGSERIAL PRIMARY KEY,
    user_id         UUID REFERENCES users(user_id) ON DELETE CASCADE,
    action          TEXT NOT NULL,  -- 'view', 'favorite', 'search', 'compare', 'submit_edit'
    entity_type     TEXT,
    entity_id       TEXT,
    metadata        JSONB,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);
```

**New API endpoints:**
- `GET /api/v1/me/favorites` — list favorites
- `POST /api/v1/me/favorites/{platform_id}` — add favorite
- `DELETE /api/v1/me/favorites/{platform_id}` — remove favorite
- `GET /api/v1/me/comparisons` — saved comparisons
- `POST /api/v1/me/comparisons` — save comparison
- `GET /api/v1/me/searches` — saved searches
- `GET /api/v1/me/activity` — recent activity feed

### V5.0.3 — Contribution System

**Database tables:**
```sql
CREATE TABLE contributions (
    contribution_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID REFERENCES users(user_id),
    platform_id     TEXT REFERENCES platforms(platform_id),
    contribution_type TEXT NOT NULL CHECK (contribution_type IN ('edit', 'new_platform', 'correction', 'source_add')),
    title           TEXT NOT NULL,
    description     TEXT,
    diff_data       JSONB NOT NULL,  -- {field: {old: ..., new: ...}}
    source_urls     TEXT[],
    status          TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'needs_revision')),
    reviewer_id     UUID REFERENCES users(user_id),
    reviewer_notes  TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    reviewed_at     TIMESTAMPTZ
);

CREATE TABLE contribution_comments (
    comment_id      BIGSERIAL PRIMARY KEY,
    contribution_id UUID REFERENCES contributions(contribution_id) ON DELETE CASCADE,
    user_id         UUID REFERENCES users(user_id),
    body            TEXT NOT NULL,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE user_reputation (
    user_id         UUID PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE,
    score           INTEGER DEFAULT 0,
    contributions_approved INTEGER DEFAULT 0,
    contributions_rejected INTEGER DEFAULT 0,
    rank            TEXT DEFAULT 'newcomer'  -- newcomer, contributor, trusted, expert
);
```

**Contribution workflow:**
1. User clicks "Suggest Edit" on platform detail page
2. Form pre-fills current values; user modifies fields and provides source URLs
3. `POST /api/v1/contributions` — creates pending contribution
4. Moderator sees contribution in review queue
5. Moderator approves (auto-applies diff to platform data) or rejects (with notes)
6. User gets notification of outcome
7. Approved contributions increase reputation score

**New API endpoints:**
- `POST /api/v1/contributions` — submit contribution
- `GET /api/v1/contributions` — list contributions (filterable by status)
- `GET /api/v1/contributions/{id}` — contribution detail
- `PATCH /api/v1/contributions/{id}/review` — moderator approve/reject (requires moderator role)

### V5.0.4 — Moderation Tools

**Admin dashboard (Next.js):**
- `/admin/contributions` — Review queue with approve/reject/request-revision actions
- `/admin/users` — User list with role management, ban capability
- `/admin/audit-log` — Full audit trail of all data changes
- `/admin/stats` — Contribution volume, approval rates, top contributors

**Audit log table:**
```sql
CREATE TABLE audit_log (
    log_id          BIGSERIAL PRIMARY KEY,
    user_id         UUID REFERENCES users(user_id),
    action          TEXT NOT NULL,  -- 'platform.update', 'user.role_change', 'contribution.approve'
    entity_type     TEXT NOT NULL,
    entity_id       TEXT NOT NULL,
    old_value       JSONB,
    new_value       JSONB,
    ip_address      INET,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);
```

### V5.0.5 — Public API Keys & Rate Limiting

**Features:**
- Users generate API keys in their profile settings
- Keys have configurable permissions: `read`, `search`, `contribute`
- Rate limits per key (default 100 req/min, upgradeable)
- Key usage tracking (last used, request count)
- Redis-based sliding window rate limiter

**Rate limiting tiers:**
| Tier | Rate | Who |
|------|------|-----|
| Anonymous | 30 req/min | No auth |
| Free API key | 100 req/min | Registered users |
| Contributor | 300 req/min | Users with approved contributions |
| Admin | Unlimited | Admins |

### V5.0.6 — Notifications

**Channels:**
- In-app notifications (stored in DB, shown in UI header bell icon)
- Email (optional, via Resend or SMTP)

**Triggers:**
- Contribution reviewed (approved/rejected)
- New platform added in watched category
- Reply to contribution comment
- System announcements

**Database table:**
```sql
CREATE TABLE notifications (
    notification_id BIGSERIAL PRIMARY KEY,
    user_id         UUID REFERENCES users(user_id) ON DELETE CASCADE,
    type            TEXT NOT NULL,
    title           TEXT NOT NULL,
    body            TEXT,
    link            TEXT,
    read            BOOLEAN DEFAULT FALSE,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);
```

**Target after V5.0:** Full community platform with auth, contributions, moderation, API keys, notifications. Publicly hosted and accessible.

---

## Complete Commit History

```
32fe052 ci: add Dockerfile and GitHub Actions CI workflow
1c572ff test: add comprehensive test suite (51 tests)
8fcb4c4 feat: add Pydantic response models and structured error handling
a5d5329 fix: data quality audit — country codes, manufacturer normalization
ae2e7a8 docs: add definitive VERSION_HISTORY.md (V0.0 through V5.0)
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

## File Inventory (current)

```
open-military-hardware-db/           (17 commits, V2.1)
├── .github/workflows/ci.yml         # GitHub Actions CI
├── api/
│   ├── __init__.py
│   ├── database.py                   # SQLite query layer (6 functions)
│   ├── main.py                       # FastAPI app (8 routes, middleware, error handling)
│   └── models.py                     # Pydantic response models (11 models)
├── data/
│   ├── csv/platforms.csv             # 165 rows, 48 columns (95 KB)
│   ├── json/platforms.json           # 165 nested entries (690 KB)
│   └── sql/
│       ├── military_hardware.db      # SQLite database (748 KB)
│       └── military_hardware_dump.sql # SQL text dump (490 KB)
├── docker/
│   ├── docker-compose.yml            # Multi-service dev environment
│   └── .env.example
├── docs/
│   ├── ARCHITECTURE.md               # System architecture (1,155 lines)
│   ├── ROADMAP.md                    # Original roadmap (553 lines)
│   ├── TECH_STACK.md                 # Technology catalog (448 lines)
│   ├── V2_US_RESEARCH_OUTLINE.md     # V2 research plan (395 lines)
│   ├── VERSION_HISTORY.md            # This file
│   └── sample_queries.sql            # 20+ analytical SQL queries
├── schemas/
│   ├── 001_create_tables.sql
│   ├── 002_create_indexes.sql
│   ├── 003_seed_enums.sql
│   ├── 004_extended_schema.sql       # PostgreSQL extensions (Copilot)
│   └── platform_schema.json
├── scripts/
│   ├── build_seed_dataset.py
│   ├── fix_data_quality.py           # V2.1 data quality fixes
│   ├── collectors/
│   │   ├── base_collector.py
│   │   ├── wikipedia_collector.py
│   │   ├── military_factory_collector.py
│   │   └── globalsecurity_collector.py
│   ├── exporters/export_all.py
│   └── validators/data_validator.py
├── tests/
│   ├── conftest.py                   # Shared fixtures
│   ├── test_api.py                   # 31 API endpoint tests
│   └── test_data_integrity.py        # 20 data quality tests
├── Dockerfile                        # Multi-stage, ~120MB
├── LICENSE                           # MIT
├── README.md
├── requirements.txt
└── .gitignore
```

---

*Last updated: March 12, 2026 — after V2.2 push*
