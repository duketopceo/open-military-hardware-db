import os
import sys
from pathlib import Path

import pytest

# Repo root (parent of backend/)
_BACKEND_ROOT = Path(__file__).resolve().parents[1]
_REPO_ROOT = _BACKEND_ROOT.parent
os.environ.setdefault(
    "DATABASE_URL",
    f"sqlite:///{(_REPO_ROOT / 'data' / 'sql' / 'military_hardware.db').as_posix()}",
)
os.environ.setdefault("SECRET_KEY", "test-secret")
os.environ.setdefault("ADMIN_USERNAME", "admin")
os.environ.setdefault("ADMIN_PASSWORD", "admin")

if str(_BACKEND_ROOT) not in sys.path:
    sys.path.insert(0, str(_BACKEND_ROOT))

from fastapi.testclient import TestClient

from app.main import app


@pytest.fixture
def client() -> TestClient:
    return TestClient(app)
