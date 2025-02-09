from fastapi import FastAPI , Response , status , HTTPException , Depends , APIRouter
from sqlalchemy.orm import Session
from app import models, schemas, utils
from app.database import get_db

router = APIRouter()

@router.post("/hospital_register", status_code=status.HTTP_201_CREATED, response_model=schemas.HospitalResponse)
async def create_user(user: schemas.HospitalCreate, db: Session = Depends(get_db)):
    existing_hospital = db.query(models.HospitalRegister).filter(models.HospitalRegister.email == user.email).first()
    
    if existing_hospital:
        raise HTTPException(status_code=400, detail="Email is already registered")
    
    hashed_password = utils.hash(user.password)
    user.password = hashed_password
    new_user = models.HospitalRegister(
        name=user.name,
        city=user.city,
        phone=user.phone,
        email=user.email,
        password=user.password,
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user


import yagmail

def send_email_notification(hospital_email: str, request: schemas.RequestPost):
    """Send an email notification to the hospital."""
    yag = yagmail.SMTP("pratapnitin87@gmail.com", "kyqs filp fwxu ooac")

    subject = "🚨 Urgent Medical Request - Immediate Attention Needed!"
    body = f"""
    Dear Hospital,

    A critical case has been reported. Please see the details below:

    - Patient Name: {request.name}
    - Age: {request.age}
    - Request Type: {request.reqtype}
    - Urgency: {request.urgency}
    - Location: {request.location}
    - Content: {request.content}

    Kindly respond as soon as possible.

    Regards,
    Your Healthcare System
    """

    yag.send(to=hospital_email, subject=subject, contents=body)
    print(f"Email sent to {hospital_email} successfully.")
