# PostgreSQL init scripts (`docker-entrypoint-initdb.d`)

This directory is bind-mounted into the Postgres container (see [`docker-compose.yml`](../docker-compose.yml)) so `.sql` and `.sh` files here run **once** on first database initialization.

## V1.1 scope

- **`00-extensions.sql`** enables extensions required by [`schemas/004_extended_schema.sql`](../../schemas/004_extended_schema.sql) (`vector`, `uuid-ossp`, `pgcrypto`, `pg_trgm`) so a fresh dev database is ready for future migrations.
- **Full core schema (`001`–`003`) on Postgres is deferred to V2.0.** The files in [`schemas/`](../../schemas/) target SQLite for the canonical dataset export pipeline; [`001_create_tables.sql`](../../schemas/001_create_tables.sql) uses SQLite `AUTOINCREMENT`, which is not valid PostgreSQL DDL. Applying the full relational model to Postgres should use **Alembic (or equivalent) migrations** in V2.0, not a raw copy of `001` into this folder.

## What works today

- `docker compose up -d postgres` — Postgres with extensions pre-created (after first init).
- Infra-only dev: add `redis`, `chroma`; optional `--profile llm` for Ollama.
- **`backend` / `rag` / `frontend` Compose profiles** expect `../backend`, `../rag`, and `../frontend` at the repo root — those are **V2+** deliverables and are not present in V1.1.

## Resetting the database volume

Init scripts run only when the data volume is empty. To re-run them:

```bash
docker compose down
docker volume rm omhdb-postgres-data   # or: docker volume ls | grep omhdb
docker compose up -d postgres
```
