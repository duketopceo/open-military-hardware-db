# OMHDB — Production Deployment Guide

Deploy the Open Military Hardware Database to a Docker Swarm cluster with Cloudflare Tunnel, served as a subdomain of `luke-the-duke.com`.

---

## Architecture

```
Internet → Cloudflare Tunnel → cluster-1-master:5100
                                    │
                              ┌─────┴─────┐
                              │  Docker    │
                              │  Container │
                              │            │
                              │  Express   │ :5000 (→ mapped to 5100)
                              │  ├── React SPA (static)
                              │  └── /api → proxy
                              │       │
                              │  FastAPI   │ :8000 (internal)
                              │  └── SQLite DB
                              └────────────┘
```

- **Express** (port 5000) serves the React intelligence console and proxies `/api/v1` to FastAPI
- **FastAPI** (port 8000) serves the REST API backed by SQLite
- **Cloudflare Tunnel** routes `omhdb.luke-the-duke.com` to port 5100 on the cluster master

---

## Prerequisites

- Docker Swarm cluster running (cluster-1-master as leader)
- `cloudflared` installed on cluster master
- Cloudflare account with `luke-the-duke.com` domain

---

## Step 1: Build & Push the Docker Image

On a machine with Docker and GitHub access:

```bash
# Clone the repo
git clone https://github.com/duketopceo/open-military-hardware-db.git
cd open-military-hardware-db

# Build the production image
docker build -f docker/Dockerfile.prod -t ghcr.io/duketopceo/omhdb:latest .

# Push to GitHub Container Registry
echo $GITHUB_TOKEN | docker login ghcr.io -u duketopceo --password-stdin
docker push ghcr.io/duketopceo/omhdb:latest
```

**Or build directly on the cluster master:**

```bash
cd ~/open-military-hardware-db
git pull
docker build -f docker/Dockerfile.prod -t ghcr.io/duketopceo/omhdb:latest .
```

---

## Step 2: Deploy to Docker Swarm

SSH into the cluster master:

```bash
ssh cluster-1-master@192.168.88.19
```

Deploy the stack:

```bash
cd ~/open-military-hardware-db
docker stack deploy -c docker/docker-compose.swarm.yml omhdb
```

Verify:

```bash
# Check service status
docker service ls

# Check logs
docker service logs omhdb_app -f

# Test locally
curl http://localhost:5100/health
curl http://localhost:5100/api/v1/stats
```

---

## Step 3: Set Up Cloudflare Tunnel

### 3a. Install cloudflared (if not already installed)

```bash
# On cluster master (Linux ARM64 for Mac Mini — check your arch)
# For amd64 (Intel Mac Mini):
curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /usr/local/bin/cloudflared
chmod +x /usr/local/bin/cloudflared

# For arm64 (M1/M4 Mac Mini — if running Linux):
curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 -o /usr/local/bin/cloudflared
chmod +x /usr/local/bin/cloudflared

# For macOS (if Docker Desktop on macOS):
brew install cloudflare/cloudflare/cloudflared
```

### 3b. Authenticate with Cloudflare

```bash
cloudflared tunnel login
# → Opens browser to authorize with your Cloudflare account
```

### 3c. Create the tunnel

```bash
# Create tunnel
cloudflared tunnel create omhdb

# Note the tunnel UUID (e.g., a1b2c3d4-e5f6-7890-abcd-ef1234567890)
```

### 3d. Configure the tunnel

Create `~/.cloudflared/config.yml`:

```yaml
tunnel: <TUNNEL_UUID>
credentials-file: /home/cluster-1-master/.cloudflared/<TUNNEL_UUID>.json

ingress:
  - hostname: omhdb.luke-the-duke.com
    service: http://localhost:5100
  - service: http_status:404
```

### 3e. Add DNS record

```bash
cloudflared tunnel route dns omhdb omhdb.luke-the-duke.com
```

This creates a CNAME record in Cloudflare DNS pointing `omhdb.luke-the-duke.com` to your tunnel.

### 3f. Start the tunnel

```bash
# Test first
cloudflared tunnel run omhdb

# Install as system service (auto-start on boot)
sudo cloudflared service install
sudo systemctl enable cloudflared
sudo systemctl start cloudflared
```

---

## Step 4: Verify

```bash
# Should return the OMHDB intelligence console
curl https://omhdb.luke-the-duke.com

# API health check
curl https://omhdb.luke-the-duke.com/health

# Query platforms
curl "https://omhdb.luke-the-duke.com/api/v1/platforms?limit=5"

# Stats
curl https://omhdb.luke-the-duke.com/api/v1/stats
```

---

## Updating

```bash
# On the cluster master
cd ~/open-military-hardware-db
git pull

# Rebuild
docker build -f docker/Dockerfile.prod -t ghcr.io/duketopceo/omhdb:latest .

# Rolling update
docker service update --image ghcr.io/duketopceo/omhdb:latest omhdb_app
```

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Container won't start | `docker service logs omhdb_app` — check for missing deps |
| API returns 502 | FastAPI hasn't started yet. Check if SQLite DB built correctly |
| Tunnel not connecting | `cloudflared tunnel info omhdb` — verify tunnel UUID and credentials |
| DNS not resolving | Verify CNAME in Cloudflare dashboard: `omhdb.luke-the-duke.com → <tunnel-id>.cfargotunnel.com` |
| Build fails on ARM | Mac Minis with M1/M4 are ARM64 — ensure base images support `linux/arm64` |

---

## Ports Reference

| Port | Service | Exposure |
|------|---------|----------|
| 5000 | Express (React + API proxy) | Internal to container |
| 5100 | Docker published port | Host network |
| 8000 | FastAPI | Internal to container only |
| 443 | Cloudflare Tunnel | Public internet via `omhdb.luke-the-duke.com` |
