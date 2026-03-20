from datetime import datetime, timedelta, timezone
from typing import Any, Optional

from jose import JWTError, jwt

from app.config import settings


def create_access_token(subject: str, extra_claims: Optional[dict[str, Any]] = None) -> str:
    expire = datetime.now(timezone.utc) + timedelta(minutes=settings.access_token_expire_minutes)
    to_encode: dict[str, Any] = {"exp": expire, "sub": subject}
    if extra_claims:
        to_encode.update(extra_claims)
    return jwt.encode(to_encode, settings.secret_key, algorithm="HS256")


def decode_token(token: str) -> dict[str, Any]:
    return jwt.decode(token, settings.secret_key, algorithms=["HS256"])


def safe_decode_token(token: str) -> Optional[dict[str, Any]]:
    try:
        return decode_token(token)
    except JWTError:
        return None
