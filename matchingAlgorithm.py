import cv2
import pytesseract
import math
import re
from typing import Dict, List, Tuple

###############################
# 1. Image Processing and Data Extraction
###############################

def extract_recipient_data(image_path: str) -> Dict:
    """
    Extract recipient details from a hospital prescription image.
    """
    image = cv2.imread(image_path)
    text = pytesseract.image_to_string(image)
    
    # Extracting data using regex patterns
    blood_type = re.search(r"Blood Type:\s*([A|B|AB|O][+-])", text)
    hla_markers = re.findall(r"HLA-[A-Z0-9]+", text)
    urgency = re.search(r"Urgency:\s*(\d+)", text)
    location = re.search(r"Location:\s*\(([-\d.]+),\s*([-\d.]+)\)", text)
    
    return {
        "blood_type": blood_type.group(1) if blood_type else "O+",
        "hla_markers": hla_markers if hla_markers else [],
        "urgency": int(urgency.group(1)) if urgency else 5,
        "location": (float(location.group(1)), float(location.group(2))) if location else (0.0, 0.0)
    }

###############################
# 2. Medical Compatibility
###############################

def is_blood_compatible(recipient_bt: str, donor_bt: str) -> bool:
    recipient_group = re.sub(r"[+-]", "", recipient_bt).upper()
    donor_group = re.sub(r"[+-]", "", donor_bt).upper()
    compatibility_map = {
        'O': ['O'],
        'A': ['A', 'O'],
        'B': ['B', 'O'],
        'AB': ['A', 'B', 'AB', 'O']
    }
    return donor_group in compatibility_map.get(recipient_group, [])

def calculate_hla_similarity(recipient_hla: List[str], donor_hla: List[str]) -> float:
    recipient_set = {marker.replace("HLA-", "").strip().upper() for marker in recipient_hla}
    donor_set = {marker.replace("HLA-", "").strip().upper() for marker in donor_hla}
    intersection = recipient_set.intersection(donor_set)
    union = recipient_set.union(donor_set)
    return len(intersection) / len(union) if union else 0

CONDITION_SCORE_MAP = {
    'healthy': 1.0,
    'mild': 0.7,
    'moderate': 0.4,
    'severe': 0.0
}

def calculate_medical_score(recipient: Dict, donor: Dict) -> float:
    if not is_blood_compatible(recipient["blood_type"], donor["blood_type"]):
        return 0
    
    blood_score = 100
    hla_similarity = calculate_hla_similarity(recipient["hla_markers"], donor["hla_markers"])
    hla_score = hla_similarity * 100
    donor_condition = donor.get("condition", "").lower()
    condition_score = CONDITION_SCORE_MAP.get(donor_condition, 0.0) * 100

    weights = {"blood": 0.3, "hla": 0.5, "condition": 0.2}
    medical_score = (weights["blood"] * blood_score +
                     weights["hla"] * hla_score +
                     weights["condition"] * condition_score)
    return medical_score

###############################
# 3. Location Matching
###############################

def haversine_distance(coord1: Tuple[float, float], coord2: Tuple[float, float]) -> float:
    lat1, lon1 = coord1
    lat2, lon2 = coord2
    R = 6371  # Earth radius in km

    phi1, phi2 = map(math.radians, [lat1, lat2])
    delta_phi = math.radians(lat2 - lat1)
    delta_lambda = math.radians(lon2 - lon1)

    a = math.sin(delta_phi / 2) ** 2 + math.cos(phi1) * math.cos(phi2) * math.sin(delta_lambda / 2) ** 2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    return R * c

def calculate_location_score(recipient_loc: Tuple[float, float], donor_loc: Tuple[float, float], max_distance: float = 100.0) -> float:
    distance = haversine_distance(recipient_loc, donor_loc)
    score = max(0, (1 - (distance / max_distance)) * 100)
    return score

###############################
# 4. Overall Match Score
###############################

def calculate_match_score(recipient: Dict, donor: Dict) -> float:
    medical_score = calculate_medical_score(recipient, donor)
    location_score = calculate_location_score(recipient["location"], donor["location"], max_distance=100)
    
    if medical_score == 0:
        return 0.0
    
    weights = {"medical": 0.7, "location": 0.3}
    base_score = weights["medical"] * medical_score + weights["location"] * location_score
    
    urgency_factor = recipient.get("urgency", 1) / 10.0
    total_score = base_score * urgency_factor
    return round(total_score, 2)

###############################
# 5. Ranking and Dynamic Matching
###############################

def rank_donors(recipient: Dict, donors: List[Dict]) -> List[Dict]:
    ranked = []
    for donor in donors:
        score = calculate_match_score(recipient, donor)
        if score > 0:
            ranked.append({
                "donor_id": donor["id"],
                "match_score": score,
                "details": donor
            })
    ranked.sort(key=lambda x: x["match_score"], reverse=True)
    return ranked

###############################
# 6. Main Execution
###############################

if __name__ == "__main__":
    # Extract recipient data from the image
    image_path = "recipient_details.png"
    recipient_data = extract_recipient_data(image_path)
    
    # Sample donors data
    donors = [
        {"id": 123, "blood_type": "O", "hla_markers": ["A1", "B2", "DR3"], "condition": "healthy", "location": (28.7045, 77.1020)},
        {"id": 456, "blood_type": "O", "hla_markers": ["A1", "B2", "DR4"], "condition": "healthy", "location": (28.5355, 77.3910)},
        {"id": 789, "blood_type": "B", "hla_markers": ["A1", "B2", "DR3"], "condition": "mild", "location": (28.7045, 77.1020)}
    ]
    
    ranked_donors = rank_donors(recipient_data, donors)
    
    print("Ranked Donors (Match Score):")
    for donor in ranked_donors:
        print(f"Donor ID: {donor['donor_id']}, Match Score: {donor['match_score']}%, Details: {donor['details']}")
    
    # Display the top-ranked donor
    if ranked_donors:
        top_donor = ranked_donors[0]
        print(f"\nTop Ranked Donor: Donor ID: {top_donor['donor_id']}, Match Score: {top_donor['match_score']}%")
