#!/bin/bash
# === OMHDB Full Deploy — Pull + Build + Stack Deploy ===
# Run on cluster-1-master

set -e

echo "=========================================="
echo "  OMHDB Production Deploy"
echo "=========================================="

cd ~/open-military-hardware-db

echo ""
echo "[1/5] Pulling latest from main..."
git fetch origin
git reset --hard origin/main
echo "  → $(git log --oneline -1)"

echo ""
echo "[2/5] Removing old stack..."
docker stack rm omhdb 2>/dev/null || true
echo "  Waiting for cleanup..."
sleep 8

echo ""
echo "[3/5] Building production image..."
docker build -f docker/Dockerfile.prod -t ghcr.io/duketopceo/omhdb:latest .
echo "  → Build complete"

echo ""
echo "[4/5] Deploying stack..."
docker stack deploy -c docker/docker-compose.swarm.yml omhdb
echo "  Waiting for container startup..."
sleep 20

echo ""
echo "[5/5] Verifying..."
echo ""
echo "--- Service Status ---"
docker service ps omhdb_app --format "table {{.Node}}\t{{.CurrentState}}\t{{.Error}}"
echo ""
echo "--- Health Check ---"
HEALTH=$(curl -sf http://localhost:5100/health 2>/dev/null)
if [ $? -eq 0 ]; then
  echo "  ✓ Health OK: $HEALTH"
else
  echo "  ✗ Health check failed — checking logs..."
  docker service logs omhdb_app --tail 20
  exit 1
fi

echo ""
echo "--- Quick Smoke Test ---"
STATUS=$(curl -so /dev/null -w "%{http_code}" http://localhost:5100/ 2>/dev/null)
echo "  Homepage: HTTP $STATUS"
API=$(curl -sf http://localhost:5100/api/v1/platforms 2>/dev/null | python3 -c "import sys,json; print(len(json.load(sys.stdin)))" 2>/dev/null)
echo "  API platforms: $API"

echo ""
echo "=========================================="
echo "  OMHDB is live on port 5100"
echo "  https://omhdb.luke-the-duke.com"
echo "=========================================="
