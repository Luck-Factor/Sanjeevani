from datetime import datetime
from numpy import double
from sqlalchemy import Boolean, Column, Date, DateTime, Float, ForeignKey, Integer, LargeBinary, String, Text, func, text, BigInteger
from sqlalchemy.sql.expression import null

from app.routes import user
from .database import Base 
from sqlalchemy.orm import relationship



class User(Base) :
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    age = Column(String, nullable=False)
    city = Column(String, nullable=False)
    phone = Column(String, nullable=False, unique=True)
    email = Column(String, nullable=False, unique=True)
    password = Column(String, nullable=False)
    gender = Column(String, nullable=False)


class HospitalRegister(Base) :
    __tablename__ = "hospitalsregisters"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    city = Column(String, nullable=False)
    phone = Column(String, nullable=False, unique=True)
    email = Column(String, nullable=False, unique=True)
    password = Column(String, nullable=False)
    

class RequestPost(Base) :
    __tablename__ = "requestpost"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    reqtype = Column(String, nullable=False)
    age = Column(String, nullable=False)
    gender = Column(String, nullable=False)
    urgency = Column(String)
    location = Column(String)
    content = Column(String)
    user_id = Column(Integer, ForeignKey(User.id))


class DonatePost(Base) :
    __tablename__ = "donatepost"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    dontype = Column(String, nullable=False)
    age = Column(String, nullable=False)
    gender = Column(String, nullable=False)
    availability = Column(String)
    location = Column(String)
    content = Column(String)
    user_id = Column(Integer, ForeignKey(User.id))


class Organ(Base):
    __tablename__ = "organs"
    
    id = Column(Integer, primary_key=True, index=True)
    organ_name = Column(String, nullable=False)
    blood_type = Column(String, nullable=False)
    hla_markers = Column(String, nullable=False)
    condition = Column(String, nullable=False)
    latitude = Column(Float)
    longitude = Column(Float)
    hospital_id = Column(Integer, ForeignKey(HospitalRegister.id))
    

    





    
