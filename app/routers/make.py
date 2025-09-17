from typing import Optional
from fastapi import APIRouter
from pydantic import BaseModel, Field

from app import settings

router = APIRouter()


class PodcastRequest(BaseModel):
    transcript: str = Field(..., min_length=1)
    title: Optional[str] = None
    description: Optional[str] = None
    focus: Optional[str] = None
    length: Optional[str] = Field(default="STANDARD")
    languageCode: Optional[str] = Field(default="en-US")


class PodcastResponse(BaseModel):
    status: str
    mp3: Optional[str] = None
    rss: Optional[str] = None


@router.post("/make", response_model=PodcastResponse)
async def make_podcast(payload: PodcastRequest) -> PodcastResponse:
    feed_link = (
        f"https://storage.googleapis.com/"
        f"{settings.GCS_BUCKET_NAME}/feed.xml"
    )

    try:
        # Placeholders until integration is implemented
        mp3_url = None
        feed_url = None
        _ = feed_link  # keep reference for future use
        return PodcastResponse(status="ok", mp3=mp3_url, rss=feed_url)
    except Exception:
        return PodcastResponse(status="error", mp3=None, rss=None)

