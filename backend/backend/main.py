from io import BytesIO
from fastapi import Depends, FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from app.models import Base, User 
from app.database import engine, get_db
from app.routes import chatbot, donatepost, facematch, hospitalsregisters, inventorypost, login, ocr, requestpost, user
from sqlalchemy.orm import Session



app = FastAPI()
import sqlalchemy
print(sqlalchemy.__version__)  


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],  
 )

Base.metadata.create_all(bind=engine) 

app.include_router(user.router)
app.include_router(login.router)
app.include_router(requestpost.router)
app.include_router(donatepost.router)
app.include_router(hospitalsregisters.router)
app.include_router(facematch.router)
app.include_router(chatbot.router)
app.include_router(ocr.router)
app.include_router(inventorypost.router)



@app.get("/")
async def test() :
    return {"Working" : "Fine"} 



    
  