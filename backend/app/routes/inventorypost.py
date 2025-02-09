from typing import List
from fastapi import APIRouter, Depends, FastAPI, HTTPException, status
from pydantic import BaseModel
from requests import Session
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import sessionmaker, declarative_base
from sqlalchemy import create_engine

from app import schemas
from app import models
from app.database import get_db
# from app.models import Organ

router = APIRouter()

# Endpoint to Add Organ Entry
@router.post("/add_organ",status_code=status.HTTP_202_ACCEPTED)
async def add_organ(data: schemas.OrganAvailable,db: Session=Depends(get_db)):
    new_organ = models.Organ(
        organ_name=data.organ_name,
        blood_type=data.blood_type,
        hla_markers=data.hla_markers,
        condition=data.condition,
        hospital_id = data.hospital_id,
        latitude = data.latitude,
        longitude = data.longitude,
    )
    db.add(new_organ)
    db.commit()
    db.refresh(new_organ)
    db.close()
    return {"message": "Organ added successfully!"}

# Endpoint to Retrieve Organ List
@router.get("/organs/{hsp_id}",response_model=List[schemas.OrganAvailable],status_code=status.HTTP_200_OK)
async def get_organs(hsp_id:int ,db: Session=Depends(get_db)):
    organs = db.query(models.Organ).filter(models.Organ.hospital_id == hsp_id).all()
    db.close()
    return organs

\


















