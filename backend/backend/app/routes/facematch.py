import cv2
import numpy as np
from fastapi import APIRouter, FastAPI, UploadFile, File, Form, status
from keras_facenet import FaceNet
from mtcnn import MTCNN
from scipy.spatial.distance import cosine
import shutil
import os

# Initialize FastAPI
router = APIRouter()

# Load FaceNet model and MTCNN detector
facenet = FaceNet()
detector = MTCNN()

def get_embedding(image_path):
    img = cv2.imread(image_path)
    img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    faces = detector.detect_faces(img_rgb)

    if len(faces) == 0:
        return None

    x, y, width, height = faces[0]['box']
    face = img_rgb[y:y+height, x:x+width]
    face = cv2.resize(face, (160, 160))

    embedding = facenet.embeddings([face])
    return embedding[0]

def compare_faces(img1, img2, threshold=0.5):
    emb1 = get_embedding(img1)
    emb2 = get_embedding(img2)

    if emb1 is None or emb2 is None:
        return {"error": "Face not detected in one or both images"}

    similarity = cosine(emb1, emb2)
    return {"similarity_score": similarity, "match": bool(similarity < threshold)}

@router.post("/compare-faces/", status_code=status.HTTP_202_ACCEPTED)
async def compare_faces_endpoint(file1: UploadFile = File(...), file2: UploadFile = File(...), threshold: float = Form(0.5)):
    temp_dir = "temp_images"
    os.makedirs(temp_dir, exist_ok=True)

    # Save uploaded files temporarily
    file1_path = os.path.join(temp_dir, file1.filename)
    file2_path = os.path.join(temp_dir, file2.filename)

    with open(file1_path, "wb") as f:
        shutil.copyfileobj(file1.file, f)
    with open(file2_path, "wb") as f:
        shutil.copyfileobj(file2.file, f)

    # Compare faces
    result = compare_faces(file1_path, file2_path, threshold)

    # Clean up temporary files
    os.remove(file1_path)
    os.remove(file2_path)

    return result
