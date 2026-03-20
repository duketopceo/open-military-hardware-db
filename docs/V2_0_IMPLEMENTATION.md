# V2.0 API implementation — plan closure

This document **finalizes** the phased V2.0 API work described in the internal implementation plan (FastAPI read path → Postgres/Alembic/seed → auth/Redis/writes → GraphQL/admin import).

## Shipped (repository)

| Area | Location / notes |
|------|-------------------|
| FastAPI app | `backend/app/main.py` — `/health`, `/ready`, CORS, structlog |
| REST v1 | `GET/POST/PATCH/DELETE /api/v1/platforms`, `GET /categories`, `GET /conflicts` |
| Auth | `POST /api/v1/auth/login` — JWT bearer for admin write routes |
| Redis | Optional list cache for `GET /platforms` (`backend/app/services/redis_cache.py`) |
| GraphQL | `POST /api/v1/graphql` — Strawberry read (`platforms`, `platform`) |
| Bulk import | `POST /api/v1/admin/import` — JSON array + `platform_schema.json` validation |
| SQLite dev | Default `DATABASE_URL` → `data/sql/military_hardware.db` |
| Postgres + Alembic | `backend/alembic/`, entrypoint runs `alembic upgrade head` + `python -m app.seed` |
| Docker | `backend/Dockerfile`, compose `api` profile + `OMHDB_REPO_ROOT=/import` |
| CI | `.github/workflows/ci.yml` — dataset validation, export, `backend` pytest |
| V1.1 hygiene | `CONTRIBUTING.md`, issue/PR templates, `docs/UI_UX.md`, `docker/init-db/`, etc. |

## Explicitly deferred (full V2.0 roadmap)

- Refresh tokens, Redis **rate limiting**, FastAPI-Admin UI, webhooks, Celery  
- CRUD for every entity type beyond platforms  
- Alembic revision for `004_extended_schema.sql` (documented as manual/future)  
- Optional: Postgres integration job in CI (SQLite-only tests today)

## How to verify

```bash
pip install -r requirements.txt && python scripts/exporters/export_all.py
pip install -r backend/requirements.txt && cd backend && python -m pytest -q
```

Docker: from `docker/`, `docker compose --profile backend up -d postgres redis api` — then `GET http://localhost:8000/api/v1/platforms`.

---

*Status: MVP delivered; treat remaining V2.0 roadmap rows in [ROADMAP.md](ROADMAP.md) as backlog.*
