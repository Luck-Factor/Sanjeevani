from fastapi import APIRouter , Depends , status , HTTPException , Response
from sqlalchemy.orm import Session
from app import models, schemas, utils , oauth2
from app.database import get_db

router = APIRouter()

@router.post("/login", status_code=status.HTTP_202_ACCEPTED)
async def login(user_creds: schemas.UserLogin, db: Session=Depends(get_db)) :
    user = db.query(models.User).filter(models.User.email==user_creds.email).first()
    user_name = db.query(models.User).filter(models.User.name==user_creds.name).first()
    if not user_name: 
        raise HTTPException(status_code=status.HTTP_406_NOT_ACCEPTABLE, detail="User Name is Wrong")
    
    if not user: 
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User does not exists")
    
    if not utils.verify(user_creds.password, user.password) :
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Invalid Password")
    
    access_token = oauth2.create_access_token(data={"user_id":user.id})

    return {"access token" : access_token, "token type": "bearer", 'user':user, "user_id":user.id, 'email':user.email, 'name':user.name, 'age':user.age, 'city':user.city, 'gender':user.gender,'phone':user.phone}


@router.post("/hospital_login", status_code=status.HTTP_202_ACCEPTED)
async def hospital_login(hospital_creds: schemas.HospitalLogin, db: Session = Depends(get_db)):
    hospital = db.query(models.HospitalRegister).filter(models.HospitalRegister.email == hospital_creds.email).first()
    hospital_name = db.query(models.HospitalRegister).filter(models.HospitalRegister.name == hospital_creds.name).first()

    if not hospital_name:
        raise HTTPException(status_code=status.HTTP_406_NOT_ACCEPTABLE, detail="Hospital Name is Wrong")

    if not hospital:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Hospital does not exist")

    if not utils.verify(hospital_creds.password, hospital.password):
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Invalid Password")

    access_token = oauth2.create_access_token(data={"hospital_id": hospital.id})

    return {
        "access_token": access_token,
        "hospital_id": hospital.id,
        "email":hospital.email,
        "name": hospital.name,
        "city": hospital.city,
        "phone": hospital.phone
 }