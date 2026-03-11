# Open Military Hardware Database - Application Architecture

> Technical architecture document for the full-stack military hardware research platform.

---

## Table of Contents

1. [System Overview](#system-overview)
2. [Architecture Principles](#architecture-principles)
3. [System Components](#system-components)
4. [Data Flow](#data-flow)
5. [RAG System Architecture](#rag-system-architecture)
6. [API Architecture](#api-architecture)
7. [Frontend Architecture](#frontend-architecture)
8. [Database Architecture](#database-architecture)
9. [Security Architecture](#security-architecture)
10. [Deployment Architecture](#deployment-architecture)
11. [Monitoring & Observability](#monitoring--observability)

---

## System Overview

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              CLIENTS                                         │
│   ┌──────────────┐    ┌──────────────┐    ┌──────────────┐                  │
│   │   Web App    │    │  Mobile PWA  │    │  API Clients │                  │
│   │  (Next.js)   │    │  (React)     │    │  (REST/GQL)  │                  │
│   └──────┬───────┘    └──────┬───────┘    └──────┬───────┘                  │
└──────────┼───────────────────┼───────────────────┼──────────────────────────┘
           │                   │                   │
           └───────────────────┼───────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           EDGE / CDN                                         │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                    Cloudflare / Vercel Edge                          │   │
│   │              (Static assets, edge caching, DDoS protection)          │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                       LOAD BALANCER / REVERSE PROXY                          │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                         Traefik v3                                   │   │
│   │           (SSL termination, routing, rate limiting)                  │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
                               │
           ┌───────────────────┼───────────────────┐
           │                   │                   │
           ▼                   ▼                   ▼
┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐
│   FRONTEND       │ │   API BACKEND    │ │   RAG SERVICE    │
│   Next.js        │ │   FastAPI        │ │   LangChain      │
│   (Port 3000)    │ │   (Port 8000)    │ │   (Port 8001)    │
└──────────────────┘ └────────┬─────────┘ └────────┬─────────┘
                              │                    │
                              └────────┬───────────┘
                                       │
           ┌───────────────────────────┼───────────────────────────┐
           │                           │                           │
           ▼                           ▼                           ▼
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│   PostgreSQL     │     │      Redis       │     │   ChromaDB /     │
│   + pgvector     │     │   (Cache/Queue)  │     │   Qdrant         │
│   (Port 5432)    │     │   (Port 6379)    │     │   (Port 8333)    │
└──────────────────┘     └──────────────────┘     └──────────────────┘
                                                           │
                                                           ▼
                                              ┌──────────────────┐
                                              │     Ollama       │
                                              │   (Local LLM)    │
                                              │   (Port 11434)   │
                                              └──────────────────┘
```

---

## Architecture Principles

### Design Principles

1. **Open Source First**
   - All components must be open-source with permissive licenses
   - Avoid vendor lock-in; every component should be replaceable
   - Prefer mature, well-maintained projects with active communities

2. **Modularity**
   - Each service handles a single responsibility
   - Services communicate via well-defined APIs
   - Components can be deployed/scaled independently

3. **Offline Capable**
   - RAG system works fully offline with local LLM (Ollama)
   - PWA support for frontend offline access
   - Local-first architecture where possible

4. **Performance**
   - Sub-100ms API response times (p95)
   - Sub-2s RAG query response times
   - Optimized database queries with proper indexing

5. **Security**
   - Zero-trust architecture
   - Encrypted data at rest and in transit
   - OWASP Top 10 compliance

6. **Observability**
   - Structured logging with correlation IDs
   - Metrics collection with Prometheus
   - Distributed tracing with OpenTelemetry

---

## System Components

### Component Overview

| Component | Technology | Purpose | Port |
|-----------|------------|---------|------|
| Frontend | Next.js 14+ | Web application UI | 3000 |
| API Backend | FastAPI | REST/GraphQL API | 8000 |
| RAG Service | LangChain + FastAPI | AI-powered search | 8001 |
| Primary DB | PostgreSQL 16 | Relational data store | 5432 |
| Vector DB | ChromaDB/Qdrant | Embedding storage | 8333 |
| Cache | Redis 7 | Caching & sessions | 6379 |
| Task Queue | Celery | Background jobs | - |
| Local LLM | Ollama | Offline AI inference | 11434 |
| Reverse Proxy | Traefik | Routing & SSL | 80/443 |
| Monitoring | Prometheus + Grafana | Metrics & dashboards | 9090/3001 |

### Service Dependencies

```
Frontend ──────────▶ API Backend ──────────▶ PostgreSQL
    │                    │                        │
    │                    ├──────────▶ Redis ◀─────┤
    │                    │                        │
    │                    └──────────▶ RAG Service │
    │                                     │       │
    └────────────────────────────────────►│◀──────┘
                                          │
                                          ▼
                              ┌───────────────────┐
                              │  ChromaDB/Qdrant  │
                              │    + Ollama       │
                              └───────────────────┘
```

---

## Data Flow

### Read Flow (Platform Lookup)

```
┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
│ Browser │────▶│ Next.js │────▶│ FastAPI │────▶│PostgreSQL│
│         │◀────│ (SSR)   │◀────│   API   │◀────│         │
└─────────┘     └─────────┘     └─────────┘     └─────────┘
                                     │
                                     ▼
                               ┌───────────┐
                               │   Redis   │
                               │  (Cache)  │
                               └───────────┘
```

### Write Flow (Data Update)

```
┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
│ Admin   │────▶│ Next.js │────▶│ FastAPI │────▶│PostgreSQL│
│  UI     │     │         │     │   API   │     │ (Write) │
└─────────┘     └─────────┘     └─────────┘     └────┬────┘
                                     │               │
                                     ▼               ▼
                               ┌───────────┐  ┌───────────┐
                               │  Celery   │  │ Changelog │
                               │ (Re-embed)│  │  (Audit)  │
                               └─────┬─────┘  └───────────┘
                                     │
                                     ▼
                               ┌───────────┐
                               │ ChromaDB  │
                               │ (Update)  │
                               └───────────┘
```

### RAG Query Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              RAG QUERY FLOW                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  1. USER QUERY                                                              │
│     "What fighter has the longest range?"                                   │
│                         │                                                   │
│                         ▼                                                   │
│  2. QUERY PREPROCESSING                                                     │
│     ┌─────────────────────────────────────────┐                            │
│     │ - Intent classification (comparison)    │                            │
│     │ - Entity extraction (fighter, range)    │                            │
│     │ - Query expansion (combat_radius_km)    │                            │
│     └─────────────────────────────────────────┘                            │
│                         │                                                   │
│                         ▼                                                   │
│  3. EMBEDDING & RETRIEVAL                                                   │
│     ┌─────────────────────────────────────────┐                            │
│     │ Query embedding (Sentence-Transformers) │                            │
│     │            ↓                            │                            │
│     │ Vector search (ChromaDB - top 10)       │                            │
│     │            ↓                            │                            │
│     │ SQL filter (WHERE subcategory='fighter')│                            │
│     │            ↓                            │                            │
│     │ Rerank (Cross-encoder - top 5)          │                            │
│     └─────────────────────────────────────────┘                            │
│                         │                                                   │
│                         ▼                                                   │
│  4. CONTEXT ASSEMBLY                                                        │
│     ┌─────────────────────────────────────────┐                            │
│     │ Retrieved documents:                    │                            │
│     │ - F-35A: range_km=2200, combat_radius=  │                            │
│     │ - Su-57: range_km=3500, combat_radius=  │                            │
│     │ - F-22: range_km=2960, combat_radius=   │                            │
│     │ [+ system prompt, format instructions]  │                            │
│     └─────────────────────────────────────────┘                            │
│                         │                                                   │
│                         ▼                                                   │
│  5. LLM GENERATION                                                          │
│     ┌─────────────────────────────────────────┐                            │
│     │ Ollama (Llama 3.2 / Mistral)            │                            │
│     │ OR LangChain → External API             │                            │
│     └─────────────────────────────────────────┘                            │
│                         │                                                   │
│                         ▼                                                   │
│  6. RESPONSE                                                                │
│     "Based on specifications data, the Su-57 Felon has the longest         │
│      range at 3,500 km, followed by the F-22 Raptor at 2,960 km and        │
│      the F-35A at 2,200 km."                                               │
│     [Sources: su-57, f-22-raptor, f-35a]                                   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## RAG System Architecture

### Component Details

#### 1. Embedding Pipeline

```python
# Embedding Architecture
class EmbeddingPipeline:
    """
    Handles document chunking and embedding generation.
    """
    
    # Embedding model selection
    MODELS = {
        'fast': 'all-MiniLM-L6-v2',        # 384 dims, fastest
        'balanced': 'all-mpnet-base-v2',    # 768 dims, good quality
        'quality': 'BAAI/bge-large-en-v1.5' # 1024 dims, best quality
    }
    
    # Chunking strategy
    CHUNK_STRATEGIES = {
        'description': {'size': 512, 'overlap': 50},
        'specifications': {'size': 256, 'overlap': 0},
        'combat_history': {'size': 1024, 'overlap': 100}
    }
```

#### 2. Vector Store Schema

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         CHROMADB COLLECTIONS                             │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Collection: platform_descriptions                                      │
│  ├── Metadata: {platform_id, category, subcategory, country}           │
│  ├── Document: "The F-35 Lightning II is a fifth-generation..."        │
│  └── Embedding: [0.023, -0.156, 0.892, ...]  (384 dims)                │
│                                                                         │
│  Collection: platform_specifications                                    │
│  ├── Metadata: {platform_id, spec_type}                                │
│  ├── Document: "Speed: 1,930 km/h, Range: 2,200 km, Ceiling: 15,240m" │
│  └── Embedding: [0.112, 0.045, -0.234, ...]  (384 dims)                │
│                                                                         │
│  Collection: combat_history                                             │
│  ├── Metadata: {platform_id, conflict_id, year}                        │
│  ├── Document: "Deployed in Operation Desert Storm, 1991..."           │
│  └── Embedding: [-0.089, 0.234, 0.567, ...]  (384 dims)                │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

#### 3. Retrieval Strategy

```python
class HybridRetriever:
    """
    Combines vector similarity search with SQL filtering.
    """
    
    async def retrieve(self, query: str, filters: dict) -> List[Document]:
        # Step 1: Vector search for semantic similarity
        vector_results = await self.vector_store.similarity_search(
            query=query,
            k=20,
            filter=filters.get('metadata_filter')
        )
        
        # Step 2: SQL search for exact matches
        sql_results = await self.db.execute(
            """
            SELECT * FROM platforms p
            JOIN specifications s ON p.platform_id = s.platform_id
            WHERE p.category_id = :category
            AND p.common_name ILIKE :query
            """,
            {'category': filters.get('category'), 'query': f'%{query}%'}
        )
        
        # Step 3: Merge and deduplicate
        combined = self._merge_results(vector_results, sql_results)
        
        # Step 4: Rerank with cross-encoder
        reranked = await self.reranker.rerank(query, combined, top_k=5)
        
        return reranked
```

#### 4. LLM Integration

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         LLM PROVIDER ABSTRACTION                         │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    LangChain LLM Interface                       │   │
│  │                                                                  │   │
│  │  def get_llm(provider: str, model: str) -> BaseLLM:             │   │
│  │      if provider == "ollama":                                   │   │
│  │          return Ollama(model=model, base_url="localhost:11434") │   │
│  │      elif provider == "openai":                                 │   │
│  │          return ChatOpenAI(model=model)                         │   │
│  │      elif provider == "anthropic":                              │   │
│  │          return ChatAnthropic(model=model)                      │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  Recommended Local Models (Ollama):                                     │
│  ┌─────────────┬─────────────┬─────────────┬───────────────────────┐   │
│  │ Model       │ Size        │ Speed       │ Quality               │   │
│  ├─────────────┼─────────────┼─────────────┼───────────────────────┤   │
│  │ llama3.2:3b │ 2GB         │ Very Fast   │ Good for simple Q&A   │   │
│  │ mistral:7b  │ 4GB         │ Fast        │ Excellent reasoning   │   │
│  │ llama3.2:8b │ 5GB         │ Medium      │ Best quality          │   │
│  │ phi3:mini   │ 2GB         │ Very Fast   │ Good code/data        │   │
│  └─────────────┴─────────────┴─────────────┴───────────────────────┘   │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## API Architecture

### REST API Design

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         API ENDPOINT STRUCTURE                           │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  /api/v1/                                                               │
│  │                                                                      │
│  ├── /platforms                                                         │
│  │   ├── GET    /                    List platforms (paginated)        │
│  │   ├── POST   /                    Create platform (admin)           │
│  │   ├── GET    /{id}                Get platform details              │
│  │   ├── PATCH  /{id}                Update platform (admin)           │
│  │   ├── DELETE /{id}                Delete platform (admin)           │
│  │   ├── GET    /{id}/specifications Get specifications                │
│  │   ├── GET    /{id}/economics      Get economics data                │
│  │   ├── GET    /{id}/operators      Get operators                     │
│  │   ├── GET    /{id}/conflicts      Get combat history                │
│  │   ├── GET    /{id}/media          Get media                         │
│  │   └── GET    /{id}/sources        Get sources                       │
│  │                                                                      │
│  ├── /categories                                                        │
│  │   ├── GET    /                    List categories                   │
│  │   └── GET    /{id}/platforms      List platforms in category        │
│  │                                                                      │
│  ├── /countries                                                         │
│  │   ├── GET    /                    List countries                    │
│  │   └── GET    /{code}/platforms    List platforms by country         │
│  │                                                                      │
│  ├── /conflicts                                                         │
│  │   ├── GET    /                    List conflicts                    │
│  │   └── GET    /{id}/platforms      List platforms in conflict        │
│  │                                                                      │
│  ├── /search                                                            │
│  │   ├── GET    /                    Full-text search                  │
│  │   └── POST   /advanced            Advanced search with filters       │
│  │                                                                      │
│  ├── /compare                                                           │
│  │   └── POST   /                    Compare multiple platforms        │
│  │                                                                      │
│  ├── /rag                                                               │
│  │   ├── POST   /query               Natural language query            │
│  │   ├── GET    /conversations       List user conversations           │
│  │   ├── GET    /conversations/{id}  Get conversation history          │
│  │   └── DELETE /conversations/{id}  Delete conversation               │
│  │                                                                      │
│  └── /admin (protected)                                                 │
│      ├── POST   /import              Bulk import data                  │
│      ├── POST   /export              Export data                       │
│      ├── POST   /reindex             Rebuild search index              │
│      └── GET    /stats               System statistics                 │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### GraphQL Schema

```graphql
type Query {
  # Platforms
  platforms(
    filter: PlatformFilter
    sort: PlatformSort
    pagination: Pagination
  ): PlatformConnection!
  
  platform(id: ID!): Platform
  
  # Categories
  categories: [Category!]!
  category(id: ID!): Category
  
  # Search
  search(query: String!, limit: Int = 10): [Platform!]!
  
  # RAG
  askQuestion(question: String!, conversationId: ID): RAGResponse!
}

type Platform {
  id: ID!
  commonName: String!
  officialDesignation: String
  natoReportingName: String
  category: Category!
  subcategory: Subcategory!
  manufacturer: String!
  countryOfOrigin: Country!
  enteredServiceYear: Int
  status: PlatformStatus!
  description: String
  
  # Relations
  specifications: Specifications
  economics: Economics
  armaments: [Armament!]!
  operators: [Operator!]!
  conflicts: [PlatformConflict!]!
  media: [Media!]!
  sources: [Source!]!
}

type RAGResponse {
  answer: String!
  sources: [Platform!]!
  confidence: Float!
  conversationId: ID!
}
```

### API Response Format

```json
{
  "data": {
    "platform": {
      "id": "f-35a",
      "commonName": "F-35A Lightning II",
      "category": "air",
      "specifications": {
        "speedMaxKmh": 1930,
        "rangeKm": 2200,
        "ceilingM": 15240
      }
    }
  },
  "meta": {
    "requestId": "req_123abc",
    "timestamp": "2026-03-11T12:00:00Z",
    "version": "2.0.0"
  }
}
```

---

## Frontend Architecture

### Component Structure

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      NEXT.JS APPLICATION STRUCTURE                       │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  app/                                                                   │
│  ├── (marketing)/                   # Public marketing pages            │
│  │   ├── page.tsx                   # Landing page                     │
│  │   ├── about/page.tsx             # About page                       │
│  │   └── layout.tsx                 # Marketing layout                 │
│  │                                                                      │
│  ├── (dashboard)/                   # Main application                 │
│  │   ├── platforms/                                                    │
│  │   │   ├── page.tsx               # Platform list/explorer           │
│  │   │   ├── [id]/page.tsx          # Platform detail                  │
│  │   │   └── compare/page.tsx       # Comparison tool                  │
│  │   ├── search/page.tsx            # Advanced search                  │
│  │   ├── chat/page.tsx              # RAG chat interface               │
│  │   ├── analytics/page.tsx         # Dashboard/visualizations         │
│  │   └── layout.tsx                 # Dashboard layout                 │
│  │                                                                      │
│  ├── api/                           # API routes (if needed)           │
│  ├── globals.css                    # Global styles                    │
│  └── layout.tsx                     # Root layout                      │
│                                                                         │
│  components/                                                            │
│  ├── ui/                            # shadcn/ui components             │
│  │   ├── button.tsx                                                    │
│  │   ├── card.tsx                                                      │
│  │   ├── dialog.tsx                                                    │
│  │   └── ...                                                           │
│  ├── platforms/                     # Platform-specific components     │
│  │   ├── PlatformCard.tsx                                              │
│  │   ├── PlatformTable.tsx                                             │
│  │   ├── PlatformDetail.tsx                                            │
│  │   ├── SpecificationCard.tsx                                         │
│  │   └── ComparisonTable.tsx                                           │
│  ├── chat/                          # RAG chat components              │
│  │   ├── ChatInterface.tsx                                             │
│  │   ├── MessageBubble.tsx                                             │
│  │   └── SourceCitation.tsx                                            │
│  ├── visualizations/                # Charts and maps                  │
│  │   ├── CostChart.tsx                                                 │
│  │   ├── PerformanceRadar.tsx                                          │
│  │   ├── WorldMap.tsx                                                  │
│  │   └── TimelineChart.tsx                                             │
│  └── layout/                        # Layout components                │
│      ├── Header.tsx                                                    │
│      ├── Sidebar.tsx                                                   │
│      ├── Footer.tsx                                                    │
│      └── Navigation.tsx                                                │
│                                                                         │
│  lib/                               # Utilities and hooks              │
│  ├── api.ts                         # API client                       │
│  ├── hooks/                         # Custom React hooks               │
│  └── utils.ts                       # Helper functions                 │
│                                                                         │
│  stores/                            # Zustand stores                   │
│  ├── platformStore.ts                                                  │
│  ├── searchStore.ts                                                    │
│  └── chatStore.ts                                                      │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### State Management

```typescript
// Zustand store example
import { create } from 'zustand';

interface PlatformStore {
  platforms: Platform[];
  selectedPlatform: Platform | null;
  filters: PlatformFilters;
  isLoading: boolean;
  
  // Actions
  fetchPlatforms: (filters: PlatformFilters) => Promise<void>;
  selectPlatform: (id: string) => void;
  setFilters: (filters: Partial<PlatformFilters>) => void;
  clearFilters: () => void;
}

export const usePlatformStore = create<PlatformStore>((set, get) => ({
  platforms: [],
  selectedPlatform: null,
  filters: defaultFilters,
  isLoading: false,
  
  fetchPlatforms: async (filters) => {
    set({ isLoading: true });
    const platforms = await api.getPlatforms(filters);
    set({ platforms, isLoading: false });
  },
  
  selectPlatform: (id) => {
    const platform = get().platforms.find(p => p.id === id);
    set({ selectedPlatform: platform });
  },
  
  setFilters: (newFilters) => {
    set({ filters: { ...get().filters, ...newFilters } });
  },
  
  clearFilters: () => {
    set({ filters: defaultFilters });
  },
}));
```

### Design System

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         DESIGN SYSTEM TOKENS                             │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  COLORS (CSS Variables)                                                 │
│  ──────────────────────                                                 │
│  --background:        0 0% 100%        (Light mode)                     │
│  --foreground:        222.2 84% 4.9%                                    │
│  --primary:           221.2 83.2% 53.3%                                 │
│  --primary-foreground: 210 40% 98%                                      │
│  --secondary:         210 40% 96.1%                                     │
│  --muted:             210 40% 96.1%                                     │
│  --accent:            210 40% 96.1%                                     │
│  --destructive:       0 84.2% 60.2%                                     │
│                                                                         │
│  Category Colors:                                                       │
│  --category-air:      207 90% 54%      (#2196F3 - Blue)                │
│  --category-land:     122 39% 49%      (#4CAF50 - Green)               │
│  --category-sea:      200 18% 46%      (#607D8B - Blue Grey)           │
│  --category-munition: 0 65% 51%        (#F44336 - Red)                 │
│                                                                         │
│  TYPOGRAPHY                                                             │
│  ──────────────────────                                                 │
│  Font Family: Inter (headings), System fonts (body)                     │
│  Scale: 12, 14, 16, 18, 20, 24, 30, 36, 48, 60                         │
│  Weights: 400 (normal), 500 (medium), 600 (semibold), 700 (bold)       │
│                                                                         │
│  SPACING                                                                │
│  ──────────────────────                                                 │
│  Base: 4px                                                              │
│  Scale: 0, 1, 2, 3, 4, 5, 6, 8, 10, 12, 16, 20, 24 (× base)            │
│                                                                         │
│  BREAKPOINTS                                                            │
│  ──────────────────────                                                 │
│  sm:  640px                                                             │
│  md:  768px                                                             │
│  lg:  1024px                                                            │
│  xl:  1280px                                                            │
│  2xl: 1536px                                                            │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Database Architecture

### Schema Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                       DATABASE SCHEMA (V3.0)                             │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  REFERENCE TABLES                    CORE TABLES                        │
│  ┌──────────────┐                   ┌──────────────────────────┐       │
│  │ categories   │◀─────────────────┤│       platforms          │       │
│  │ subcategories│                   │├──────────────────────────┤       │
│  │ statuses     │                   ││ platform_id (PK)         │       │
│  │ countries    │◀──────┬──────────┤│ common_name              │       │
│  └──────────────┘       │          ││ category_id (FK)         │       │
│                         │          ││ country_of_origin (FK)   │       │
│  CONFLICT TABLES        │          │└──────────────────────────┘       │
│  ┌──────────────┐       │                      │                        │
│  │ conflicts    │◀──────┼──────────────────────┼────────┐              │
│  │ platform_    │       │                      │        │              │
│  │  conflicts   │       │                      ▼        ▼              │
│  └──────────────┘       │          ┌───────────┐ ┌───────────┐         │
│                         │          │ specs     │ │ economics │         │
│  MEDIA/SOURCE           │          └───────────┘ └───────────┘         │
│  ┌──────────────┐       │                      │                        │
│  │ media        │◀──────┼──────────────────────┤                        │
│  │ sources      │       │                      │                        │
│  └──────────────┘       │                      ▼                        │
│                         │          ┌───────────────────────┐            │
│  OPERATOR TABLE         │          │     armaments         │            │
│  ┌──────────────┐       │          └───────────────────────┘            │
│  │ operators    │◀──────┴──────────────────────┤                        │
│  └──────────────┘                              │                        │
│                                                │                        │
│  RAG TABLES (V3.0)                             │                        │
│  ┌─────────────────────────────────────────────┼───────┐               │
│  │ platform_embeddings                         │       │               │
│  │ rag_conversations ─────▶ rag_messages       │       │               │
│  │ embedding_jobs                              │       │               │
│  └─────────────────────────────────────────────┴───────┘               │
│                                                                         │
│  USER TABLES (V5.0)                                                     │
│  ┌─────────────────────────────────────────────────────┐               │
│  │ users ─────▶ api_keys                               │               │
│  │       ─────▶ user_favorites                         │               │
│  │       ─────▶ saved_comparisons                      │               │
│  │ audit_log                                           │               │
│  └─────────────────────────────────────────────────────┘               │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Index Strategy

```sql
-- High-traffic query indexes
CREATE INDEX idx_platforms_category ON platforms(category_id);
CREATE INDEX idx_platforms_country ON platforms(country_of_origin);
CREATE INDEX idx_platforms_status ON platforms(status_id);
CREATE INDEX idx_platforms_name ON platforms USING gin(to_tsvector('english', common_name));

-- Specification indexes for comparison queries
CREATE INDEX idx_specs_platform ON specifications(platform_id);
CREATE INDEX idx_specs_speed ON specifications(speed_max_kmh);
CREATE INDEX idx_specs_range ON specifications(range_km);

-- Economics indexes for cost analysis
CREATE INDEX idx_economics_cost ON economics(unit_cost_adjusted_2024);

-- Operator indexes
CREATE INDEX idx_operators_country ON operators(country_code);
CREATE INDEX idx_operators_platform ON operators(platform_id);

-- Vector index for embeddings (pgvector)
CREATE INDEX idx_embeddings_vector ON platform_embeddings 
  USING ivfflat (embedding vector_cosine_ops)
  WITH (lists = 100);
```

---

## Security Architecture

### Authentication Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                       AUTHENTICATION FLOW                                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  1. LOGIN REQUEST                                                       │
│     ┌─────────┐          ┌─────────┐          ┌─────────┐              │
│     │ Client  │──POST───▶│ FastAPI │──verify─▶│PostgreSQL│              │
│     │         │  /login  │         │          │ (users) │              │
│     └─────────┘          └────┬────┘          └─────────┘              │
│                               │                                         │
│  2. TOKEN ISSUANCE            ▼                                         │
│                    ┌─────────────────────┐                             │
│                    │ Generate JWT Pair   │                             │
│                    │ - Access Token (15m)│                             │
│                    │ - Refresh Token (7d)│                             │
│                    └──────────┬──────────┘                             │
│                               │                                         │
│  3. TOKEN STORAGE             ▼                                         │
│     ┌─────────┐   ┌─────────────────────┐   ┌─────────┐                │
│     │ Client  │◀──│ Set HttpOnly Cookie │──▶│  Redis  │                │
│     │(Cookies)│   │ (Refresh Token)     │   │(Session)│                │
│     └─────────┘   └─────────────────────┘   └─────────┘                │
│                                                                         │
│  4. AUTHENTICATED REQUEST                                               │
│     ┌─────────┐   Authorization: Bearer <access_token>                 │
│     │ Client  │──────────────────────────────────────────▶ API         │
│     └─────────┘                                                        │
│                                                                         │
│  5. TOKEN REFRESH                                                       │
│     ┌─────────┐          ┌─────────┐          ┌─────────┐              │
│     │ Client  │──POST───▶│ FastAPI │──verify─▶│  Redis  │              │
│     │         │ /refresh │         │          │         │              │
│     └─────────┘          └────┬────┘          └─────────┘              │
│                               │                                         │
│                               ▼                                         │
│                    ┌─────────────────────┐                             │
│                    │ Issue New Access    │                             │
│                    │ Token               │                             │
│                    └─────────────────────┘                             │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Security Measures

| Layer | Measure | Implementation |
|-------|---------|----------------|
| **Transport** | TLS 1.3 | Traefik with Let's Encrypt |
| **Authentication** | JWT + Refresh | python-jose with RS256 |
| **Authorization** | RBAC | Custom middleware |
| **API** | Rate Limiting | Redis-based sliding window |
| **Input** | Validation | Pydantic v2 models |
| **SQL** | Injection Prevention | SQLAlchemy parameterized queries |
| **XSS** | Content Security Policy | Next.js headers config |
| **CSRF** | Token Validation | Same-site cookies |
| **Secrets** | Management | Environment variables / Vault |

---

## Deployment Architecture

### Docker Compose (Development)

```yaml
# docker-compose.yml
version: '3.9'

services:
  # Frontend
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    environment:
      - NEXT_PUBLIC_API_URL=http://localhost:8000
    depends_on:
      - api
      
  # API Backend
  api:
    build: ./backend
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://user:pass@postgres:5432/military_db
      - REDIS_URL=redis://redis:6379
    depends_on:
      - postgres
      - redis
      
  # RAG Service
  rag:
    build: ./rag
    ports:
      - "8001:8001"
    environment:
      - OLLAMA_URL=http://ollama:11434
      - CHROMA_URL=http://chroma:8333
    depends_on:
      - ollama
      - chroma
      
  # PostgreSQL
  postgres:
    image: pgvector/pgvector:pg16
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_DB=military_db
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=pass
    volumes:
      - postgres_data:/var/lib/postgresql/data
      
  # Redis
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
      
  # ChromaDB
  chroma:
    image: chromadb/chroma:latest
    ports:
      - "8333:8000"
    volumes:
      - chroma_data:/chroma/chroma
      
  # Ollama
  ollama:
    image: ollama/ollama:latest
    ports:
      - "11434:11434"
    volumes:
      - ollama_data:/root/.ollama
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]

volumes:
  postgres_data:
  redis_data:
  chroma_data:
  ollama_data:
```

### Production Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      KUBERNETES DEPLOYMENT                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │                        INGRESS (Traefik)                          │  │
│  │                   *.military-hardware.app                         │  │
│  └───────────────────────────────┬──────────────────────────────────┘  │
│                                  │                                      │
│  ┌───────────────────────────────┴──────────────────────────────────┐  │
│  │                        SERVICES                                   │  │
│  │                                                                   │  │
│  │  ┌─────────────┐   ┌─────────────┐   ┌─────────────┐            │  │
│  │  │  Frontend   │   │  API        │   │  RAG        │            │  │
│  │  │  (3 pods)   │   │  (5 pods)   │   │  (2 pods)   │            │  │
│  │  │  HPA: 3-10  │   │  HPA: 5-20  │   │  HPA: 2-5   │            │  │
│  │  └─────────────┘   └─────────────┘   └─────────────┘            │  │
│  │                                                                   │  │
│  │  ┌─────────────┐   ┌─────────────┐                              │  │
│  │  │  Celery     │   │  Celery     │                              │  │
│  │  │  Workers    │   │  Beat       │                              │  │
│  │  │  (3 pods)   │   │  (1 pod)    │                              │  │
│  │  └─────────────┘   └─────────────┘                              │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                                  │                                      │
│  ┌───────────────────────────────┴──────────────────────────────────┐  │
│  │                      STATEFUL SERVICES                            │  │
│  │                                                                   │  │
│  │  ┌─────────────┐   ┌─────────────┐   ┌─────────────┐            │  │
│  │  │  PostgreSQL │   │    Redis    │   │  ChromaDB   │            │  │
│  │  │  (Primary + │   │  (Sentinel) │   │  (Cluster)  │            │  │
│  │  │   Replica)  │   │             │   │             │            │  │
│  │  └─────────────┘   └─────────────┘   └─────────────┘            │  │
│  │                                                                   │  │
│  │  ┌─────────────┐                                                 │  │
│  │  │   Ollama    │   (GPU Node Pool)                              │  │
│  │  │  (1-2 pods) │                                                 │  │
│  │  └─────────────┘                                                 │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Monitoring & Observability

### Metrics Stack

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      OBSERVABILITY STACK                                 │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │                        GRAFANA                                    │  │
│  │                    (Dashboards & Alerts)                          │  │
│  └───────────────────────────────┬──────────────────────────────────┘  │
│                                  │                                      │
│           ┌──────────────────────┼──────────────────────┐              │
│           │                      │                      │              │
│           ▼                      ▼                      ▼              │
│  ┌─────────────┐      ┌─────────────────┐      ┌─────────────┐        │
│  │ Prometheus  │      │      Loki       │      │   Tempo     │        │
│  │  (Metrics)  │      │    (Logging)    │      │  (Tracing)  │        │
│  └──────┬──────┘      └────────┬────────┘      └──────┬──────┘        │
│         │                      │                      │                │
│         │                      │                      │                │
│         ▼                      ▼                      ▼                │
│  ┌─────────────────────────────────────────────────────────────────┐  │
│  │                     APPLICATION LAYER                            │  │
│  │                                                                  │  │
│  │  Frontend ──▶ OpenTelemetry ──▶ Metrics + Traces + Logs         │  │
│  │  API      ──▶ Prometheus Client + Structlog                      │  │
│  │  RAG      ──▶ LangSmith / Phoenix (LLM-specific)                │  │
│  │                                                                  │  │
│  └─────────────────────────────────────────────────────────────────┘  │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Key Metrics

| Category | Metric | Target |
|----------|--------|--------|
| **API** | Response time (p95) | < 100ms |
| | Error rate | < 0.1% |
| | Requests/second | > 1000 |
| **RAG** | Query latency (p95) | < 2s |
| | Retrieval accuracy | > 90% |
| | LLM tokens/query | < 2000 |
| **Database** | Query time (p95) | < 50ms |
| | Connection pool usage | < 80% |
| **Frontend** | Time to First Byte | < 200ms |
| | Largest Contentful Paint | < 2.5s |
| | Core Web Vitals | All green |

### Alerting Rules

```yaml
# prometheus/alerts.yml
groups:
  - name: api-alerts
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.01
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: High error rate detected
          
      - alert: SlowAPIResponse
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 0.1
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: API response time degraded
          
  - name: rag-alerts
    rules:
      - alert: RAGServiceDown
        expr: up{job="rag-service"} == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: RAG service is down
          
      - alert: OllamaHighLatency
        expr: ollama_inference_duration_seconds > 10
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: LLM inference is slow
```

---

## Appendix

### Directory Structure (Complete)

```
open-military-hardware-db/
├── .github/
│   ├── workflows/
│   │   ├── ci.yml
│   │   ├── deploy.yml
│   │   └── security-scan.yml
│   └── ISSUE_TEMPLATE/
│
├── backend/
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py
│   │   ├── config.py
│   │   ├── api/
│   │   │   ├── v1/
│   │   │   │   ├── platforms.py
│   │   │   │   ├── search.py
│   │   │   │   └── ...
│   │   │   └── deps.py
│   │   ├── models/
│   │   ├── schemas/
│   │   ├── services/
│   │   └── core/
│   ├── tests/
│   ├── alembic/
│   ├── Dockerfile
│   └── pyproject.toml
│
├── frontend/
│   ├── app/
│   ├── components/
│   ├── lib/
│   ├── public/
│   ├── Dockerfile
│   └── package.json
│
├── rag/
│   ├── app/
│   │   ├── main.py
│   │   ├── embeddings/
│   │   ├── retrieval/
│   │   └── generation/
│   ├── Dockerfile
│   └── pyproject.toml
│
├── data/
│   ├── csv/
│   ├── json/
│   └── sql/
│
├── schemas/
│   ├── 001_create_tables.sql
│   ├── 002_create_indexes.sql
│   ├── 003_seed_enums.sql
│   └── platform_schema.json
│
├── scripts/
│   ├── collectors/
│   ├── validators/
│   └── exporters/
│
├── docs/
│   ├── ARCHITECTURE.md
│   ├── ROADMAP.md
│   ├── API.md
│   └── sample_queries.sql
│
├── docker/
│   ├── docker-compose.yml
│   ├── docker-compose.prod.yml
│   └── .env.example
│
├── k8s/
│   ├── base/
│   └── overlays/
│
├── .gitignore
├── LICENSE
├── README.md
└── Makefile
```

---

*Document Version: 1.1*
*Last Updated: March 2026*
