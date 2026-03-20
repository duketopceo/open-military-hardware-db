-- Extensions required by schemas/004_extended_schema.sql (PostgreSQL).
-- Core platform tables (001–003) are applied via SQLite export in V1.1; Postgres migrations planned for V2.0.

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "vector";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
