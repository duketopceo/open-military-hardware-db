# Open Military Hardware Database - Version Roadmap

> A comprehensive roadmap for building an intelligent, AI-powered military hardware knowledge system using 100% open-source technologies.

---

## Vision Statement

Transform the Open Military Hardware Database into a **world-class, AI-enhanced research platform** that combines:
- **Comprehensive relational data** on military platforms worldwide
- **RAG-powered intelligent search** with natural language queries
- **Beautiful, responsive UI/UX** for researchers, analysts, and enthusiasts
- **Full open-source stack** - no vendor lock-in, community-driven development

---

## Version Overview

| Version | Codename | Focus | Status | Timeline |
|---------|----------|-------|--------|----------|
| **V1.0** | Foundation | Core database, schema, data collection | ✅ Complete | Done |
| **V1.1** | Structure | Application framework, architecture docs | 🚧 In Progress | Q1 2026 |
| **V2.0** | API | FastAPI backend, REST/GraphQL endpoints | 📋 Planned | Q2 2026 |
| **V3.0** | Intelligence | RAG system, vector embeddings, AI search | 📋 Planned | Q3 2026 |
| **V4.0** | Experience | Full UI/UX, dashboards, visualizations | 📋 Planned | Q4 2026 |
| **V5.0** | Community | Multi-user, contributions, moderation | 📋 Future | 2027 |

---

## V1.0 — Foundation (✅ Complete)

**Goal:** Establish the core database infrastructure with high-quality military hardware data.

### Completed Features
- [x] **Database Schema** — 11 normalized tables with full referential integrity
- [x] **Initial Dataset** — 50 platforms across air, land, sea, and munitions
- [x] **Data Collectors** — Pluggable scrapers for Wikipedia, GlobalSecurity, Military Factory
- [x] **Validation System** — JSON Schema validation, data normalization
- [x] **Export Formats** — JSON, CSV, SQLite, SQL dump
- [x] **Documentation** — README, schema docs, sample queries

### Data Quality Metrics
| Metric | Coverage |
|--------|----------|
| Specifications | 100% |
| Economics (unit cost) | 96% |
| Source citations | 100% |
| Media references | 100% |
| Operator data | 95% |
| Combat history | 70% |

---

## V1.1 — Structure (🚧 In Progress)

**Goal:** Establish the application framework, architecture, and development roadmap.

### Deliverables
- [ ] **Application Architecture Document** — Full system design
- [ ] **Technology Stack Specification** — All open-source tools and versions
- [ ] **RAG System Design** — Vector DB, embeddings, retrieval pipeline
- [ ] **UI/UX Framework Specification** — Component library, design system
- [ ] **Database Schema Extensions** — RAG tables, user management, analytics
- [ ] **Development Environment Setup** — Docker, dev containers, CI/CD
- [ ] **Contributing Guidelines** — Code standards, PR process, issue templates

---

## V2.0 — API Layer

**Goal:** Build a robust, scalable API backend with full CRUD operations and advanced querying.

### Core API Features
- [ ] **FastAPI Backend** — Modern Python async framework
- [ ] **REST API** — Full CRUD for all entities
- [ ] **GraphQL API** — Flexible querying with Strawberry
- [ ] **Authentication** — JWT-based auth with refresh tokens
- [ ] **Rate Limiting** — Redis-based request throttling
- [ ] **API Documentation** — Auto-generated OpenAPI/Swagger docs

### Data Management
- [ ] **Admin Interface** — FastAPI-Admin for data management
- [ ] **Bulk Import/Export** — CSV, JSON batch operations
- [ ] **Data Versioning** — Audit trail for all changes
- [ ] **Webhook Support** — Event notifications for integrations

### DevOps
- [ ] **Docker Compose** — Development environment
- [ ] **PostgreSQL Migration** — Production-ready database
- [ ] **Redis Cache** — Query caching, session storage
- [ ] **Health Checks** — Monitoring endpoints
- [ ] **Structured Logging** — JSON logs with correlation IDs

### Open-Source Stack (V2.0)
| Component | Technology | License |
|-----------|------------|---------|
| API Framework | FastAPI | MIT |
| GraphQL | Strawberry | MIT |
| ORM | SQLAlchemy 2.0 | MIT |
| Database | PostgreSQL 16 | PostgreSQL |
| Cache | Redis 7 | BSD-3 |
| Migrations | Alembic | MIT |
| Task Queue | Celery + Redis | BSD-3 |
| Auth | Python-Jose (JWT) | MIT |
| Validation | Pydantic v2 | MIT |
| API Docs | Swagger/ReDoc | Apache 2.0 |

---

## V3.0 — Intelligence (RAG System)

**Goal:** Implement AI-powered semantic search using Retrieval-Augmented Generation.

### RAG Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        USER QUERY                                │
│              "Which fighter can fly highest?"                    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    QUERY PROCESSING                              │
│   ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│   │   Embedder   │  │    Rerank    │  │   Intent     │         │
│   │  (Sentence   │  │   (Cross-    │  │  Detection   │         │
│   │ Transformers)│  │   Encoder)   │  │   (spaCy)    │         │
│   └──────────────┘  └──────────────┘  └──────────────┘         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    RETRIEVAL LAYER                               │
│   ┌──────────────────────────────────────────────────────┐      │
│   │              ChromaDB / Qdrant                        │      │
│   │          (Vector Similarity Search)                   │      │
│   │   ┌────────────┐ ┌────────────┐ ┌────────────┐       │      │
│   │   │  Platform  │ │   Specs    │ │  Combat    │       │      │
│   │   │ Embeddings │ │ Embeddings │ │  History   │       │      │
│   │   └────────────┘ └────────────┘ └────────────┘       │      │
│   └──────────────────────────────────────────────────────┘      │
│                                                                  │
│   ┌──────────────────────────────────────────────────────┐      │
│   │              PostgreSQL + pgvector                    │      │
│   │           (Hybrid Search: SQL + Vector)               │      │
│   └──────────────────────────────────────────────────────┘      │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    GENERATION LAYER                              │
│   ┌──────────────────────────────────────────────────────┐      │
│   │                    Ollama                             │      │
│   │        (Local LLM: Llama 3.2, Mistral, etc.)         │      │
│   └──────────────────────────────────────────────────────┘      │
│                              OR                                  │
│   ┌──────────────────────────────────────────────────────┐      │
│   │              LangChain + External API                 │      │
│   │         (OpenAI, Anthropic, Groq - optional)         │      │
│   └──────────────────────────────────────────────────────┘      │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    RESPONSE                                      │
│   "The MiG-31 has the highest service ceiling at 20,600m,       │
│    followed by the F-22 at 19,812m. [Sources: ...]"             │
└─────────────────────────────────────────────────────────────────┘
```

### RAG Features
- [ ] **Semantic Search** — Natural language queries over all platform data
- [ ] **Comparison Engine** — "Compare F-35 vs Su-57 in cost and speed"
- [ ] **Aggregation Queries** — "How many NATO fighters cost over $100M?"
- [ ] **Citation Links** — Every AI response includes source links
- [ ] **Confidence Scores** — Transparency on answer reliability
- [ ] **Conversation History** — Multi-turn Q&A with context

### Embedding Pipeline
- [ ] **Document Chunking** — Optimal text segmentation for retrieval
- [ ] **Multi-field Embeddings** — Separate vectors for specs, history, descriptions
- [ ] **Incremental Updates** — Re-embed only changed records
- [ ] **Embedding Model Selection** — all-MiniLM-L6-v2, BAAI/bge-base, etc.

### Open-Source Stack (V3.0)
| Component | Technology | License |
|-----------|------------|---------|
| Vector Database | ChromaDB | Apache 2.0 |
| Vector DB (Alt) | Qdrant | Apache 2.0 |
| Hybrid Search | pgvector | PostgreSQL |
| Embeddings | Sentence-Transformers | Apache 2.0 |
| LLM Framework | LangChain | MIT |
| Local LLM | Ollama | MIT |
| LLM Models | Llama 3.2, Mistral, Phi-3 | Various (free) |
| NLP Pipeline | spaCy | MIT |
| Reranking | sentence-transformers/cross-encoder | Apache 2.0 |

---

## V4.0 — Experience (UI/UX)

**Goal:** Create a beautiful, responsive web application with rich visualizations.

### UI Framework

```
┌──────────────────────────────────────────────────────────────┐
│                    FRONTEND ARCHITECTURE                      │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│   ┌─────────────────────────────────────────────────────┐   │
│   │                    Next.js 14+                       │   │
│   │              (React Server Components)               │   │
│   └─────────────────────────────────────────────────────┘   │
│                           │                                  │
│   ┌───────────┬───────────┼───────────┬───────────────┐     │
│   │           │           │           │               │     │
│   ▼           ▼           ▼           ▼               ▼     │
│ ┌─────┐   ┌─────┐   ┌──────────┐ ┌──────────┐ ┌──────────┐ │
│ │Tailwind│ │shadcn│  │ Recharts │ │ Leaflet  │ │TanStack │  │
│ │  CSS  │ │  UI  │  │(Charts)  │ │  (Maps)  │ │  Query  │  │
│ └─────┘   └─────┘   └──────────┘ └──────────┘ └──────────┘ │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### Core UI Features
- [ ] **Platform Explorer** — Browse, filter, sort all hardware
- [ ] **Platform Detail Pages** — Rich cards with specs, images, history
- [ ] **Comparison Tool** — Side-by-side platform comparison
- [ ] **AI Chat Interface** — Conversational search with RAG
- [ ] **Search Bar** — Instant search with autocomplete
- [ ] **Dark/Light Mode** — System preference detection

### Data Visualization
- [ ] **Interactive Charts** — Cost, performance, timeline charts
- [ ] **World Map** — Operator locations, conflict zones
- [ ] **Timeline View** — Historical production and service dates
- [ ] **Specification Radar** — Multi-axis performance comparison
- [ ] **Cost Breakdown** — Program vs unit cost visualizations
- [ ] **Combat History** — Conflict involvement timelines

### Dashboard Features
- [ ] **Analytics Dashboard** — Key metrics and insights
- [ ] **Category Overview** — Air/Land/Sea/Munitions summaries
- [ ] **Recent Updates** — Latest data additions
- [ ] **Top Platforms** — Most viewed, highest rated
- [ ] **Cost Rankings** — Most/least expensive by category

### Responsive Design
- [ ] **Mobile-First** — Full functionality on mobile devices
- [ ] **Progressive Web App** — Installable, offline-capable
- [ ] **Accessibility** — WCAG 2.1 AA compliance
- [ ] **Performance** — Core Web Vitals optimization

### Open-Source Stack (V4.0)
| Component | Technology | License |
|-----------|------------|---------|
| Framework | Next.js 14+ | MIT |
| UI Library | React 18+ | MIT |
| Styling | Tailwind CSS 3+ | MIT |
| Component Library | shadcn/ui | MIT |
| Icons | Lucide Icons | ISC |
| Charts | Recharts | MIT |
| Maps | Leaflet / React-Leaflet | BSD-2 |
| Data Tables | TanStack Table | MIT |
| State Management | Zustand | MIT |
| Forms | React Hook Form + Zod | MIT |
| API Client | TanStack Query | MIT |
| Animations | Framer Motion | MIT |

---

## V5.0 — Community

**Goal:** Enable multi-user collaboration, contributions, and community moderation.

### User Features
- [ ] **User Registration** — Email/OAuth signup
- [ ] **User Profiles** — Contribution history, favorites
- [ ] **Saved Searches** — Bookmark and share queries
- [ ] **Watchlists** — Track platforms of interest
- [ ] **Comments/Discussions** — Per-platform discussion threads
- [ ] **Notifications** — Updates on watched platforms

### Contribution System
- [ ] **Data Contributions** — User-submitted corrections
- [ ] **Review Queue** — Moderation workflow
- [ ] **Edit History** — Full audit trail
- [ ] **Reputation System** — Contributor rankings
- [ ] **Source Verification** — Crowdsourced fact-checking

### Moderation Tools
- [ ] **Admin Dashboard** — User management, content moderation
- [ ] **Role-Based Access** — Admin, moderator, contributor, viewer
- [ ] **Spam Detection** — Automated content filtering
- [ ] **Report System** — Flag inappropriate content

### Open-Source Stack (V5.0)
| Component | Technology | License |
|-----------|------------|---------|
| Auth | Keycloak / Auth.js | Apache 2.0 / ISC |
| Comments | Disqus Alternative (Remark42) | MIT |
| Notifications | Novu | MIT |
| Email | Resend / Mailgun | - |
| File Storage | MinIO | AGPL-3.0 |
| Search | Meilisearch | MIT |

---

## Database Schema Evolution

### V2.0 Schema Additions
```sql
-- User management
CREATE TABLE users (
    user_id         UUID PRIMARY KEY,
    email           TEXT UNIQUE NOT NULL,
    password_hash   TEXT NOT NULL,
    display_name    TEXT,
    role            TEXT DEFAULT 'viewer',
    created_at      TIMESTAMP DEFAULT NOW(),
    last_login      TIMESTAMP
);

CREATE TABLE api_keys (
    key_id          UUID PRIMARY KEY,
    user_id         UUID REFERENCES users(user_id),
    key_hash        TEXT NOT NULL,
    name            TEXT,
    permissions     JSONB,
    expires_at      TIMESTAMP,
    created_at      TIMESTAMP DEFAULT NOW()
);

CREATE TABLE audit_log (
    log_id          BIGSERIAL PRIMARY KEY,
    user_id         UUID REFERENCES users(user_id),
    action          TEXT NOT NULL,
    entity_type     TEXT NOT NULL,
    entity_id       TEXT NOT NULL,
    old_value       JSONB,
    new_value       JSONB,
    ip_address      INET,
    created_at      TIMESTAMP DEFAULT NOW()
);
```

### V3.0 Schema Additions (RAG)
```sql
-- Vector embeddings table (using pgvector)
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE platform_embeddings (
    embedding_id    BIGSERIAL PRIMARY KEY,
    platform_id     TEXT REFERENCES platforms(platform_id),
    field_type      TEXT NOT NULL,  -- 'description', 'specs', 'combat_history'
    chunk_index     INTEGER,
    text_content    TEXT NOT NULL,
    embedding       vector(384),    -- Dimension matches embedding model
    model_version   TEXT NOT NULL,
    created_at      TIMESTAMP DEFAULT NOW()
);

CREATE INDEX ON platform_embeddings USING ivfflat (embedding vector_cosine_ops);

CREATE TABLE rag_conversations (
    conversation_id UUID PRIMARY KEY,
    user_id         UUID REFERENCES users(user_id),
    title           TEXT,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

CREATE TABLE rag_messages (
    message_id      BIGSERIAL PRIMARY KEY,
    conversation_id UUID REFERENCES rag_conversations(conversation_id),
    role            TEXT NOT NULL,  -- 'user', 'assistant', 'system'
    content         TEXT NOT NULL,
    sources         JSONB,          -- Referenced platforms/docs
    tokens_used     INTEGER,
    created_at      TIMESTAMP DEFAULT NOW()
);

CREATE TABLE embedding_jobs (
    job_id          UUID PRIMARY KEY,
    status          TEXT DEFAULT 'pending',
    platform_ids    TEXT[],
    progress        INTEGER DEFAULT 0,
    error_message   TEXT,
    created_at      TIMESTAMP DEFAULT NOW(),
    completed_at    TIMESTAMP
);
```

### V4.0 Schema Additions
```sql
-- User preferences and saved content
CREATE TABLE user_favorites (
    favorite_id     BIGSERIAL PRIMARY KEY,
    user_id         UUID REFERENCES users(user_id),
    platform_id     TEXT REFERENCES platforms(platform_id),
    created_at      TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, platform_id)
);

CREATE TABLE saved_comparisons (
    comparison_id   UUID PRIMARY KEY,
    user_id         UUID REFERENCES users(user_id),
    name            TEXT,
    platform_ids    TEXT[],
    created_at      TIMESTAMP DEFAULT NOW()
);

CREATE TABLE platform_views (
    view_id         BIGSERIAL PRIMARY KEY,
    platform_id     TEXT REFERENCES platforms(platform_id),
    user_id         UUID REFERENCES users(user_id),
    session_id      TEXT,
    viewed_at       TIMESTAMP DEFAULT NOW()
);
```

---

## Technology Stack Summary

### Full Open-Source Stack

```
┌───────────────────────────────────────────────────────────────────┐
│                         INFRASTRUCTURE                             │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐  │
│  │   Docker    │ │  Kubernetes │ │   Traefik   │ │  Prometheus │  │
│  │  Compose    │ │   (K3s)     │ │  (Reverse   │ │  + Grafana  │  │
│  │             │ │             │ │   Proxy)    │ │             │  │
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘  │
└───────────────────────────────────────────────────────────────────┘
                                │
┌───────────────────────────────────────────────────────────────────┐
│                           BACKEND                                  │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐  │
│  │   FastAPI   │ │  PostgreSQL │ │    Redis    │ │   Celery    │  │
│  │  + GraphQL  │ │  + pgvector │ │   (Cache)   │ │  (Workers)  │  │
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘  │
└───────────────────────────────────────────────────────────────────┘
                                │
┌───────────────────────────────────────────────────────────────────┐
│                         AI / RAG LAYER                             │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐  │
│  │  LangChain  │ │  ChromaDB / │ │   Ollama    │ │  Sentence   │  │
│  │             │ │   Qdrant    │ │  (Local LLM)│ │ Transformers│  │
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘  │
└───────────────────────────────────────────────────────────────────┘
                                │
┌───────────────────────────────────────────────────────────────────┐
│                          FRONTEND                                  │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐  │
│  │   Next.js   │ │  Tailwind   │ │  shadcn/ui  │ │  Recharts   │  │
│  │   React     │ │    CSS      │ │             │ │  + Leaflet  │  │
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘  │
└───────────────────────────────────────────────────────────────────┘
```

### Complete Dependency List

| Layer | Package | Version | License | Purpose |
|-------|---------|---------|---------|---------|
| **Backend** | FastAPI | 0.110+ | MIT | REST API framework |
| | Strawberry-GraphQL | 0.220+ | MIT | GraphQL API |
| | SQLAlchemy | 2.0+ | MIT | ORM |
| | Pydantic | 2.5+ | MIT | Data validation |
| | Alembic | 1.13+ | MIT | Migrations |
| | Celery | 5.3+ | BSD-3 | Task queue |
| | Redis | 5.0+ | BSD-3 | Cache client |
| | python-jose | 3.3+ | MIT | JWT auth |
| **Database** | PostgreSQL | 16+ | PostgreSQL | Primary database |
| | pgvector | 0.6+ | PostgreSQL | Vector operations |
| | Redis | 7+ | BSD-3 | Caching |
| **RAG** | LangChain | 0.1+ | MIT | LLM framework |
| | ChromaDB | 0.4+ | Apache 2.0 | Vector store |
| | Sentence-Transformers | 2.3+ | Apache 2.0 | Embeddings |
| | Ollama | Latest | MIT | Local LLM |
| | spaCy | 3.7+ | MIT | NLP |
| **Frontend** | Next.js | 14+ | MIT | React framework |
| | React | 18+ | MIT | UI library |
| | Tailwind CSS | 3.4+ | MIT | Styling |
| | shadcn/ui | Latest | MIT | Components |
| | Recharts | 2.10+ | MIT | Charts |
| | Leaflet | 1.9+ | BSD-2 | Maps |
| | TanStack Query | 5+ | MIT | Data fetching |
| | Zustand | 4.5+ | MIT | State |
| **DevOps** | Docker | 24+ | Apache 2.0 | Containers |
| | Traefik | 3+ | MIT | Reverse proxy |
| | Prometheus | 2.50+ | Apache 2.0 | Monitoring |
| | Grafana | 10+ | AGPL-3.0 | Dashboards |
| | Loki | 2.9+ | AGPL-3.0 | Logging |

---

## Milestones & Release Criteria

### V2.0 Release Criteria
- [ ] API endpoints for all platform operations
- [ ] 99%+ test coverage for API layer
- [ ] API response time < 100ms (p95)
- [ ] Documentation site with interactive API explorer
- [ ] Docker Compose setup working on Linux/Mac/Windows
- [ ] PostgreSQL migration complete with zero data loss

### V3.0 Release Criteria
- [ ] RAG system answers 90%+ of factual queries correctly
- [ ] Average query latency < 2 seconds (including LLM)
- [ ] Embeddings for all 50+ platforms
- [ ] Citation accuracy > 95%
- [ ] Works fully offline with Ollama

### V4.0 Release Criteria
- [ ] Lighthouse score > 90 on all metrics
- [ ] WCAG 2.1 AA compliance
- [ ] Mobile responsiveness verified on iOS/Android
- [ ] All visualizations render < 1 second
- [ ] User testing with 10+ beta testers

---

## Contributing to Roadmap

This roadmap is a living document. To propose changes:

1. Open an issue with the `roadmap` label
2. Describe the feature/change and its priority
3. Reference which version it affects
4. Include technical considerations

### Priority Labels
- `P0` — Critical for release
- `P1` — Important but not blocking
- `P2` — Nice to have
- `P3` — Future consideration

---

## License

This roadmap and all associated documentation are released under the MIT License.

---

*Last updated: March 2026*
*Maintainer: Open Military Hardware DB Team*
