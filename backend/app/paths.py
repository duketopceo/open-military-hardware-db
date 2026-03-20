"""Resolve repository root (contains data/json/platforms.json)."""

import os
from pathlib import Path


def repo_root() -> Path:
    env = os.environ.get("OMHDB_REPO_ROOT")
    if env:
        p = Path(env)
        if p.is_dir():
            return p.resolve()
    here = Path(__file__).resolve().parent
    for parent in [here, *here.parents]:
        candidate = parent / "data" / "json" / "platforms.json"
        if candidate.is_file():
            return parent
    return Path(__file__).resolve().parents[2]
