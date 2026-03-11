-- ============================================================================
-- OPEN MILITARY HARDWARE DATABASE - Extended Schema v2.0
-- Adds: RAG system tables, User management, Analytics, and API infrastructure
-- PostgreSQL compatible (uses PostgreSQL-specific features)
-- ============================================================================
-- Run after: 001_create_tables.sql
-- Requires: pgvector extension for vector operations
-- ============================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "vector";        -- For embeddings
CREATE EXTENSION IF NOT EXISTS "pg_trgm";       -- For fuzzy text search

-- ============================================================================
-- USER MANAGEMENT TABLES (V2.0)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- USERS TABLE
-- Core user accounts
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    user_id             UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email               TEXT UNIQUE NOT NULL,
    password_hash       TEXT NOT NULL,
    display_name        TEXT,
    avatar_url          TEXT,
    
    -- Role-based access
    role                TEXT NOT NULL DEFAULT 'viewer'
                        CHECK (role IN ('admin', 'moderator', 'contributor', 'viewer', 'api_user')),
    
    -- Account status
    is_active           BOOLEAN DEFAULT TRUE,
    is_verified         BOOLEAN DEFAULT FALSE,
    verification_token  TEXT,
    
    -- Metadata
    preferences_json    JSONB DEFAULT '{}',
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_login_at       TIMESTAMP WITH TIME ZONE,
    login_count         INTEGER DEFAULT 0
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);

-- ----------------------------------------------------------------------------
-- API KEYS TABLE
-- For programmatic access
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS api_keys (
    key_id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id             UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    
    -- Key information
    key_prefix          TEXT NOT NULL,                  -- First 8 chars for identification
    key_hash            TEXT NOT NULL,                  -- SHA-256 of full key
    name                TEXT NOT NULL,                  -- User-provided name
    
    -- Permissions
    permissions         JSONB DEFAULT '{"read": true, "write": false}',
    rate_limit_per_hour INTEGER DEFAULT 1000,
    
    -- Lifecycle
    is_active           BOOLEAN DEFAULT TRUE,
    expires_at          TIMESTAMP WITH TIME ZONE,
    last_used_at        TIMESTAMP WITH TIME ZONE,
    usage_count         INTEGER DEFAULT 0,
    
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_api_keys_user ON api_keys(user_id);
CREATE INDEX idx_api_keys_prefix ON api_keys(key_prefix);

-- ----------------------------------------------------------------------------
-- SESSIONS TABLE
-- For JWT refresh token tracking
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS user_sessions (
    session_id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id             UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    
    refresh_token_hash  TEXT NOT NULL,
    user_agent          TEXT,
    ip_address          INET,
    
    is_valid            BOOLEAN DEFAULT TRUE,
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at          TIMESTAMP WITH TIME ZONE NOT NULL,
    last_activity_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_sessions_user ON user_sessions(user_id);
CREATE INDEX idx_sessions_expires ON user_sessions(expires_at);

-- ============================================================================
-- RAG SYSTEM TABLES (V3.0)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PLATFORM EMBEDDINGS
-- Vector representations of platform data for semantic search
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS platform_embeddings (
    embedding_id        BIGSERIAL PRIMARY KEY,
    platform_id         TEXT NOT NULL REFERENCES platforms(platform_id) ON DELETE CASCADE,
    
    -- Embedding metadata
    field_type          TEXT NOT NULL 
                        CHECK (field_type IN ('description', 'specifications', 'combat_history', 
                                               'economics', 'full_document', 'summary')),
    chunk_index         INTEGER DEFAULT 0,              -- For multi-chunk documents
    chunk_text          TEXT NOT NULL,                  -- Original text that was embedded
    
    -- Vector data (dimension depends on model)
    embedding           vector(384),                    -- all-MiniLM-L6-v2 = 384 dims
    
    -- Model versioning
    model_name          TEXT NOT NULL DEFAULT 'all-MiniLM-L6-v2',
    model_version       TEXT NOT NULL DEFAULT '1.0',
    
    -- Metadata
    token_count         INTEGER,
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Vector similarity index (IVFFlat for approximate nearest neighbor)
CREATE INDEX idx_embeddings_vector ON platform_embeddings 
    USING ivfflat (embedding vector_cosine_ops)
    WITH (lists = 100);

CREATE INDEX idx_embeddings_platform ON platform_embeddings(platform_id);
CREATE INDEX idx_embeddings_field ON platform_embeddings(field_type);

-- ----------------------------------------------------------------------------
-- RAG CONVERSATIONS
-- Chat history for multi-turn conversations
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS rag_conversations (
    conversation_id     UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id             UUID REFERENCES users(user_id) ON DELETE SET NULL,
    session_id          TEXT,                           -- For anonymous users
    
    title               TEXT,                           -- Auto-generated or user-set
    summary             TEXT,                           -- AI-generated summary
    
    -- Conversation metadata
    message_count       INTEGER DEFAULT 0,
    total_tokens_used   INTEGER DEFAULT 0,
    
    -- Model settings used
    model_name          TEXT DEFAULT 'llama3.2:8b',
    temperature         REAL DEFAULT 0.7,
    
    is_archived         BOOLEAN DEFAULT FALSE,
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_conversations_user ON rag_conversations(user_id);
CREATE INDEX idx_conversations_session ON rag_conversations(session_id);

-- ----------------------------------------------------------------------------
-- RAG MESSAGES
-- Individual messages within conversations
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS rag_messages (
    message_id          BIGSERIAL PRIMARY KEY,
    conversation_id     UUID NOT NULL REFERENCES rag_conversations(conversation_id) ON DELETE CASCADE,
    
    -- Message content
    role                TEXT NOT NULL CHECK (role IN ('user', 'assistant', 'system')),
    content             TEXT NOT NULL,
    
    -- RAG-specific data (for assistant messages)
    retrieved_docs      JSONB,                          -- List of {platform_id, score, chunk}
    sources_used        TEXT[],                         -- Array of platform_ids cited
    confidence_score    REAL,                           -- 0-1 confidence in answer
    
    -- Token tracking
    prompt_tokens       INTEGER,
    completion_tokens   INTEGER,
    
    -- Timing
    retrieval_time_ms   INTEGER,
    generation_time_ms  INTEGER,
    
    -- User feedback
    user_rating         INTEGER CHECK (user_rating BETWEEN 1 AND 5),
    user_feedback       TEXT,
    
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_messages_conversation ON rag_messages(conversation_id);
CREATE INDEX idx_messages_created ON rag_messages(created_at);

-- ----------------------------------------------------------------------------
-- EMBEDDING JOBS
-- Track background embedding generation tasks
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS embedding_jobs (
    job_id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Job configuration
    job_type            TEXT NOT NULL CHECK (job_type IN ('full_reindex', 'incremental', 'single_platform')),
    platform_ids        TEXT[],                         -- NULL for full reindex
    model_name          TEXT NOT NULL,
    
    -- Status tracking
    status              TEXT NOT NULL DEFAULT 'pending'
                        CHECK (status IN ('pending', 'running', 'completed', 'failed', 'cancelled')),
    
    progress_current    INTEGER DEFAULT 0,
    progress_total      INTEGER,
    
    -- Results
    embeddings_created  INTEGER DEFAULT 0,
    error_message       TEXT,
    error_details       JSONB,
    
    -- Timing
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    started_at          TIMESTAMP WITH TIME ZONE,
    completed_at        TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_embedding_jobs_status ON embedding_jobs(status);

-- ============================================================================
-- ANALYTICS & USER INTERACTION TABLES (V4.0)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- USER FAVORITES
-- Bookmarked platforms
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS user_favorites (
    favorite_id         BIGSERIAL PRIMARY KEY,
    user_id             UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    platform_id         TEXT NOT NULL REFERENCES platforms(platform_id) ON DELETE CASCADE,
    
    notes               TEXT,
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(user_id, platform_id)
);

CREATE INDEX idx_favorites_user ON user_favorites(user_id);

-- ----------------------------------------------------------------------------
-- SAVED COMPARISONS
-- User-saved platform comparison sets
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS saved_comparisons (
    comparison_id       UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id             UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    
    name                TEXT NOT NULL,
    description         TEXT,
    platform_ids        TEXT[] NOT NULL,
    
    -- Comparison settings
    comparison_fields   TEXT[],                         -- Which fields to compare
    is_public           BOOLEAN DEFAULT FALSE,
    
    view_count          INTEGER DEFAULT 0,
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_comparisons_user ON saved_comparisons(user_id);
CREATE INDEX idx_comparisons_public ON saved_comparisons(is_public) WHERE is_public = TRUE;

-- ----------------------------------------------------------------------------
-- SAVED SEARCHES
-- Saved search queries and filters
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS saved_searches (
    search_id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id             UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    
    name                TEXT NOT NULL,
    query_text          TEXT,
    filters             JSONB NOT NULL DEFAULT '{}',
    
    -- Search settings
    sort_field          TEXT,
    sort_direction      TEXT CHECK (sort_direction IN ('asc', 'desc')),
    
    -- Notification settings
    notify_on_new       BOOLEAN DEFAULT FALSE,
    last_notified_at    TIMESTAMP WITH TIME ZONE,
    
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_saved_searches_user ON saved_searches(user_id);

-- ----------------------------------------------------------------------------
-- PLATFORM VIEWS
-- Analytics for platform page views
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS platform_views (
    view_id             BIGSERIAL PRIMARY KEY,
    platform_id         TEXT NOT NULL REFERENCES platforms(platform_id) ON DELETE CASCADE,
    
    user_id             UUID REFERENCES users(user_id) ON DELETE SET NULL,
    session_id          TEXT,                           -- For anonymous users
    
    -- View context
    referrer            TEXT,
    user_agent          TEXT,
    country_code        TEXT,
    
    -- Engagement
    time_on_page_sec    INTEGER,
    scroll_depth_pct    INTEGER,
    
    viewed_at           TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_platform_views_platform ON platform_views(platform_id);
CREATE INDEX idx_platform_views_date ON platform_views(viewed_at);

-- Materialized view for popular platforms
CREATE MATERIALIZED VIEW IF NOT EXISTS popular_platforms AS
SELECT 
    platform_id,
    COUNT(*) as view_count,
    COUNT(DISTINCT COALESCE(user_id::text, session_id)) as unique_viewers,
    MAX(viewed_at) as last_viewed
FROM platform_views
WHERE viewed_at > NOW() - INTERVAL '30 days'
GROUP BY platform_id
ORDER BY view_count DESC;

CREATE UNIQUE INDEX idx_popular_platforms ON popular_platforms(platform_id);

-- ----------------------------------------------------------------------------
-- SEARCH ANALYTICS
-- Track what users are searching for
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS search_logs (
    log_id              BIGSERIAL PRIMARY KEY,
    
    user_id             UUID REFERENCES users(user_id) ON DELETE SET NULL,
    session_id          TEXT,
    
    -- Query details
    query_text          TEXT NOT NULL,
    query_type          TEXT CHECK (query_type IN ('keyword', 'semantic', 'rag', 'advanced')),
    filters_used        JSONB,
    
    -- Results
    result_count        INTEGER,
    clicked_results     TEXT[],                         -- Platform IDs clicked
    
    -- Timing
    response_time_ms    INTEGER,
    searched_at         TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_search_logs_date ON search_logs(searched_at);
CREATE INDEX idx_search_logs_query ON search_logs USING gin(to_tsvector('english', query_text));

-- ============================================================================
-- AUDIT & COMPLIANCE TABLES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- AUDIT LOG
-- Comprehensive audit trail for all changes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS audit_log (
    log_id              BIGSERIAL PRIMARY KEY,
    
    -- Who
    user_id             UUID REFERENCES users(user_id) ON DELETE SET NULL,
    api_key_id          UUID REFERENCES api_keys(key_id) ON DELETE SET NULL,
    ip_address          INET,
    user_agent          TEXT,
    
    -- What
    action              TEXT NOT NULL 
                        CHECK (action IN ('create', 'read', 'update', 'delete', 'login', 'logout', 
                                          'api_call', 'export', 'import', 'rag_query')),
    entity_type         TEXT NOT NULL,                  -- 'platform', 'user', 'conversation', etc.
    entity_id           TEXT,
    
    -- Details
    old_value           JSONB,
    new_value           JSONB,
    metadata            JSONB,                          -- Additional context
    
    -- Timing
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_audit_log_user ON audit_log(user_id);
CREATE INDEX idx_audit_log_entity ON audit_log(entity_type, entity_id);
CREATE INDEX idx_audit_log_date ON audit_log(created_at);
CREATE INDEX idx_audit_log_action ON audit_log(action);

-- Partition audit log by month for performance
-- (In production, implement table partitioning)

-- ============================================================================
-- DATA CONTRIBUTION TABLES (V5.0)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- DATA CONTRIBUTIONS
-- User-submitted corrections and additions
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS data_contributions (
    contribution_id     UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id             UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    
    -- Target
    platform_id         TEXT REFERENCES platforms(platform_id) ON DELETE CASCADE,
    contribution_type   TEXT NOT NULL 
                        CHECK (contribution_type IN ('new_platform', 'correction', 'addition', 'source')),
    
    -- Content
    field_name          TEXT,
    current_value       TEXT,
    proposed_value      TEXT,
    justification       TEXT,
    source_urls         TEXT[],
    
    -- Review workflow
    status              TEXT NOT NULL DEFAULT 'pending'
                        CHECK (status IN ('pending', 'under_review', 'approved', 'rejected', 'merged')),
    reviewed_by         UUID REFERENCES users(user_id),
    review_notes        TEXT,
    reviewed_at         TIMESTAMP WITH TIME ZONE,
    
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_contributions_user ON data_contributions(user_id);
CREATE INDEX idx_contributions_status ON data_contributions(status);
CREATE INDEX idx_contributions_platform ON data_contributions(platform_id);

-- ----------------------------------------------------------------------------
-- USER REPUTATION
-- Track contributor reliability
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS user_reputation (
    user_id             UUID PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE,
    
    -- Score components
    contributions_total INTEGER DEFAULT 0,
    contributions_approved INTEGER DEFAULT 0,
    contributions_rejected INTEGER DEFAULT 0,
    
    -- Calculated score
    reputation_score    INTEGER DEFAULT 0,
    reputation_level    TEXT DEFAULT 'newcomer'
                        CHECK (reputation_level IN ('newcomer', 'contributor', 'trusted', 'expert', 'moderator')),
    
    -- Badges
    badges              JSONB DEFAULT '[]',
    
    updated_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply to relevant tables
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_conversations_updated_at BEFORE UPDATE ON rag_conversations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_comparisons_updated_at BEFORE UPDATE ON saved_comparisons
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_contributions_updated_at BEFORE UPDATE ON data_contributions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_embeddings_updated_at BEFORE UPDATE ON platform_embeddings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function for semantic search
CREATE OR REPLACE FUNCTION search_platforms_semantic(
    query_embedding vector(384),
    match_threshold float DEFAULT 0.7,
    match_count int DEFAULT 10
)
RETURNS TABLE (
    platform_id text,
    field_type text,
    chunk_text text,
    similarity float
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        pe.platform_id,
        pe.field_type,
        pe.chunk_text,
        1 - (pe.embedding <=> query_embedding) as similarity
    FROM platform_embeddings pe
    WHERE 1 - (pe.embedding <=> query_embedding) > match_threshold
    ORDER BY pe.embedding <=> query_embedding
    LIMIT match_count;
END;
$$ LANGUAGE plpgsql;

-- Function to refresh popular platforms materialized view
CREATE OR REPLACE FUNCTION refresh_popular_platforms()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY popular_platforms;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- COMMENTS
-- ============================================================================

COMMENT ON TABLE platform_embeddings IS 'Vector embeddings for RAG semantic search';
COMMENT ON TABLE rag_conversations IS 'Multi-turn RAG conversation sessions';
COMMENT ON TABLE rag_messages IS 'Individual messages within RAG conversations';
COMMENT ON TABLE users IS 'User accounts for authentication and authorization';
COMMENT ON TABLE api_keys IS 'API keys for programmatic access';
COMMENT ON TABLE audit_log IS 'Comprehensive audit trail for compliance';
COMMENT ON TABLE data_contributions IS 'User-submitted data corrections and additions';

-- ============================================================================
-- END OF EXTENDED SCHEMA
-- ============================================================================
