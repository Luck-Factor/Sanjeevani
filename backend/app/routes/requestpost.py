from typing import List
from fastapi import FastAPI, File, Query , Response, UploadFile , status , HTTPException , Depends , APIRouter
from sqlalchemy.orm import Session
from app import models, schemas, utils
from app.database import get_db
from app.routes.hospitalsregisters import send_email_notification
from fastapi import BackgroundTasks

router = APIRouter()


@router.post("/upload_request", status_code=status.HTTP_201_CREATED)
async def upload_request_post(
    background_tasks: BackgroundTasks,  # Move BackgroundTasks to the beginning
    request: schemas.RequestPost, 
    db: Session = Depends(get_db)
):
    new_post = models.RequestPost(
        name=request.name,
        reqtype=request.reqtype,
        age=request.age,
        gender=request.gender,
        urgency=request.urgency,
        location=request.location,
        content=request.content,
        user_id=request.user_id,
    )

    db.add(new_post)
    db.commit()
    db.refresh(new_post)

    # Send emails in the background
    if request.urgency.lower() == "critical":
        hospitals = db.query(models.HospitalRegister).all()
        for hospital in hospitals:
            background_tasks.add_task(send_email_notification, hospital.email, request)

    return {
        'name': request.name, 
        'reqtype': request.reqtype, 
        'age': request.age, 
        'gender': request.gender, 
        'urgency': request.urgency, 
        'location': request.location, 
        'content': request.content, 
        'user_id': request.user_id
}

@router.get("/get_all_requests", response_model=List[schemas.RequestPost])
def get_all_requests(db: Session = Depends(get_db), skip: int = Query(0, ge=0), limit: int = Query(10, le=100)):
    posts = db.query(models.RequestPost).offset(skip).limit(limit).all()
    return posts


@router.get("/get_all_requests/{pr_id}", response_model=List[schemas.RequestPost])
def get_all_requests(pr_id:int,db: Session = Depends(get_db), skip: int = Query(0, ge=0), limit: int = Query(10, le=100)):
    posts = db.query(models.RequestPost).filter(models.RequestPost.user_id==pr_id).all() 
    return posts

