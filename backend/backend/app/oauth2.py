from fastapi import Depends, HTTPException , status
from jose import JWTError
from datetime import datetime , timedelta
from app import models, schemas , database
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
import jwt
# from .config import settings

oauth2_scheme = OAuth2PasswordBearer(tokenUrl='login')


SECRET_KEY = "abterebinayahamerisaanseinjaisebinaneendiyakiraateinhainto0192837465"


ALGORITHM = "HS256"


ACCESS_TOKEN_EXPIRE_MINUTES = 6000

def create_access_token(data : dict) :
    to_encode = data.copy()
    expire = datetime.now() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp":expire})
    
    encoded_jwt = jwt.encode(to_encode , SECRET_KEY , algorithm=ALGORITHM)
    return encoded_jwt

def verify_access_token(token : str , cred_exceptions) :

    try:
        payload = jwt.decode(token,SECRET_KEY,algorithms=[ALGORITHM])
        user_id : str = payload.get("user_id")
        if not user_id :
            raise cred_exceptions
        token_data = schemas.TokenData(id=str(user_id))
    except JWTError:
        raise cred_exceptions
    
    return token_data
    
def get_current_user(token: str = Depends(oauth2_scheme) , db: Session = Depends(database.get_db)) :
    cred_exceptions = HTTPException(status_code=status.HTTP_401_UNAUTHORIZED,detail="Could not validate credentials" , headers={"WWW_Authenticate":"Bearer"})
    
    token_data = verify_access_token(token, cred_exceptions)
    user = db.query(models.User).filter(models.User.id == token_data.id).first()
    
    if user is None:
        raise cred_exceptions

    return user