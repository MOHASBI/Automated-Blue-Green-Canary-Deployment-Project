from pathlib import Path
import hashlib
import time

from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import FileResponse, RedirectResponse
from fastapi.staticfiles import StaticFiles

from .ddb import get_mapping, put_mapping

app = FastAPI(title="URL Shortener API")

BASE_DIR = Path(__file__).resolve().parent
FRONTEND_INDEX = BASE_DIR / "static" / "index.html"

app.mount("/static", StaticFiles(directory=BASE_DIR / "static"), name="static")


@app.get("/healthz")
def health():
    return {"status": "ok", "ts": int(time.time())}


@app.post("/shorten")
async def shorten(req: Request):
    body = await req.json()
    url = body.get("url")
    if not url:
        raise HTTPException(status_code=400, detail="url required")
    short = hashlib.sha256(url.encode()).hexdigest()[:8]
    put_mapping(short, url)
    return {"short": short, "url": url}


@app.get("/", include_in_schema=False)
async def index():
    if not FRONTEND_INDEX.is_file():
        raise HTTPException(status_code=500, detail="frontend not found")
    return FileResponse(FRONTEND_INDEX)


@app.get("/{short_id}", include_in_schema=False)
def resolve(short_id: str):
    item = get_mapping(short_id)
    if not item:
        raise HTTPException(status_code=404, detail="not found")
    return RedirectResponse(item["url"])
