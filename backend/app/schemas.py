import base64
import datetime
from typing import List, Optional
from fastapi import File
from numpy import double
from pydantic import BaseModel, EmailStr
from pydantic import conint
from sqlalchemy import Integer, LargeBinary


class UserResponse(BaseModel) :
    id : int
    name : str
    age : str
    city : str
    phone : str
    email : EmailStr 
    password : str
    gender : str

    class Config :
        from_attributes = True


class UserCreate(BaseModel) :
    name : str
    age : str
    city : str
    phone : str
    email : EmailStr 
    password : str
    gender : str


class HospitalResponse(BaseModel) :
    id : int
    name : str
    city : str
    phone : str
    email : EmailStr 
    password : str

    class Config :
        from_attributes = True


class HospitalCreate(BaseModel) :
    name : str
    city : str
    phone : str
    email : EmailStr 
    password : str


class RequestPost(BaseModel) :
    name: str
    age: str
    gender: str
    location: str
    reqtype: str
    urgency: str
    content: str
    user_id: int

    class Config:
        orm_mode = True 
        from_attributes = True 


class DonatePost(BaseModel) :
    name: str
    age: str
    gender: str
    location: str
    dontype: str
    availability: str
    content: str
    user_id: int

    class Config:
        orm_mode = True 
        from_attributes = True 

    
class UserLogin(BaseModel) :
    name : str
    email : EmailStr
    password : str


class Token(BaseModel) :
    access_token : str
    token_type : str


class TokenData(BaseModel) :
    id : Optional[str] = None



class OrganAvailable(BaseModel):
    organ_name: str
    blood_type: str
    hla_markers: str
    condition: str
    hospital_id: int
    latitude: float
    longitude: float


class HospitalLogin(BaseModel):
    name: str
    email: EmailStr
    password: str

class HospitalResponse(BaseModel):
    id: int
    name: str
    email: EmailStr
    city: str
    phone: str

    class Config:
        orm_mode = True