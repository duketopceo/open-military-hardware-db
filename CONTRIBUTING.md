# Contributing

Thanks for helping improve the Open Military Hardware Database. This project combines a **curated dataset** (JSON → SQLite/CSV/SQL) with **documentation** for a future API, RAG, and web UI (see [docs/ROADMAP.md](docs/ROADMAP.md)).

## Before you start

- Read [README.md](README.md) and the [roadmap](docs/ROADMAP.md).
- Use **Python 3.10+** (CI runs 3.12 and 3.13).
- Keep **imports at the top** of Python files (no inline imports).

## Local setup

```bash
python -m venv .venv
# Windows: .venv\Scripts\activate
# Unix: source .venv/bin/activate
pip install -r requirements.txt
```

### Validate data and run exports

After changing `data/json/platforms.json`:

```bash
python -c "
import json, jsonschema
from pathlib import Path
root = Path('.')
data = json.loads((root / 'data/json/platforms.json').read_text(encoding='utf-8'))
schema = json.loads((root / 'schemas/platform_schema.json').read_text(encoding='utf-8'))
for item in data:
    jsonschema.validate(instance=item, schema=schema)
print('Schema OK:', len(data), 'platforms')
"
python scripts/exporters/export_all.py
```

This refreshes `data/csv/platforms.csv`, `data/sql/military_hardware.db`, and `data/sql/military_hardware_dump.sql`.

### FastAPI backend (V2.0)

See **[backend/README.md](backend/README.md)**. Quick start: install `backend/requirements.txt`, run `export_all.py`, then from `backend/` run `uvicorn app.main:app --reload`. Open `/docs` for OpenAPI.

### Temp dev UI (optional)

For a quick browser view of the JSON dataset:

```bash
python temp/server.py
```

Open http://127.0.0.1:8765 — see [temp/README.md](temp/README.md).

### Docker (infrastructure only)

From `docker/`:

```bash
cd docker
docker compose up -d postgres redis chroma
```

See [docker/README.md](docker/README.md) for profiles and limitations.

## Data contributions

1. Add or edit entries in **`data/json/platforms.json`** to match **[schemas/platform_schema.json](schemas/platform_schema.json)**.
2. Include **at least two independent sources** with URLs (see README dataset guidelines).
3. Prefer **metric** units and **USD** for costs; cite the year for cost figures.
4. Run validation + **`python scripts/exporters/export_all.py`** and commit updated exports if applicable.

## Code contributions

- Open an **issue** first for larger changes (use the templates under `.github/ISSUE_TEMPLATE/`).
- **Pull requests:** use the PR checklist (`.github/pull_request_template.md`).
- Match existing style; we do not require a specific formatter in V1.1, but keep diffs focused.

## Roadmap–related ideas

For release planning or major direction changes, open an issue with the **`roadmap`** label (see [docs/ROADMAP.md](docs/ROADMAP.md#contributing-to-roadmap)).

## License

By contributing, you agree your contributions are under the same license as the project ([LICENSE](LICENSE)).
