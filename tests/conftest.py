"""
Shared pytest fixtures for the military hardware database tests.
"""
import pytest
from fastapi.testclient import TestClient
from api.main import app


@pytest.fixture(scope="session")
def client():
    """FastAPI test client — reused across all tests in the session."""
    return TestClient(app)


@pytest.fixture(scope="session")
def db_connection():
    """Direct SQLite connection for data integrity tests."""
    import sqlite3
    from pathlib import Path
    db_path = Path(__file__).parent.parent / "data" / "sql" / "military_hardware.db"
    conn = sqlite3.connect(str(db_path))
    conn.row_factory = sqlite3.Row
    yield conn
    conn.close()


@pytest.fixture(scope="session")
def all_platforms(client):
    """Fetch all platform IDs for parametrized tests."""
    resp = client.get("/api/v1/platforms?limit=200")
    return resp.json()["platforms"]
