# Multi-stage Dockerfile for book-sync application
# Stage 1: Builder - prepare dependencies with UV
FROM python:3.11-slim AS builder

WORKDIR /tmp/build

# Install UV
RUN pip install --no-cache-dir uv>=0.1.0

# Copy pyproject.toml
COPY pyproject.toml .

# Generate lockfile
RUN uv pip compile pyproject.toml -o requirements.txt

# Stage 2: Runtime - minimal production image
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies for Chromium and application
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium-browser \
    chromium-driver \
    libxss1 \
    libnss3 \
    libgconf-2-4 \
    libappindicator3-1 \
    libindicator7 \
    libxkbcommon0 \
    libxdamage1 \
    fonts-liberation \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -u 1000 sync-user && chown -R sync-user:sync-user /app

# Copy requirements from builder
COPY --from=builder /tmp/build/requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY --chown=sync-user:sync-user book_sync.py .
COPY --chown=sync-user:sync-user config.json .

# Switch to non-root user
USER sync-user

# Set environment variables for headless Chrome
ENV CHROMIUM_BIN=/usr/bin/chromium-browser
ENV CHROMEDRIVER_PATH=/usr/bin/chromedriver

# Entrypoint
ENTRYPOINT ["python", "book_sync.py"]
