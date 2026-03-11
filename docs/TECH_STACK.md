# Open Military Hardware Database - Technology Stack

> Complete catalog of open-source technologies powering the military hardware research platform.

---

## Stack Overview

The Open Military Hardware Database uses a **100% open-source** technology stack, ensuring no vendor lock-in, full transparency, and community-driven development.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     TECHNOLOGY STACK LAYERS                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ╔═══════════════════════════════════════════════════════════════════╗ │
│  ║                        FRONTEND                                    ║ │
│  ║  Next.js • React • Tailwind CSS • shadcn/ui • Recharts • Leaflet ║ │
│  ╚═══════════════════════════════════════════════════════════════════╝ │
│                                  │                                      │
│  ╔═══════════════════════════════════════════════════════════════════╗ │
│  ║                       API LAYER                                    ║ │
│  ║  FastAPI • Strawberry GraphQL • Pydantic • SQLAlchemy • Alembic  ║ │
│  ╚═══════════════════════════════════════════════════════════════════╝ │
│                                  │                                      │
│  ╔═══════════════════════════════════════════════════════════════════╗ │
│  ║                    AI / RAG LAYER                                  ║ │
│  ║  LangChain • ChromaDB • Sentence-Transformers • Ollama • spaCy   ║ │
│  ╚═══════════════════════════════════════════════════════════════════╝ │
│                                  │                                      │
│  ╔═══════════════════════════════════════════════════════════════════╗ │
│  ║                      DATA LAYER                                    ║ │
│  ║  PostgreSQL • pgvector • Redis • Celery • MinIO                   ║ │
│  ╚═══════════════════════════════════════════════════════════════════╝ │
│                                  │                                      │
│  ╔═══════════════════════════════════════════════════════════════════╗ │
│  ║                    INFRASTRUCTURE                                  ║ │
│  ║  Docker • Kubernetes • Traefik • Prometheus • Grafana • Loki     ║ │
│  ╚═══════════════════════════════════════════════════════════════════╝ │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Frontend Stack

### Core Framework

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Next.js](https://nextjs.org/)** | 14.2+ | MIT | React framework with SSR, routing, API routes |
| **[React](https://react.dev/)** | 18.3+ | MIT | UI component library |
| **[TypeScript](https://www.typescriptlang.org/)** | 5.4+ | Apache 2.0 | Type-safe JavaScript |

### Styling & UI

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Tailwind CSS](https://tailwindcss.com/)** | 3.4+ | MIT | Utility-first CSS framework |
| **[shadcn/ui](https://ui.shadcn.com/)** | Latest | MIT | Accessible component library |
| **[Radix UI](https://www.radix-ui.com/)** | Latest | MIT | Headless UI primitives |
| **[Lucide Icons](https://lucide.dev/)** | 0.365+ | ISC | Beautiful SVG icons |
| **[Framer Motion](https://www.framer.com/motion/)** | 11.0+ | MIT | Animation library |

### Data Visualization

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Recharts](https://recharts.org/)** | 2.12+ | MIT | React charting library |
| **[Leaflet](https://leafletjs.com/)** | 1.9+ | BSD-2 | Interactive maps |
| **[React-Leaflet](https://react-leaflet.js.org/)** | 4.2+ | Hippocratic 2.1 | React wrapper for Leaflet |
| **[D3.js](https://d3js.org/)** | 7.9+ | ISC | Advanced visualizations (optional) |

### State & Data Management

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Zustand](https://zustand-demo.pmnd.rs/)** | 4.5+ | MIT | Lightweight state management |
| **[TanStack Query](https://tanstack.com/query)** | 5.28+ | MIT | Server state management |
| **[TanStack Table](https://tanstack.com/table)** | 8.15+ | MIT | Headless table library |
| **[React Hook Form](https://react-hook-form.com/)** | 7.51+ | MIT | Form handling |
| **[Zod](https://zod.dev/)** | 3.22+ | MIT | Schema validation |

### Developer Experience

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[ESLint](https://eslint.org/)** | 8.57+ | MIT | Linting |
| **[Prettier](https://prettier.io/)** | 3.2+ | MIT | Code formatting |
| **[Vitest](https://vitest.dev/)** | 1.4+ | MIT | Unit testing |
| **[Playwright](https://playwright.dev/)** | 1.42+ | Apache 2.0 | E2E testing |
| **[Storybook](https://storybook.js.org/)** | 8.0+ | MIT | Component documentation |

---

## Backend Stack

### API Framework

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[FastAPI](https://fastapi.tiangolo.com/)** | 0.110+ | MIT | Modern async REST API |
| **[Strawberry](https://strawberry.rocks/)** | 0.220+ | MIT | GraphQL library |
| **[Uvicorn](https://www.uvicorn.org/)** | 0.29+ | BSD-3 | ASGI server |
| **[Gunicorn](https://gunicorn.org/)** | 21.2+ | MIT | Process manager |

### Data Handling

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Pydantic](https://docs.pydantic.dev/)** | 2.6+ | MIT | Data validation |
| **[SQLAlchemy](https://www.sqlalchemy.org/)** | 2.0+ | MIT | ORM |
| **[Alembic](https://alembic.sqlalchemy.org/)** | 1.13+ | MIT | Database migrations |
| **[Pandas](https://pandas.pydata.org/)** | 2.2+ | BSD-3 | Data manipulation |

### Authentication & Security

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[python-jose](https://github.com/mpdavis/python-jose)** | 3.3+ | MIT | JWT handling |
| **[passlib](https://passlib.readthedocs.io/)** | 1.7+ | BSD | Password hashing |
| **[python-multipart](https://github.com/andrew-d/python-multipart)** | 0.0.9+ | Apache 2.0 | Form parsing |

### Background Tasks

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Celery](https://docs.celeryq.dev/)** | 5.3+ | BSD-3 | Task queue |
| **[Celery Beat](https://docs.celeryq.dev/en/stable/userguide/periodic-tasks.html)** | 5.3+ | BSD-3 | Scheduled tasks |
| **[Flower](https://flower.readthedocs.io/)** | 2.0+ | BSD-3 | Celery monitoring |

### Testing

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[pytest](https://pytest.org/)** | 8.1+ | MIT | Testing framework |
| **[pytest-asyncio](https://github.com/pytest-dev/pytest-asyncio)** | 0.23+ | Apache 2.0 | Async test support |
| **[httpx](https://www.python-httpx.org/)** | 0.27+ | BSD-3 | Async HTTP client |
| **[factory_boy](https://factoryboy.readthedocs.io/)** | 3.3+ | MIT | Test fixtures |

---

## AI / RAG Stack

### LLM Framework

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[LangChain](https://python.langchain.com/)** | 0.1+ | MIT | LLM orchestration |
| **[LangGraph](https://langchain-ai.github.io/langgraph/)** | 0.0.30+ | MIT | Agent workflows |
| **[LangSmith](https://smith.langchain.com/)** | Optional | Freemium | LLM observability |

### Vector Databases

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[ChromaDB](https://www.trychroma.com/)** | 0.4+ | Apache 2.0 | Embedded vector store |
| **[Qdrant](https://qdrant.tech/)** | 1.8+ | Apache 2.0 | Production vector DB |
| **[pgvector](https://github.com/pgvector/pgvector)** | 0.6+ | PostgreSQL | PostgreSQL vector extension |

### Embeddings

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Sentence-Transformers](https://sbert.net/)** | 2.6+ | Apache 2.0 | Text embeddings |
| **[HuggingFace Transformers](https://huggingface.co/transformers/)** | 4.39+ | Apache 2.0 | Model hub |
| **[tiktoken](https://github.com/openai/tiktoken)** | 0.6+ | MIT | Token counting |

### Local LLM

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Ollama](https://ollama.ai/)** | Latest | MIT | Local LLM runtime |
| **[llama.cpp](https://github.com/ggerganov/llama.cpp)** | Latest | MIT | CPU inference |
| **[vLLM](https://github.com/vllm-project/vllm)** | 0.3+ | Apache 2.0 | High-throughput inference |

### LLM Models (Open-Source)

| Model | Parameters | License | Best For |
|-------|------------|---------|----------|
| **Llama 3.2** | 3B / 8B / 70B | Llama 3 | General purpose |
| **Mistral** | 7B | Apache 2.0 | Balanced performance |
| **Mixtral** | 8x7B | Apache 2.0 | MoE architecture |
| **Phi-3** | 3.8B | MIT | Small/fast |
| **Gemma 2** | 2B / 7B / 27B | Gemma | Google's open model |
| **Qwen 2** | 7B / 72B | Apache 2.0 | Multilingual |

### NLP Tools

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[spaCy](https://spacy.io/)** | 3.7+ | MIT | NLP pipeline |
| **[NLTK](https://www.nltk.org/)** | 3.8+ | Apache 2.0 | NLP toolkit |

---

## Data Layer

### Primary Database

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[PostgreSQL](https://www.postgresql.org/)** | 16+ | PostgreSQL | Primary relational DB |
| **[pgvector](https://github.com/pgvector/pgvector)** | 0.6+ | PostgreSQL | Vector similarity |
| **[PostGIS](https://postgis.net/)** | 3.4+ | GPL 2.0 | Geospatial extension |

### Caching & Session

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Redis](https://redis.io/)** | 7+ | BSD-3 | Caching, sessions, queues |
| **[Redis Stack](https://redis.io/docs/stack/)** | 7+ | SSPL | Full-text search, JSON |

### Object Storage

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[MinIO](https://min.io/)** | Latest | AGPL-3.0 | S3-compatible storage |

### Search Engine (Optional)

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Meilisearch](https://www.meilisearch.com/)** | 1.7+ | MIT | Fast full-text search |
| **[Elasticsearch](https://www.elastic.co/elasticsearch/)** | 8.13+ | SSPL | Advanced search |
| **[OpenSearch](https://opensearch.org/)** | 2.13+ | Apache 2.0 | ES alternative |

---

## Infrastructure

### Containerization

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Docker](https://www.docker.com/)** | 25+ | Apache 2.0 | Containerization |
| **[Docker Compose](https://docs.docker.com/compose/)** | 2.26+ | Apache 2.0 | Local orchestration |
| **[BuildKit](https://docs.docker.com/build/buildkit/)** | Latest | Apache 2.0 | Modern builds |

### Orchestration

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Kubernetes](https://kubernetes.io/)** | 1.29+ | Apache 2.0 | Container orchestration |
| **[K3s](https://k3s.io/)** | Latest | Apache 2.0 | Lightweight K8s |
| **[Helm](https://helm.sh/)** | 3.14+ | Apache 2.0 | Package manager |
| **[Kustomize](https://kustomize.io/)** | 5.3+ | Apache 2.0 | Config management |

### Reverse Proxy & Load Balancing

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Traefik](https://traefik.io/)** | 3.0+ | MIT | Reverse proxy, LB |
| **[Nginx](https://nginx.org/)** | 1.25+ | BSD-2 | Alternative proxy |
| **[HAProxy](https://www.haproxy.org/)** | 2.9+ | GPL 2.0 | TCP/HTTP LB |

### SSL/TLS

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Let's Encrypt](https://letsencrypt.org/)** | - | - | Free SSL certs |
| **[cert-manager](https://cert-manager.io/)** | 1.14+ | Apache 2.0 | K8s cert management |

---

## Observability

### Metrics

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Prometheus](https://prometheus.io/)** | 2.50+ | Apache 2.0 | Metrics collection |
| **[Grafana](https://grafana.com/)** | 10.4+ | AGPL-3.0 | Dashboards |
| **[VictoriaMetrics](https://victoriametrics.com/)** | 1.99+ | Apache 2.0 | Prometheus alternative |

### Logging

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Loki](https://grafana.com/oss/loki/)** | 2.9+ | AGPL-3.0 | Log aggregation |
| **[Promtail](https://grafana.com/docs/loki/latest/send-data/promtail/)** | 2.9+ | AGPL-3.0 | Log shipper |
| **[Structlog](https://www.structlog.org/)** | 24.1+ | MIT | Python structured logging |

### Tracing

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[OpenTelemetry](https://opentelemetry.io/)** | 1.23+ | Apache 2.0 | Distributed tracing |
| **[Tempo](https://grafana.com/oss/tempo/)** | 2.4+ | AGPL-3.0 | Trace storage |
| **[Jaeger](https://www.jaegertracing.io/)** | 1.55+ | Apache 2.0 | Trace UI |

### Alerting

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Alertmanager](https://prometheus.io/docs/alerting/latest/alertmanager/)** | 0.27+ | Apache 2.0 | Alert routing |
| **[Grafana OnCall](https://grafana.com/oss/oncall/)** | Latest | AGPL-3.0 | Incident management |

---

## Development Tools

### Version Control

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Git](https://git-scm.com/)** | 2.44+ | GPL 2.0 | Version control |
| **[GitHub Actions](https://github.com/features/actions)** | - | - | CI/CD |
| **[Pre-commit](https://pre-commit.com/)** | 3.6+ | MIT | Git hooks |

### Code Quality

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Ruff](https://docs.astral.sh/ruff/)** | 0.3+ | MIT | Python linting (fast) |
| **[Black](https://black.readthedocs.io/)** | 24.2+ | MIT | Python formatting |
| **[mypy](https://mypy-lang.org/)** | 1.9+ | MIT | Type checking |
| **[Biome](https://biomejs.dev/)** | 1.6+ | MIT | JS/TS linting |

### Documentation

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[MkDocs](https://www.mkdocs.org/)** | 1.5+ | BSD-2 | Documentation site |
| **[Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)** | 9.5+ | MIT | MkDocs theme |
| **[Swagger UI](https://swagger.io/tools/swagger-ui/)** | 5.12+ | Apache 2.0 | API docs |
| **[ReDoc](https://redocly.com/redoc/)** | 2.1+ | MIT | API docs alt |

### Secret Management

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[HashiCorp Vault](https://www.vaultproject.io/)** | 1.15+ | BSL | Secrets management |
| **[SOPS](https://github.com/getsops/sops)** | 3.8+ | MPL 2.0 | Secret encryption |
| **[Doppler](https://www.doppler.com/)** | - | Freemium | Secret sync |

---

## Data Collection

### Web Scraping

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Beautiful Soup](https://www.crummy.com/software/BeautifulSoup/)** | 4.12+ | MIT | HTML parsing |
| **[lxml](https://lxml.de/)** | 5.1+ | BSD | XML/HTML parser |
| **[Playwright](https://playwright.dev/python/)** | 1.42+ | Apache 2.0 | Browser automation |
| **[Scrapy](https://scrapy.org/)** | 2.11+ | BSD-3 | Web crawling |

### Data Validation

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[jsonschema](https://python-jsonschema.readthedocs.io/)** | 4.21+ | MIT | JSON Schema validation |
| **[Great Expectations](https://greatexpectations.io/)** | 0.18+ | Apache 2.0 | Data quality |

---

## Security Tools

### Vulnerability Scanning

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[Trivy](https://trivy.dev/)** | 0.50+ | Apache 2.0 | Container scanning |
| **[Bandit](https://bandit.readthedocs.io/)** | 1.7+ | Apache 2.0 | Python security |
| **[Dependabot](https://docs.github.com/en/code-security/dependabot)** | - | - | Dependency updates |
| **[Snyk](https://snyk.io/)** | - | Freemium | Security scanning |

### API Security

| Technology | Version | License | Purpose |
|------------|---------|---------|---------|
| **[OWASP ZAP](https://www.zaproxy.org/)** | 2.14+ | Apache 2.0 | API security testing |
| **[rate-limit](https://github.com/andialbrecht/rate-limit)** | - | MIT | Rate limiting |

---

## Quick Start Commands

### Install Development Environment

```bash
# Clone repository
git clone https://github.com/duketopceo/open-military-hardware-db.git
cd open-military-hardware-db

# Start development stack
docker compose up -d

# Install Python dependencies
pip install -r requirements.txt

# Install Node dependencies (frontend)
cd frontend && npm install

# Run database migrations
alembic upgrade head

# Start development servers
make dev
```

### Pull Recommended LLM Models

```bash
# Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Pull models
ollama pull llama3.2:3b      # Fast, small
ollama pull mistral:7b       # Balanced
ollama pull llama3.2:8b      # Best quality
```

---

## Version Compatibility Matrix

| Component | Min Version | Recommended | Max Tested |
|-----------|-------------|-------------|------------|
| Python | 3.10 | 3.12 | 3.12 |
| Node.js | 18.0 | 20.x LTS | 21.x |
| PostgreSQL | 14 | 16 | 16 |
| Redis | 6.2 | 7.2 | 7.2 |
| Docker | 23.0 | 25.x | 26.x |

---

## License Summary

All technologies in this stack use permissive open-source licenses:

| License | Technologies |
|---------|-------------|
| **MIT** | Next.js, React, FastAPI, LangChain, shadcn/ui, Tailwind, etc. |
| **Apache 2.0** | Kubernetes, Prometheus, ChromaDB, Sentence-Transformers |
| **BSD** | PostgreSQL, Redis, NumPy, Pandas |
| **AGPL-3.0** | Grafana, Loki (self-hosted is fine) |
| **PostgreSQL** | PostgreSQL, pgvector |

**Note:** The AGPL-3.0 license for Grafana/Loki only applies if you're modifying and distributing those tools. Using them as-is for monitoring is fully permitted.

---

*Last updated: March 2026*
