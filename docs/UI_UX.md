# UI/UX framework specification (V1.1)

This document formally closes the **V1.1** deliverable for product UX direction. **Implementation** of the production web app is scheduled for **V4.0** (see [ROADMAP.md](ROADMAP.md)).

## Technology choices

The public-facing application is specified to use:

| Layer | Technology |
|-------|------------|
| Framework | Next.js 14+ (React, App Router) |
| Styling | Tailwind CSS |
| Components | shadcn/ui |
| Charts | Recharts |
| Maps | Leaflet / React-Leaflet |
| Data fetching | TanStack Query |
| Tables | TanStack Table |
| State | Zustand (where needed) |

Full versions, licenses, and adjacent backend/AI stack are cataloged in **[TECH_STACK.md](TECH_STACK.md)**.

## Primary screens (product map)

1. **Platform explorer** — Browse, filter, and sort hardware by category, country, era, and text search.
2. **Platform detail** — Rich layout: identity, specifications, economics, operators, conflicts, media, and cited sources.
3. **Compare** — Side-by-side comparison of two or more platforms (specs and cost).
4. **Search** — Full-text and faceted search; later augmented by RAG (V3.0).
5. **RAG chat** — Natural-language Q&A with retrieved context and citations (V3.0+).
6. **Analytics / dashboards** — Aggregate views (cost distributions, category summaries, timelines) (V4.0).

## Detailed design reference

Do not duplicate long-form specs here. Authoritative detail lives in **[ARCHITECTURE.md](ARCHITECTURE.md)**:

- **Frontend Architecture** — Directory layout (`app/`, `components/`, `lib/`, `stores/`), route groups, and feature-oriented components.
- **Design System** — CSS variables, typography scale, spacing, breakpoints, and **category colors** (air / land / sea / munition).

## V1.1 vs later versions

| Phase | UX scope |
|-------|----------|
| **V1.1** | This specification + architecture chapters (no production Next.js app in-repo) |
| **V2.0** | API-only; consumers may build custom UIs |
| **V3.0** | RAG service; chat UX depends on API contracts |
| **V4.0** | Full UI/UX implementation per this document |

## Local preview (non-production)

A **temporary** static UI for dataset smoke-testing may live under `temp/` (see [CONTRIBUTING.md](../CONTRIBUTING.md)). It is not the V4.0 product UI.

---

*Document version: 1.0 — V1.1 structure milestone*
