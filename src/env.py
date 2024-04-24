from os import getenv
from dotenv import load_dotenv

load_dotenv()

SECRET_KEY = getenv("SECRET_KEY")
if not SECRET_KEY:
    raise ValueError("No SECRET_KEY set for FastAPI application")
ALGORITHM = "HS256"


def not_none(value: str | None) -> str:
    if not value:
        raise ValueError(f"Expected a value, got {value}")
    return value
