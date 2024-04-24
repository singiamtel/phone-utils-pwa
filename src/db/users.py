from typing import Annotated
from db.main import connection
from datetime import timedelta, datetime
from passlib.context import CryptContext
from env import SECRET_KEY, ALGORITHM, not_none
from jose import JWTError, jwt

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

ACCESS_TOKEN_EXPIRE_MINUTES = 30

def hash_password(password):
    return pwd_context.hash(password)

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_user(username: str):
    cursor = connection.cursor()
    cursor.execute(f"SELECT * FROM users WHERE username='{username}' LIMIT 1")

def authenticate_user(username: str, password: str):
    cursor = connection.cursor()
    cursor.execute(f"SELECT * FROM users WHERE username='{username}' LIMIT 1")
    user = cursor.fetchone()
    if not user:
        return False
    if not verify_password(password, user['password']):
        return False
    return True



def create_access_token(data: dict, expires_delta: timedelta = timedelta(minutes=15)):
    to_encode = data.copy()
    expire = datetime.utcnow() + expires_delta
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, not_none(SECRET_KEY), algorithm=ALGORITHM)
    return encoded_jwt

async def get_current_user(token: Annotated[str, ]
