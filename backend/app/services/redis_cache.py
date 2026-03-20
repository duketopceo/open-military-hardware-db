import json
from typing import Any, Optional

import redis

from app.config import settings

_client: Optional[redis.Redis] = None


def get_redis() -> Optional[redis.Redis]:
    global _client
    if _client is not None:
        return _client
    try:
        _client = redis.from_url(settings.redis_url, decode_responses=True, socket_connect_timeout=1)
        _client.ping()
        return _client
    except (redis.RedisError, OSError):
        _client = None
        return None


def cache_get_json(key: str) -> Optional[Any]:
    r = get_redis()
    if not r:
        return None
    try:
        raw = r.get(key)
        return json.loads(raw) if raw else None
    except (redis.RedisError, json.JSONDecodeError):
        return None


def cache_set_json(key: str, value: Any, ttl_seconds: int = 60) -> None:
    r = get_redis()
    if not r:
        return
    try:
        r.setex(key, ttl_seconds, json.dumps(value))
    except redis.RedisError:
        pass


def cache_delete_pattern(pattern: str) -> None:
    r = get_redis()
    if not r:
        return
    try:
        for k in r.scan_iter(match=pattern):
            r.delete(k)
    except redis.RedisError:
        pass
