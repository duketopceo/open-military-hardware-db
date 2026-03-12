#!/bin/bash
set -e

echo "[mildb] Starting FastAPI backend on port 8000..."
cd /app
uvicorn api.main:app --host 127.0.0.1 --port 8000 --workers 2 &
UVICORN_PID=$!

# Wait for FastAPI to be ready
echo "[mildb] Waiting for FastAPI to become ready..."
for i in $(seq 1 30); do
    if python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/health')" 2>/dev/null; then
        echo "[mildb] FastAPI is ready."
        break
    fi
    if [ $i -eq 30 ]; then
        echo "[mildb] ERROR: FastAPI did not start within 30 seconds."
        exit 1
    fi
    sleep 1
done

echo "[mildb] Starting Express frontend on port 5000..."
cd /app/frontend
NODE_ENV=production PORT=5000 node dist/index.cjs &
NODE_PID=$!

echo "[mildb] All services running. Frontend: :5000 → API proxy → :8000"

# Trap signals for graceful shutdown
trap "echo '[mildb] Shutting down...'; kill $UVICORN_PID $NODE_PID 2>/dev/null; wait; exit 0" SIGTERM SIGINT

# Wait for either process to exit
wait -n $UVICORN_PID $NODE_PID
EXIT_CODE=$?
echo "[mildb] A process exited with code $EXIT_CODE. Shutting down..."
kill $UVICORN_PID $NODE_PID 2>/dev/null
wait
exit $EXIT_CODE
