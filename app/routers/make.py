from typing import Optional
from fastapi import APIRouter
from pydantic import BaseModel, Field

from app import settings
from app.services.notebooklm import NotebookLMClient
from app.services.storage import StorageClient
from app.services.rss import RSSGenerator

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
        "https://storage.googleapis.com/"
        f"{settings.GCS_BUCKET_NAME}/feed.xml"
    )

    try:
        notebook = NotebookLMClient(project_id=settings.GCP_PROJECT_ID)
        storage = StorageClient(bucket_name=settings.GCS_BUCKET_NAME)
        rss = RSSGenerator(
            title=payload.title or "NotebookLM Podcast",
            link=feed_link,
            description=payload.description or "Auto-generated feed",
        )

        mp3_bytes = notebook.synthesize_podcast(
            transcript=payload.transcript,
            title=payload.title,
            description=payload.description,
            focus=payload.focus,
            length=payload.length,
            language_code=payload.languageCode,
        )
        episode_key = "episodes/episode.mp3"
        mp3_url = storage.upload_bytes(
            mp3_bytes, path=episode_key, content_type="audio/mpeg"
        )

        feed = rss.create_feed()
        feed = rss.add_item(
            feed, title=payload.title or "Episode", url=mp3_url
        )
        feed_url = storage.upload_bytes(
            feed, path="feed.xml", content_type="application/rss+xml"
        )

        return PodcastResponse(status="ok", mp3=mp3_url, rss=feed_url)
    except Exception:
        return PodcastResponse(status="error", mp3=None, rss=None)

