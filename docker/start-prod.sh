#!/bin/sh
# OMHDB Production startup — runs FastAPI + Express concurrently

echo "Starting OMHDB production server..."
echo "  FastAPI API:  http://0.0.0.0:8000"
echo "  Express UI:   http://0.0.0.0:5000"

# Start FastAPI in background
uvicorn api.main:app --host 0.0.0.0 --port 8000 --workers 2 &
FASTAPI_PID=$!

# Wait for FastAPI to be ready
echo "Waiting for FastAPI..."
for i in $(seq 1 30); do
  if curl -sf http://localhost:8000/health > /dev/null 2>&1; then
    echo "  FastAPI ready"
    break
  fi
  sleep 1
done

# Start Express frontend (serves React SPA + proxies /api to FastAPI)
cd /app/frontend
NODE_ENV=production node dist/index.cjs &
EXPRESS_PID=$!

echo "OMHDB is live on port 5000"

# Wait for either process to exit (POSIX-compatible, no wait -n)
while kill -0 $FASTAPI_PID 2>/dev/null && kill -0 $EXPRESS_PID 2>/dev/null; do
  sleep 2
done

# If one dies, kill the other
kill $FASTAPI_PID $EXPRESS_PID 2>/dev/null
exit 1
