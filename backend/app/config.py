from pydantic import model_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


def _default_sqlite_url() -> str:
    """SQLite file under repo data/sql (uses app.paths once settings load)."""
    from app.paths import repo_root

    db_path = repo_root() / "data" / "sql" / "military_hardware.db"
    return f"sqlite:///{db_path.as_posix()}"


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    app_name: str = "Open Military Hardware API"
    debug: bool = False
    database_url: str = ""
    redis_url: str = "redis://localhost:6379/0"
    secret_key: str = "change-me-in-production"
    access_token_expire_minutes: int = 60
    admin_username: str = "admin"
    admin_password: str = "admin"
    cors_origins: str = "http://localhost:3000,http://127.0.0.1:3000,http://127.0.0.1:8765"

    @model_validator(mode="after")
    def default_database_url(self) -> "Settings":
        if not self.database_url:
            self.database_url = _default_sqlite_url()
        return self

    @property
    def cors_origin_list(self) -> list[str]:
        return [o.strip() for o in self.cors_origins.split(",") if o.strip()]


settings = Settings()
