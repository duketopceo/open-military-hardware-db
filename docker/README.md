# Docker (development)

Compose file: [`docker-compose.yml`](docker-compose.yml). Environment template: [`.env.example`](.env.example).

## Prerequisites

- [Docker Compose](https://docs.docker.com/compose/) v2+

Run all commands from this directory:

```bash
cd docker
```

## What runs in V1.1

**Infrastructure (no app code required):**

```bash
docker compose up -d postgres redis chroma
```

- **Postgres** (pgvector image): port `5432`. Init scripts in [`init-db/`](init-db/) create extensions on first start; see [init-db/README.md](init-db/README.md) for schema scope.
- **Redis:** port `6379`
- **ChromaDB:** port `8333` (mapped from container `8000`)

**Optional LLM (heavy / GPU):**

```bash
docker compose --profile llm up -d ollama
```

## Backend API (V2.0)

The **`backend`** profile builds the FastAPI app from [`../backend`](../backend). The repo root is mounted read-only at `/import` as `OMHDB_REPO_ROOT` so migrations and seed can read `data/json/platforms.json` and `schemas/`.

```bash
docker compose --profile backend up -d postgres redis api
```

On first start the API container runs `alembic upgrade head` and `python -m app.seed` (PostgreSQL only), then `uvicorn`. Open http://localhost:8000/docs

Celery services in the same profile still expect full app wiring; use `api` only unless you add Celery tasks.

## Profiles that need more V2+ code

These reference paths that may still be missing or incomplete:

- `--profile rag` — RAG service (`../rag`)
- `--profile frontend` — Next.js (`../frontend`)
- `--profile monitoring` — Prometheus, Grafana (expects config under `docker/prometheus`, `docker/grafana`)
- `--profile tools` — Adminer, Flower

Validate the compose file without starting services:

```bash
docker compose config
```

## Documentation

- [init-db/README.md](init-db/README.md) — Postgres initialization and V2 migration note
