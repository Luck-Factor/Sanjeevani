from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"] , deprecated="auto") #Converting password into hash

def hash(password:str) :
    return pwd_context.hash(password)

def verify(plain_password , hashed_password) :  #Will check whether the password entered during login is same as the password entered during signup
    return pwd_context.verify(plain_password , hashed_password)