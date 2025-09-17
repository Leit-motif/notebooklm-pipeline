import os
from typing import Optional

import requests
from google.auth.transport.requests import Request
from google.auth import default as google_auth_default


class NotebookLMClient:
    def __init__(self, project_id: str) -> None:
        self.project_id = project_id
        self._simulate = os.getenv("NOTEBOOKLM_SIMULATE", "").lower() in {
            "1",
            "true",
            "yes",
        }
        self._endpoint = (
            "https://discoveryengine.googleapis.com/v1/projects/"
            f"{project_id}/locations/global/podcasts"
        )

    def _get_bearer_token(self) -> str:
        # Prefer Application Default Credentials
        credentials, _ = google_auth_default(
            scopes=["https://www.googleapis.com/auth/cloud-platform"]
        )
        if credentials and credentials.requires_scopes:
            credentials = credentials.with_scopes(
                ["https://www.googleapis.com/auth/cloud-platform"]
            )
        credentials.refresh(Request())
        return credentials.token

    def synthesize_podcast(
        self,
        transcript: str,
        title: Optional[str] = None,
        description: Optional[str] = None,
        focus: Optional[str] = None,
        length: Optional[str] = None,
        language_code: Optional[str] = None,
        timeout_seconds: int = 90,
    ) -> bytes:
        if self._simulate:
            # Minimal MP3 header bytes; placeholder for pipeline testing only
            return b"ID3\x03\x00\x00\x00\x00\x00\x0AFAKE-MP3-CONTENT"

        payload = {
            "transcript": transcript,
            "title": title,
            "description": description,
            "focus": focus,
            "length": length or "STANDARD",
            "languageCode": language_code or "en-US",
        }
        headers = {
            "Authorization": (
                f"Bearer {self._get_bearer_token()}"
            ),
            "Content-Type": "application/json",
        }
        resp = requests.post(
            url=self._endpoint,
            json=payload,
            headers=headers,
            timeout=timeout_seconds,
        )
        resp.raise_for_status()
        return resp.content
