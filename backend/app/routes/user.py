from fastapi import FastAPI , Response , status , HTTPException , Depends , APIRouter
from sqlalchemy.orm import Session
from app import models, schemas, utils
from app.database import get_db

router = APIRouter()

@router.post("/users", status_code=status.HTTP_201_CREATED, response_model=schemas.UserResponse)
async def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    
    existing_user_phone = db.query(models.User).filter(models.User.phone == user.phone).first()
    existing_user_email = db.query(models.User).filter(models.User.email == user.email).first()
    if existing_user_phone or existing_user_email:
        raise HTTPException(status_code=400, detail="User already exists")
    
    hashed_password = utils.hash(user.password)
    user.password = hashed_password
    new_user = models.User(
        name=user.name,
        age=user.age,
        city=user.city,
        phone=user.phone,
        email=user.email,
        password=user.password,
        gender=user.gender
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user