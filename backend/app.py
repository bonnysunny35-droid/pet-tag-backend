from fastapi import FastAPI, UploadFile, Form
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse, JSONResponse
from pathlib import Path
from backend.cad.generate_tag import render_stl

app = FastAPI()

# Allow your website to call this API (for MVP, allow all; later restrict to your domain)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

OUTPUT = Path("./output")
OUTPUT.mkdir(parents=True, exist_ok=True)

@app.get("/health")
def health():
    return {"ok": True}

@app.post("/generate")
async def generate_tag(
    name: str = Form(...),
    shape: str = Form("circle"),
    photo: UploadFile | None = None,  # reserved for later AI use
):
    out_path = OUTPUT / f"{name}_{shape}.stl"
    render_stl(out_path=str(out_path), name_text=name.upper(), tag_shape=shape)
    return JSONResponse({"stl_path": str(out_path.resolve())})

@app.get("/download")
def download(file: str):
    p = Path(file)
    if p.exists() and p.suffix.lower() == ".stl":
        return FileResponse(str(p), media_type="model/stl", filename=p.name)
    return JSONResponse({"error": "file not found"}, status_code=404)
