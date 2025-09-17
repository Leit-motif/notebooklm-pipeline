import os
from dotenv import load_dotenv

load_dotenv()

GCP_PROJECT_ID = os.getenv("GCP_PROJECT_ID", "")
GCS_BUCKET_NAME = os.getenv("GCS_BUCKET_NAME", "")
GCP_REGION = os.getenv("GCP_REGION", "us-central1")
GOOGLE_APPLICATION_CREDENTIALS = os.getenv(
    "GOOGLE_APPLICATION_CREDENTIALS", ""
)
