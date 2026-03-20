from fastapi.testclient import TestClient


def test_health(client: TestClient) -> None:
    r = client.get("/health")
    assert r.status_code == 200
    assert r.json() == {"status": "ok"}


def test_ready(client: TestClient) -> None:
    r = client.get("/ready")
    assert r.status_code == 200
    assert r.json()["status"] == "ready"


def test_list_platforms(client: TestClient) -> None:
    r = client.get("/api/v1/platforms?limit=5")
    assert r.status_code == 200
    data = r.json()
    assert "items" in data
    assert "total" in data
    assert len(data["items"]) <= 5
    assert data["total"] >= len(data["items"])


def test_get_platform(client: TestClient) -> None:
    r = client.get("/api/v1/platforms")
    assert r.status_code == 200
    items = r.json()["items"]
    if not items:
        return
    pid = items[0]["platform_id"]
    r2 = client.get(f"/api/v1/platforms/{pid}")
    assert r2.status_code == 200
    body = r2.json()
    assert body["platform_id"] == pid
    assert "common_name" in body


def test_categories_conflicts(client: TestClient) -> None:
    assert client.get("/api/v1/categories").status_code == 200
    assert client.get("/api/v1/conflicts").status_code == 200


def test_login_and_admin_import(client: TestClient) -> None:
    import json
    from pathlib import Path

    r = client.post("/api/v1/auth/login", json={"username": "admin", "password": "admin"})
    assert r.status_code == 200
    token = r.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}
    repo = Path(__file__).resolve().parents[2]
    one = json.loads((repo / "data" / "json" / "platforms.json").read_text(encoding="utf-8"))[0]
    r3 = client.post("/api/v1/admin/import", json={"platforms": [one]}, headers=headers)
    assert r3.status_code == 200
    assert r3.json()["imported"] == 1


def test_graphql_platforms(client: TestClient) -> None:
    r = client.post(
        "/api/v1/graphql",
        json={"query": "{ platforms(limit: 2) { platformId commonName } }"},
    )
    assert r.status_code == 200
    data = r.json()
    assert "data" in data
    assert "platforms" in data["data"]
    assert len(data["data"]["platforms"]) <= 2
