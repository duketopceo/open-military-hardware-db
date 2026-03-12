# Open Military Hardware Database — API Server
# Multi-stage build: ~120MB final image
# Usage: docker build -t mildb-api . && docker run -p 8000:8000 mildb-api

# ── Stage 1: Build dependencies ─────────────────────────────────────────────
FROM python:3.12-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install \
    fastapi uvicorn pydantic

# ── Stage 2: Runtime ─────────────────────────────────────────────────────────
FROM python:3.12-slim

LABEL maintainer="Open Military Hardware DB <https://github.com/duketopceo/open-military-hardware-db>"
LABEL description="REST API for the Open Military Hardware Database"
LABEL version="2.1.0"

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /install /usr/local

# Copy application code
COPY api/ ./api/
COPY data/sql/military_hardware.db ./data/sql/military_hardware.db
COPY data/json/platforms.json ./data/json/platforms.json
COPY schemas/ ./schemas/

# Create non-root user
RUN adduser --disabled-password --gecos "" appuser
USER appuser

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "2"]
