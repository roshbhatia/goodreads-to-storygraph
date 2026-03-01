# UV-based Docker image for book-sync application
# Following https://docs.astral.sh/uv/guides/integration/docker/

# Stage 1: Builder - install UV and compile dependencies
FROM python:3.11-slim AS builder

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Install dependencies only (separate layer for caching)
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-install-project --no-editable

# Copy source and sync project
COPY . /app

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-editable

# Stage 2: Runtime - minimal image with Chrome
FROM python:3.11-slim

WORKDIR /app

# Install Chromium and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    chromium-driver \
    ca-certificates \
    fonts-liberation \
    libxss1 \
    libnss3 \
    libxkbcommon0 \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -u 1000 sync-user && chown -R sync-user:sync-user /app

# Copy virtual environment from builder (non-editable, no source code)
COPY --from=builder --chown=sync-user:sync-user /app/.venv /app/.venv

# Copy only the application script (source code not needed since installed non-editable)
COPY --chown=sync-user:sync-user book_sync.py .
COPY --chown=sync-user:sync-user config.json .

# Activate virtual environment
ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1

# Switch to non-root user
USER sync-user

# Entrypoint
ENTRYPOINT ["python", "book_sync.py"]
