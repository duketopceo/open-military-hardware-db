#!/bin/sh
set -e
if echo "${DATABASE_URL}" | grep -q "^postgresql"; then
  echo "Running Alembic migrations..."
  alembic upgrade head
  echo "Seeding database (if empty)..."
  python -m app.seed || true
fi
exec "$@"
