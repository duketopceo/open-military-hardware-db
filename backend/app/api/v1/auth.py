from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel

from app.config import settings
from app.security import create_access_token

router = APIRouter()


class LoginRequest(BaseModel):
    username: str
    password: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"


@router.post("/login", response_model=TokenResponse)
def login(body: LoginRequest) -> TokenResponse:
    if body.username != settings.admin_username or body.password != settings.admin_password:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid credentials",
        )
    token = create_access_token(body.username, {"role": "admin"})
    return TokenResponse(access_token=token)
