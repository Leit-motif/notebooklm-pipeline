from fastapi import FastAPI

app = FastAPI(title="NotebookLM Pipeline API")


@app.get("/health")
def health() -> dict:
    return {"status": "ok"}
