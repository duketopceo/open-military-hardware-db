# Open Military Hardware DB

> Comprehensive open-source OSINT database of military hardware systems with REST API and intelligence console frontend. 183 platforms, 675 citations.

**Stack:** TypeScript · React 19 · Python · FastAPI · SQLite · Docker
**Visibility:** Public
**Roadmap:** See `ROADMAP.md` for version targets and feature specs.

---

## Project Structure

```
open-military-hardware-db/
├── api/                  # FastAPI REST API
├── backend/              # Python data layer + tests
├── frontend/             # React intelligence console UI
├── data/
│   ├── json/             # Platform data (JSON)
│   ├── csv/              # Exports
│   └── sql/              # SQLite database
├── schemas/              # JSON schemas for validation
├── scripts/              # Data collectors and utilities
├── tests/                # API and data integrity tests
├── docs/                 # Documentation
├── .github/workflows/    # CI pipeline
└── ROADMAP.md            # Version roadmap
```

## Commands

```bash
# Install
pip install -r requirements.txt
cd frontend && npm install

# API
uvicorn api.main:app --host 0.0.0.0 --port 8000

# Frontend
cd frontend && npm run dev

# Test
pytest -v                                    # API + data integrity tests
pytest tests/test_data_integrity.py -v       # Data validation only

# Docker
docker compose -f docker-compose.dev.yml up -d
```

## Project-Specific Rules
- This is a public repo — all data must be from open, publicly available sources
- Every platform entry MUST include source citations — no unsourced military data
- Data integrity tests must pass before any data changes merge
- Never include classified, restricted, or export-controlled information
- SIPRI data attribution must be maintained (see data/README.md)
- Frontend uses dark blueprint + liquid glass aesthetic — maintain design consistency


## Cardinal Rules

These rules are non-negotiable. Violating any one of them is grounds to stop and reassess.

### 1. No Partial Implementations
Never add placeholder code, TODO stubs, mock-only features, or partial logic that doesn't work end-to-end.
- No `// TODO: implement later` stubs that ship
- No fake API calls returning hardcoded data pretending to be real
- No skeleton functions that silently do nothing
- No commented-out blocks left as "future work"
- If a feature isn't ready, don't merge it

### 2. Never Half-Do It
Every commit must leave the codebase in a working state. If you start a feature, finish it or revert. No partial migrations, no half-wired routes, no UI that links to nothing.

### 3. Never Be Unsafe
- NEVER commit secrets, API keys, tokens, passwords, PII, or credentials to code or git history
- All secrets live in `.env` files (which are `.gitignore`d)
- `.env.example` is the template — placeholder values only
- Validate all user input server-side — never trust the client
- Use parameterized queries — never concatenate SQL strings
- Never log or print auth tokens, JWTs, or API keys (even in debug)
- Check `.gitignore` before every commit — no `.env`, `.pem`, `__pycache__`, `.idea`, `node_modules`, `dist/`, `.DS_Store`

### 4. Always Build and Pass All Tests
- Run the full test suite before every commit
- If tests break, fix them before pushing — never push broken tests
- If adding a feature, add tests for that feature in the same PR
- CI must pass before merge — no exceptions, no "I'll fix it later"
- Never mock internal functionality without explicit permission — use real DB connections, real services
- External APIs (third-party, rate-limited, paid) may be mocked

### 5. Version Discipline
- Follow semantic versioning: MAJOR.MINOR.PATCH
- Every release gets a git tag and a GitHub Release with notes
- `ROADMAP.md` is the source of truth for what each version delivers
- Never skip versions or release out of order

## Security Checklist (Run Before Every PR)

```bash
# Scan for accidentally committed secrets
grep -rn "sk-\|password=\|secret=\|PRIVATE_KEY\|api_key=" . --include="*.py" --include="*.ts" --include="*.js" --include="*.env" | grep -v node_modules | grep -v ".env.example" | grep -v "test_"

# Verify .gitignore is working
git status --porcelain | grep -E "\.env$|\.pem$|__pycache__|node_modules|dist/|\.DS_Store"

# If anything shows up ↑ — stop and fix .gitignore before committing
```

## Git Workflow

- Default branch: `main` (or `master` for legacy repos)
- Commit messages: imperative mood, concise (`fix: resolve auth redirect loop`, not `fixed stuff`)
- Prefer atomic commits — one logical change per commit
- Never force-push to `main`
- Use feature branches for anything that touches more than 3 files


## .gitignore Must Cover (Verify These Exist)

Every repo's `.gitignore` must include at minimum:

```
# Secrets & credentials
.env
.env.local
.env.*.local
*.pem
*.key
*.p12
*.pfx
service-account*.json

# Python
__pycache__/
*.py[cod]
*.egg-info/
.venv/
venv/
*.pyc

# Node
node_modules/
dist/
.next/
build/

# IDE
.idea/
.vscode/settings.json
*.swp
*.swo
.DS_Store
Thumbs.db

# Docker
*.log

# OS
.DS_Store
Thumbs.db
```

If any of these patterns are missing from the repo's `.gitignore`, add them before doing anything else.


## How to Contribute to This Repo

1. Read `ROADMAP.md` — know what version you're building toward
2. Read this file (`AGENTS.md`) — follow the cardinal rules
3. Check `.gitignore` covers all patterns listed above
4. Branch off `main` for any multi-file change
5. Write tests for new features (same PR, not "later")
6. Run the full test suite before pushing
7. Write clear commit messages (imperative mood)
8. Open a PR — CI must pass before merge
