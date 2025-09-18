from typing import Optional
import logging
from fastapi import APIRouter
from pydantic import BaseModel, Field

from app import settings

logger = logging.getLogger("notebooklm-pipeline")
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

    logger.info(
        "Received /make request",
        extra={
            "title": payload.title,
            "len_transcript": len(payload.transcript),
            "bucket": settings.GCS_BUCKET_NAME,
            "project": settings.GCP_PROJECT_ID,
        },
    )

    try:
        # Lazy-import to prevent startup failures if optional libs are missing
        from app.services.notebooklm import NotebookLMClient  # noqa: WPS433
        from app.services.storage import StorageClient  # noqa: WPS433
        from app.services.rss import RSSGenerator  # noqa: WPS433

        notebook = NotebookLMClient(project_id=settings.GCP_PROJECT_ID)
        storage = StorageClient(bucket_name=settings.GCS_BUCKET_NAME)
        rss = RSSGenerator(
            title=payload.title or "NotebookLM Podcast",
            link=feed_link,
            description=payload.description or "Auto-generated feed",
        )

        logger.info("Calling NotebookLM synthesize_podcast")
        mp3_bytes = notebook.synthesize_podcast(
            transcript=payload.transcript,
            title=payload.title,
            description=payload.description,
            focus=payload.focus,
            length=payload.length,
            language_code=payload.languageCode,
        )

        episode_key = "episodes/episode.mp3"
        logger.info("Uploading MP3 to GCS", extra={"key": episode_key})
        mp3_url = storage.upload_bytes(
            mp3_bytes, path=episode_key, content_type="audio/mpeg"
        )

        logger.info("Generating RSS feed and adding item")
        feed = rss.create_feed()
        feed = rss.add_item(
            feed, title=payload.title or "Episode", url=mp3_url
        )

        logger.info("Uploading feed.xml to GCS")
        feed_url = storage.upload_bytes(
            feed, path="feed.xml", content_type="application/rss+xml"
        )

        logger.info("/make completed successfully")
        return PodcastResponse(status="ok", mp3=mp3_url, rss=feed_url)
    except Exception as exc:  # pragma: no cover
        logger.exception("/make failed", exc_info=exc)
        return PodcastResponse(status="error", mp3=None, rss=None)

