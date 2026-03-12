"""
API endpoint tests for the Open Military Hardware Database.
Tests all 6 endpoints + health + root, edge cases, pagination, filtering.
"""
import pytest


# ── Root & Health ────────────────────────────────────────────────────────────

class TestRoot:
    def test_root_returns_200(self, client):
        resp = client.get("/")
        assert resp.status_code == 200

    def test_root_has_version(self, client):
        data = client.get("/").json()
        assert "version" in data
        assert data["version"] == "2.1.0"

    def test_root_has_endpoints(self, client):
        data = client.get("/").json()
        assert "endpoints" in data
        assert "platforms" in data["endpoints"]


class TestHealth:
    def test_health_check(self, client):
        resp = client.get("/health")
        assert resp.status_code == 200
        data = resp.json()
        assert data["status"] == "healthy"
        assert data["database"] == "connected"
        assert data["platforms_count"] > 0


# ── GET /api/v1/platforms ────────────────────────────────────────────────────

class TestListPlatforms:
    def test_default_list(self, client):
        resp = client.get("/api/v1/platforms")
        assert resp.status_code == 200
        data = resp.json()
        assert "platforms" in data
        assert "total" in data
        assert "limit" in data
        assert "offset" in data
        assert data["total"] >= 100  # We know we have 165

    def test_pagination_limit(self, client):
        resp = client.get("/api/v1/platforms?limit=5")
        data = resp.json()
        assert len(data["platforms"]) == 5
        assert data["limit"] == 5

    def test_pagination_offset(self, client):
        resp1 = client.get("/api/v1/platforms?limit=5&offset=0")
        resp2 = client.get("/api/v1/platforms?limit=5&offset=5")
        ids1 = {p["platform_id"] for p in resp1.json()["platforms"]}
        ids2 = {p["platform_id"] for p in resp2.json()["platforms"]}
        assert ids1.isdisjoint(ids2)  # No overlap

    def test_filter_by_category(self, client):
        resp = client.get("/api/v1/platforms?category=air")
        data = resp.json()
        assert data["total"] > 0
        for p in data["platforms"]:
            assert p["category_id"] == "air"

    def test_filter_by_country(self, client):
        resp = client.get("/api/v1/platforms?country=US")
        data = resp.json()
        assert data["total"] > 100
        for p in data["platforms"]:
            assert p["country_of_origin"] == "US"

    def test_filter_by_manufacturer(self, client):
        resp = client.get("/api/v1/platforms?manufacturer=Boeing")
        data = resp.json()
        assert data["total"] > 0
        for p in data["platforms"]:
            assert "Boeing" in p["manufacturer"]

    def test_filter_by_year_range(self, client):
        resp = client.get("/api/v1/platforms?min_year=2000&max_year=2010")
        data = resp.json()
        for p in data["platforms"]:
            year = p.get("entered_service_year")
            if year:
                assert 2000 <= year <= 2010

    def test_search(self, client):
        resp = client.get("/api/v1/platforms?search=Apache")
        data = resp.json()
        assert data["total"] > 0
        # At least one result should mention Apache
        names = [p["common_name"] for p in data["platforms"]]
        assert any("Apache" in n for n in names)

    def test_sort_desc(self, client):
        resp = client.get("/api/v1/platforms?sort_by=entered_service_year&sort_order=desc&limit=5")
        data = resp.json()
        years = [p.get("entered_service_year") for p in data["platforms"] if p.get("entered_service_year")]
        assert years == sorted(years, reverse=True)

    def test_combined_filters(self, client):
        resp = client.get("/api/v1/platforms?category=land&country=US&min_year=1990")
        data = resp.json()
        for p in data["platforms"]:
            assert p["category_id"] == "land"
            assert p["country_of_origin"] == "US"

    def test_empty_result(self, client):
        resp = client.get("/api/v1/platforms?country=ZZ")
        data = resp.json()
        assert data["total"] == 0
        assert data["platforms"] == []

    def test_max_limit(self, client):
        resp = client.get("/api/v1/platforms?limit=200")
        assert resp.status_code == 200

    def test_limit_exceeds_max(self, client):
        resp = client.get("/api/v1/platforms?limit=999")
        assert resp.status_code == 422  # Validation error


# ── GET /api/v1/platforms/{id} ───────────────────────────────────────────────

class TestPlatformDetail:
    def test_valid_platform(self, client):
        # First get a real platform ID
        list_resp = client.get("/api/v1/platforms?limit=1")
        pid = list_resp.json()["platforms"][0]["platform_id"]
        resp = client.get(f"/api/v1/platforms/{pid}")
        assert resp.status_code == 200
        data = resp.json()
        assert data["platform_id"] == pid
        assert "common_name" in data
        assert "specifications" in data
        assert "economics" in data
        assert "armaments" in data
        assert "operators" in data
        assert "conflicts" in data
        assert "sources" in data

    def test_not_found(self, client):
        resp = client.get("/api/v1/platforms/definitely-not-a-real-platform-id")
        assert resp.status_code == 404

    def test_detail_has_nested_data(self, client):
        # Use a known platform that should have rich data
        resp = client.get("/api/v1/platforms?search=Abrams&limit=1")
        platforms = resp.json()["platforms"]
        if platforms:
            pid = platforms[0]["platform_id"]
            detail = client.get(f"/api/v1/platforms/{pid}").json()
            assert isinstance(detail["specifications"], dict)
            assert isinstance(detail["armaments"], list)
            assert isinstance(detail["operators"], list)
            assert isinstance(detail["sources"], list)


# ── GET /api/v1/stats ────────────────────────────────────────────────────────

class TestStats:
    def test_stats_returns_200(self, client):
        resp = client.get("/api/v1/stats")
        assert resp.status_code == 200

    def test_stats_has_counts(self, client):
        data = client.get("/api/v1/stats").json()
        assert data["platforms_count"] >= 165
        assert data["specifications_count"] >= 165
        assert "categories" in data
        assert "countries" in data
        assert "statuses" in data
        assert "eras" in data

    def test_stats_categories(self, client):
        data = client.get("/api/v1/stats").json()
        cats = data["categories"]
        assert "Air" in cats
        assert "Land" in cats
        assert "Sea" in cats
        assert "Munition" in cats


# ── GET /api/v1/categories ───────────────────────────────────────────────────

class TestCategories:
    def test_categories_returns_list(self, client):
        resp = client.get("/api/v1/categories")
        assert resp.status_code == 200
        data = resp.json()
        assert isinstance(data, list)
        assert len(data) >= 4

    def test_categories_have_subcategories(self, client):
        data = client.get("/api/v1/categories").json()
        for cat in data:
            assert "category_id" in cat
            assert "category_name" in cat
            assert "subcategories" in cat
            assert isinstance(cat["subcategories"], list)


# ── GET /api/v1/conflicts ───────────────────────────────────────────────────

class TestConflicts:
    def test_conflicts_returns_list(self, client):
        resp = client.get("/api/v1/conflicts")
        assert resp.status_code == 200
        data = resp.json()
        assert isinstance(data, list)
        assert len(data) >= 5

    def test_conflicts_have_platform_count(self, client):
        data = client.get("/api/v1/conflicts").json()
        for conflict in data:
            assert "conflict_id" in conflict
            assert "conflict_name" in conflict
            assert "platform_count" in conflict
            assert isinstance(conflict["platform_count"], int)


# ── GET /api/v1/compare ─────────────────────────────────────────────────────

class TestCompare:
    def test_compare_two_platforms(self, client):
        list_resp = client.get("/api/v1/platforms?category=air&limit=2")
        pids = [p["platform_id"] for p in list_resp.json()["platforms"]]
        resp = client.get(f"/api/v1/compare?ids={','.join(pids)}")
        assert resp.status_code == 200
        data = resp.json()
        assert data["count"] == 2
        assert len(data["platforms"]) == 2

    def test_compare_missing_ids(self, client):
        resp = client.get("/api/v1/compare?ids=")
        assert resp.status_code == 400

    def test_compare_nonexistent(self, client):
        resp = client.get("/api/v1/compare?ids=fake-id-1,fake-id-2")
        assert resp.status_code == 404

    def test_compare_single(self, client):
        list_resp = client.get("/api/v1/platforms?limit=1")
        pid = list_resp.json()["platforms"][0]["platform_id"]
        resp = client.get(f"/api/v1/compare?ids={pid}")
        assert resp.status_code == 200
        assert resp.json()["count"] == 1
