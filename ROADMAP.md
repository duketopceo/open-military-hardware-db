# Open Military Hardware DB — Roadmap

## Current: v2.0.0 (Stable)
- [x] 183 platforms across 5 domains (air, land, sea, munitions, software)
- [x] 675 source citations with full provenance
- [x] SIPRI external data (175 countries, 1949–2024)
- [x] FastAPI REST API with filtering, pagination, sorting, comparison
- [x] Intelligence console frontend (React 19, dark blueprint aesthetic)
- [x] Structured exports (JSON, CSV, SQLite, SQL dump)
- [x] Data collection framework with rate limiting and caching
- [x] Role classification (offensive/defensive/dual/support/intelligence)
- [x] Contractor filtering (Boeing, Lockheed Martin, Anduril, Palantir, etc.)
- [x] Docker containerization
- [x] CI pipeline (GitHub Actions)
- [x] Test suite (API tests + data integrity tests)
- [x] Enterprise standards (AGENTS.md, CHANGELOG.md, structured logging, release automation)

## v2.1.0 — Test Coverage & Data Quality
- [ ] Expand pytest suite to 90%+ API endpoint coverage
- [ ] Schema integrity validation (all platforms match schema, no orphaned citations)
- [ ] Citation completeness audit (flag platforms with <3 sources)
- [ ] Frontend component tests (Vitest + React Testing Library)
- [ ] Automated data freshness checks (alert on stale SIPRI data)
- [ ] Performance benchmarks for API response times under load

## v3.0.0 — Advanced Analytics
- [ ] 300+ platforms (expand to NATO allies and key adversaries)
- [ ] Conflict timeline visualization (interactive D3.js)
- [ ] Force composition analysis tool (compare countries side-by-side)
- [ ] Procurement cost trend charts (constant-dollar adjusted)
- [ ] Unit cost comparison across NATO members
- [ ] GraphQL API alongside REST
- [ ] PDF report generation for country/platform profiles

## v4.0.0 — Community & Contribution
- [ ] User-submitted platform data with moderation queue
- [ ] Contributor attribution system with citation credit
- [ ] Automated OSINT collector for new platforms (RSS feeds, defense news)
- [ ] Satellite imagery integration (Sentinel-2, public sources)
- [ ] Export to common defense analysis formats (OOB, ORBAT)
- [ ] Embeddable widgets for defense blogs/publications
