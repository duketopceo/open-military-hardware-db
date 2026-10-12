# Roadmap

## Program roadmap (2026-10-11)

Status key: found = observed in this pass, not yet fixed. Existing product versions are kept unchanged below under "Product roadmap". Evidence for every unit is in [`docs/research/2026-10-10-landscape.md`](docs/research/2026-10-10-landscape.md). Dependabot PRs are out of scope.

### Now

**P1 - Make a fresh clone build a correct database** (found)
Evidence: `export_all.py` builds a DB without `role_type` and with 165 platforms; the migrations that reach 183 are separate scripts.
- Difficulty: medium. The migrations are idempotent-looking scripts, not versioned; order and re-run safety need checking.
- Feasibility: no external blockers. The committed JSON/CSV need regenerating from the 183-platform DB, which changes data files (owner review).
- Simpler alternative: have `export_all.py` call the two migrations after seeding, and drop the second source of truth later. Do not build Alembic for SQLite yet (the `backend/` Postgres track already has it).

**P2 - Green tests and lint on main** (found)
Evidence: 5-6 failing tests (version `2.1.0` expectations, `role_type`), 126 ruff errors against the CI lint command.
- Difficulty: easy for the lint (`ruff --fix` covers 117), easy-medium for tests.
- Feasibility: depends on P1 for the `role_type` failures.
- Simpler alternative: update the two version assertions and delete the unused imports; do not loosen the CI gate.

**P3 - Contrast and focus polish** (done in this PR: tokens, focus rings, reduced motion, chip bug)
Remaining: country-bar colours in Stats.
- Difficulty: easy. Feasibility: none. Simpler alternative: use one accent for all bars and keep flags as labels.

### Next

**P4 - Reconcile `docs/UI_UX.md` with the shipped stack** - Difficulty: easy. Simpler alternative: delete the Next.js spec and link `DESIGN.md`.

**P5 - Data licence and attribution page** (provenance per row exists; the dataset licence statement does not) - Difficulty: easy. Feasibility: SIPRI terms must be checked before redistribution of derived tables.

**P6 - Frontend tests (smoke)** - none exist. Difficulty: medium. Simpler alternative: one Playwright smoke that loads `/`, `/stats` and `/compare` against the CI-built DB.

### Later

**P7 - NATO/adversary coverage (V3.1 below)** - Difficulty: hard (research per platform, sourcing). Feasibility: public sources vary in quality; keep the citation requirement. Simpler alternative: import structured data from an open source (SIPRI registers, Wikidata) for the skeleton, then cite and curate.

**P8 - Simplify the two services** - `backend/` (Postgres, GraphQL) and `api/` (SQLite) overlap. Difficulty: hard. Simpler alternative: pick one for V3.1 and archive the other; `temp/` (static smoke UI) can be deleted now that the React console exists.

---

## Product roadmap (previous content)

# Open Military Hardware DB — Roadmap

## Current: v3.0.0 (Stable)
- [x] 183 platforms across 5 domains (air, land, sea, munitions, software)
- [x] 675 source citations with full provenance
- [x] FastAPI REST API with filtering, pagination, sorting, comparison
- [x] Intelligence console frontend (React 19, dark blueprint aesthetic)
- [x] Structured exports (JSON, CSV, SQLite, SQL dump)
- [x] Data collection framework with rate limiting and caching
- [x] Role classification (offensive/defensive/dual/support/intelligence)
- [x] Contractor filtering (Boeing, Lockheed Martin, Anduril, Palantir, etc.)
- [x] Production Docker deployment with Cloudflare Tunnel (https://omhdb.luke-the-duke.com)
- [x] CI pipeline (GitHub Actions, Python 3.11/3.12 matrix)
- [x] Test suite (51 tests — API tests + data integrity tests)
- [x] Enterprise standards (AGENTS.md, CHANGELOG.md, CONTRIBUTING.md, SECURITY.md, structured logging, release automation, Dependabot)
- [x] Backend scaffolding for PostgreSQL migration (backend/ directory)
- [x] SIPRI military expenditure data integrated (175 countries, 1949–2024)
- [x] SIPRI Top 100 arms companies integrated (271 companies, 2002–2024)
- [x] SIPRI US arms transfers integrated (3,006 records, 2000–2025)
- [x] 4 new API endpoints (/api/v1/sipri/*)
- [x] SIPRI analytics charts (spending, companies, transfers, trends)

## V3.1 — Global Data + PostgreSQL Migration
- [ ] 500+ platforms (expand to NATO allies and key adversaries)
- [ ] PostgreSQL migration with Alembic (SQLite retained as fallback)
- [ ] SIPRI-informed prioritization for international platform research
- [ ] Conflict timeline visualization (interactive D3.js)
- [ ] Force composition analysis tool (compare countries side-by-side)
- [ ] Procurement cost trend charts (constant-dollar adjusted)
- [ ] GraphQL API alongside REST
- [ ] Expand test coverage (target: 80%+ coverage)

## V3.2 — Intelligence (RAG System)
- [ ] Vector embeddings with Sentence-Transformers
- [ ] Semantic search API (natural language queries)
- [ ] RAG pipeline with local LLM inference (Ollama)
- [ ] 30+ golden test queries for search accuracy

## V4.0 — Experience (Advanced Frontend)
- [ ] Interactive SIPRI data visualizations (expenditure charts, arms industry treemap)
- [ ] Transfer flow maps (Sankey/world map of US arms exports)
- [ ] Enhanced explorer (year range slider, cost filter, map view)
- [ ] AI chat interface (post-RAG)
- [ ] PDF report generation for country/platform profiles

## V4.1 — Deployment & Monitoring
- [ ] Full Docker Compose production stack (Postgres, Redis, ChromaDB, Ollama, Traefik)
- [ ] Prometheus + Grafana monitoring dashboard
- [ ] Automated backup strategy (pg_dump, ChromaDB snapshots)

## V5.0 — Community
- [ ] User authentication (JWT + GitHub/Google OAuth)
- [ ] User-submitted platform data with moderation queue
- [ ] Contributor attribution system with citation credit
- [ ] Public API keys with rate limiting
- [ ] Embeddable widgets for defense blogs/publications

See [docs/VERSION_HISTORY.md](docs/VERSION_HISTORY.md) for detailed version-by-version record.
