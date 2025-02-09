from typing import List
from fastapi import FastAPI, File, Query , Response, UploadFile , status , HTTPException , Depends , APIRouter
from sqlalchemy.orm import Session
from app import models, schemas, utils
from app.database import get_db

router = APIRouter()

@router.post("/upload_donate",status_code=status.HTTP_201_CREATED)
async def upload_request_post(name: str, dontype: str, age: str, gender: str, availability: str, location: str, content: str, user_id: str, db: Session = Depends(get_db)):
    

    new_post = models.DonatePost(
        name=name,
        dontype=dontype,
        age=age,
        gender=gender,
        availability=availability,
        location=location,
        content=content,
        user_id=user_id,
    )
    db.add(new_post)
    db.commit()
    db.refresh(new_post)

    return {'name':name, 'dontype':dontype, 'age':age, 'gender':gender, 'availability':availability, 'location':location, 'content':content, 'user_id':user_id}


@router.get("/get_all_donates", response_model=List[schemas.DonatePost])
def get_all_requests(db: Session = Depends(get_db), skip: int = Query(0, ge=0), limit: int = Query(10, le=100)):
    posts = db.query(models.DonatePost).offset(skip).limit(limit).all()


    return posts