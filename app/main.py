from fastapi import FastAPI
import logging

from .routers import make

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("notebooklm-pipeline")

app = FastAPI(title="NotebookLM Pipeline API")


@app.on_event("startup")
async def on_startup() -> None:
    logger.info("App startup: service is initializing")


@app.get("/health")
def health() -> dict:
    return {"status": "ok"}


app.include_router(make.router)
