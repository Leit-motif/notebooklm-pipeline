from fastapi import FastAPI

from .routers import make

app = FastAPI(title="NotebookLM Pipeline API")


@app.get("/health")
def health() -> dict:
    return {"status": "ok"}


app.include_router(make.router)
