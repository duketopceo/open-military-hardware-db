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
