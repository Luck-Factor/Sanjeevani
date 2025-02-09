from fastapi import APIRouter, FastAPI, HTTPException, status
from pydantic import BaseModel
import subprocess

router = APIRouter()

class ChatRequest(BaseModel):
    message: str

@router.post("/chat",status_code=status.HTTP_200_OK)
async def chat(request: ChatRequest):
    message = request.message
    if not message:
        raise HTTPException(status_code=400, detail="Message is required")

    print(f"Received message: {message}")

    try:
        ollama_process = subprocess.Popen(
            ["ollama", "run", "llama2"],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            shell=True
        )
        stdout, stderr = ollama_process.communicate(input=message + "\n")

        if ollama_process.returncode != 0:
            raise HTTPException(status_code=500, detail=f"Failed to process request: {stderr.strip()}")

        return {"response": stdout.strip()}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

