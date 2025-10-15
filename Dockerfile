# syntax=docker/dockerfile:1
FROM python:3.12-slim

# System deps: OpenSCAD + headless X + xauth + GL + fonts
RUN apt-get update && apt-get install -y --no-install-recommends \
    openscad \
    xvfb xauth \
    mesa-utils libgl1-mesa-dri libgl1 \
    fonts-dejavu-core \
    ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip toolchain
RUN pip install --upgrade pip setuptools wheel

WORKDIR /app

# Install Python deps
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY backend /app/backend

# Output dir for STL files
RUN mkdir -p /app/output

ENV PYTHONUNBUFFERED=1
ENV PORT=8000

# Start FastAPI normally (no xvfb here)
# Render injects $PORT; use shell form to expand it.
CMD ["bash", "-lc", "uvicorn backend.app:app --host 0.0.0.0 --port ${PORT}"]
