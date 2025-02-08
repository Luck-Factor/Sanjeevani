from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Dict, Tuple
import numpy as np
import json
import logging
from enum import Enum

# -----------------------------
# Configuration
# -----------------------------
class UrgencyConfig:
    def __init__(self, config_file: str = None):
        self.default_config = {
            "rule_based_weights": {
                "life_threatening": 5,
                "icu": 3,
                "instability": 1,
                "complications": 2
            },
            "thresholds": {
                "critical": 15,
                "high": 10,
                "medium": 6,
                "low": 0
            },
            "log_level": "INFO"
        }
        
        if config_file:
            self.load_config(config_file)
        else:
            self.config = self.default_config

    def load_config(self, file_path: str):
        try:
            with open(file_path, 'r') as f:
                self.config = json.load(f)
        except Exception as e:
            logging.warning(f"Failed to load config: {e}, using defaults")
            self.config = self.default_config

# -----------------------------
# Algorithms Enum
# -----------------------------
class UrgencyAlgorithm(Enum):
    RULE_BASED = 1
    TOPSIS = 2

# -----------------------------
# Urgency Classifier
# -----------------------------
class UrgencyClassifier:
    def __init__(self, config: UrgencyConfig = None):
        self.config = config or UrgencyConfig()
        self._setup_logging()
        
    def _setup_logging(self):
        logging.basicConfig(
            level=self.config.config.get("log_level", "INFO"),
            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
        self.logger = logging.getLogger(__name__)
        
    def calculate_overall_urgency(
        self, is_life_threatening: bool, in_icu: bool, instability_score: int, complications: int
    ) -> Tuple[str, float]:
        self._validate_inputs(instability_score, complications)
        features = {
            'life_threatening': is_life_threatening,
            'icu': in_icu,
            'instability': instability_score,
            'complications': complications
        }
        
        _, score_rule = self._rule_based(features)
        _, score_topsis = self._topsis(features)
        
        overall_score = (score_rule + score_topsis) / 2.0
        overall_urgency = self._score_to_urgency(overall_score)
        
        return overall_urgency, overall_score

    def _rule_based(self, features: Dict) -> Tuple[str, float]:
        weights = self.config.config["rule_based_weights"]
        score = (
            weights["life_threatening"] * (1 if features["life_threatening"] else 0) +
            weights["icu"] * (1 if features["icu"] else 0) +
            weights["instability"] * features["instability"] +
            weights["complications"] * features["complications"]
        )
        return self._score_to_urgency(score), score

    def _topsis(self, features: Dict) -> Tuple[str, float]:
        weights = np.array(list(self.config.config["rule_based_weights"].values()))
        weights = weights / np.sum(weights)
        decision_vector = np.array([
            1 if features["life_threatening"] else 0,
            1 if features["icu"] else 0,
            features["instability"],
            features["complications"]
        ])
        weighted_score = np.dot(decision_vector, weights)
        scaled_score = weighted_score * 20  
        return self._score_to_urgency(scaled_score), scaled_score

    def _score_to_urgency(self, score: float) -> str:
        thresholds = self.config.config["thresholds"]
        if score >= thresholds["critical"]:
            return "critical"
        if score >= thresholds["high"]:
            return "high"
        if score >= thresholds["medium"]:
            return "medium"
        return "low"

    def _validate_inputs(self, instability: int, complications: int):
        if not (0 <= instability <= 10):
            raise ValueError("Instability score must be between 0 and 10")
        if complications < 0:
            raise ValueError("Complications count cannot be negative")

# -----------------------------
# FastAPI Setup
# -----------------------------
app = FastAPI(title="Urgency Classifier API")

# Initialize the classifier
classifier = UrgencyClassifier()

# -----------------------------
# Request and Response Models
# -----------------------------
class UrgencyRequest(BaseModel):
    is_life_threatening: bool
    in_icu: bool
    instability_score: int
    complications: int

class UrgencyResponse(BaseModel):
    overall_urgency: str
    overall_score: float

# -----------------------------
# API Endpoints
# -----------------------------
@app.post("/classify", response_model=UrgencyResponse)
def classify_urgency(request: UrgencyRequest):
    try:
        overall_urgency, overall_score = classifier.calculate_overall_urgency(
            is_life_threatening=request.is_life_threatening,
            in_icu=request.in_icu,
            instability_score=request.instability_score,
            complications=request.complications
        )
        return UrgencyResponse(overall_urgency=overall_urgency, overall_score=overall_score)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
 