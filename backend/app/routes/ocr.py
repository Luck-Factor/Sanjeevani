from fastapi import APIRouter, FastAPI, File, UploadFile, HTTPException, Depends
from sqlalchemy import create_engine, Column, Integer, String, Float, Table, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship, Session
import cv2
from app import models
from app.database import Base, get_db
import pytesseract
import re
import math
import shutil
from typing import Dict, List, Tuple


class Recipient(Base):
    __tablename__ = "recipients"
    id = Column(Integer, primary_key=True, index=True)
    blood_type = Column(String, index=True)
    hla_markers = Column(String)
    urgency = Column(Integer)
    latitude = Column(Float)
    longitude = Column(Float)



router = APIRouter()

def extract_recipient_data(image_path: str) -> Dict:
    image = cv2.imread(image_path)
    text = pytesseract.image_to_string(image)
    blood_type = re.search(r"Blood Type:\s*([A|B|AB|O][+-])", text)
    hla_markers = re.findall(r"HLA-[A-Z0-9]+", text)
    urgency = re.search(r"Urgency:\s*(\d+)", text)
    location = re.search(r"Location:\s*\(([-\d.]+),\s*([-\d.]+)\)", text)
    
    return {
        "blood_type": blood_type.group(1) if blood_type else "O+",
        "hla_markers": ",".join(hla_markers) if hla_markers else "",
        "urgency": int(urgency.group(1)) if urgency else 5,
        "latitude": float(location.group(1)) if location else 0.0,
        "longitude": float(location.group(2)) if location else 0.0
    }

@router.post("/upload/")
def upload_image(image: UploadFile = File(...), db: Session = Depends(get_db)):
    file_path = f"temp_{image.filename}"
    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(image.file, buffer)
    
    recipient_data = extract_recipient_data(file_path)
    new_recipient = Recipient(**recipient_data)
    db.add(new_recipient)
    db.commit()
    
    return {"message": "Data extracted successfully", "recipient": recipient_data}

@router.get("/search_donors/{recipient_id}")
def search_donors(recipient_id: int, db: Session = Depends(get_db)):
    recipient = db.query(Recipient).filter(Recipient.id == recipient_id).first()
    if not recipient:
        raise HTTPException(status_code=404, detail="Recipient not found")
    
    donors = db.query(models.Organ).all()
    matched_donors = []
    
    for donor in donors:
        if donor.blood_type != recipient.blood_type:
            continue
        hla_match = len(set(donor.hla_markers.split(",")) & set(recipient.hla_markers.split(","))) / len(set(recipient.hla_markers.split(",")))
        distance = math.sqrt((recipient.latitude - donor.latitude)**2 + (recipient.longitude - donor.longitude)**2)
        score = (hla_match * 70) + ((100 - min(distance, 100)) * 0.3)
        # matched_donors.append({"donor_id": donor.id, "match_score": score})
        matched_donors.append({"donor_id": donor.id, "match_score": score, "hospital_id": donor.hospital_id})

    
    matched_donors.sort(key=lambda x: x["match_score"], reverse=True)

    hospital_ids = list(set(donor["hospital_id"] for donor in matched_donors))
    hospitals = db.query(models.HospitalRegister).filter(models.HospitalRegister.id.in_(hospital_ids)).all()

    hospital_response = [
        {
            "hospital_id": hospital.id,
            "name": hospital.name,
            "city": hospital.city,
            "phone": hospital.phone,
            "email": hospital.email
        } for hospital in hospitals
    ]

    return {"matched_hospitals": hospital_response}

