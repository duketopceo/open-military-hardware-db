# Open Military Hardware DB — API (V2.0)

FastAPI service with REST (read/write), JWT admin auth, Redis-backed list cache (optional), Strawberry GraphQL, and Alembic migrations for PostgreSQL.

## Prerequisites

- Python 3.12+
- SQLite: run `python scripts/exporters/export_all.py` from the **repository root** so `data/sql/military_hardware.db` exists.
- PostgreSQL (Docker): use `docker compose --profile backend up` from `docker/` (see [../docker/README.md](../docker/README.md)).

## Local run (SQLite)

From **repository root**:

```bash
pip install -r backend/requirements.txt
cd backend
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
```

- OpenAPI UI: http://127.0.0.1:8000/docs  
- Health: `GET /health`  
- DB check: `GET /ready`  
- Platforms: `GET /api/v1/platforms`  
- GraphQL: `POST /api/v1/graphql` with JSON body `{"query": "{ platforms(limit: 5) { platformId commonName } }"}`

### Admin (default dev credentials)

Set via env (see `app/config.py`): `ADMIN_USERNAME`, `ADMIN_PASSWORD`, `SECRET_KEY`.

1. `POST /api/v1/auth/login` with `{"username":"admin","password":"admin"}`  
2. Use `Authorization: Bearer <access_token>` for:
   - `POST /api/v1/platforms` — create/replace platform (JSON body, must match `schemas/platform_schema.json`)
   - `PATCH /api/v1/platforms/{platform_id}`
   - `DELETE /api/v1/platforms/{platform_id}`
   - `POST /api/v1/admin/import` — body `{ "platforms": [ ... ] }`

## PostgreSQL + Docker

The API container sets `OMHDB_REPO_ROOT=/import` and mounts the repo read-only so `app.seed` can load `data/json/platforms.json` and `schemas/003_seed_enums.sql` (adapted for Postgres).

Entrypoint (PostgreSQL only): `alembic upgrade head`, then `python -m app.seed`, then `uvicorn`.

Manual seed from repo root (Postgres `DATABASE_URL` set):

```bash
cd backend
set DATABASE_URL=postgresql://user:pass@localhost:5432/military_hardware
alembic upgrade head
python -m app.seed
```

Do **not** run Alembic against the checked-in SQLite file used for export; it is managed by `export_all.py`.

## Tests

```bash
# from repo root: ensure data/sql/military_hardware.db exists (run export_all.py)
cd backend
python -m pytest -q
```

## Environment variables

| Variable | Description |
|----------|-------------|
| `DATABASE_URL` | SQLAlchemy URL (defaults to repo `data/sql/military_hardware.db` SQLite) |
| `REDIS_URL` | Optional; if unreachable, list caching is skipped |
| `SECRET_KEY` | JWT signing |
| `ADMIN_USERNAME` / `ADMIN_PASSWORD` | Login for write routes |
| `CORS_ORIGINS` | Comma-separated origins |
| `OMHDB_REPO_ROOT` | Repo root inside Docker (`/import`) for seed + schema files |
