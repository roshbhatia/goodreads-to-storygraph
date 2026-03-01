# Goodreads to StoryGraph Sync Setup Guide

Caveat:  This is a complete hack that I made using Claude.ai to write the Python code for me.  I hope it works for you, but I can't guarantee success.

## Quick Start (Docker - Recommended)

The easiest way to run this tool is via Docker:

```bash
docker run -e GOODREADS_USER_ID=<your-id> \
  -e STORYGRAPH_EMAIL=<your-email> \
  -e STORYGRAPH_PASSWORD=<your-password> \
  ghcr.io/roshbhatia/goodreads-to-storygraph:latest
```

Or with a config file:

```bash
docker run -v ./config.json:/app/config.json \
  ghcr.io/roshbhatia/goodreads-to-storygraph:latest
```

## Prerequisites

### Docker (Recommended)
- Docker installed and running
- No Python, Chrome, or other dependencies needed - everything is containerized

### Python (Legacy - Still Supported)
- Python 3.9 or higher
- Google Chrome browser installed
- Basic familiarity with running Python scripts

## Installation Steps (Docker)

Simply pull and run the latest image:

```bash
docker pull ghcr.io/roshbhatia/goodreads-to-storygraph:latest
```

## Installation Steps (Python - Legacy)

1. Clone the repository:
```bash
git clone https://github.com/roshbhatia/goodreads-to-storygraph.git
cd goodreads-to-storygraph
```

2. Install required Python packages using UV (recommended) or pip:

**Using UV (faster, recommended):**
```bash
uv pip install -r requirements.txt
```

**Using pip (legacy):**
```bash
pip install -r requirements.txt
```

## File Structure

Copy the files into the directory (clone the repo):
```
goodreads-sync/
│
├── book_sync.py    # The main Python script
├── config.json      # Configuration file with your credentials
└── sync_log.txt    # Will be created automatically when the script runs
```

## Configuration

1. Edit `config.json` with the your information:
```json
{
    "goodreads_user_id": "YOUR_GOODREADS_USER_ID",
    "storygraph_email": "YOUR_STORYGRAPH_EMAIL",
    "storygraph_password": "YOUR_STORYGRAPH_PASSWORD"
}
```

### Finding Your Goodreads User ID
1. Go to your Goodreads profile
2. Look at the URL - it will be something like: `https://www.goodreads.com/user/show/12345678-username`
3. The number (e.g., `12345678`) is your user ID

## Configuration

### Using Docker with Environment Variables

```bash
docker run \
  -e GOODREADS_USER_ID=12345678 \
  -e STORYGRAPH_EMAIL=your@email.com \
  -e STORYGRAPH_PASSWORD=your-password \
  ghcr.io/roshbhatia/goodreads-to-storygraph:latest
```

### Using Docker with Config File

Create a `config.json` file:
```json
{
    "goodreads_user_id": "YOUR_GOODREADS_USER_ID",
    "storygraph_email": "YOUR_STORYGRAPH_EMAIL",
    "storygraph_password": "YOUR_STORYGRAPH_PASSWORD"
}
```

Then run:
```bash
docker run -v ./config.json:/app/config.json \
  ghcr.io/roshbhatia/goodreads-to-storygraph:latest
```

### Using Python (Legacy)

Edit `config.json` with your credentials:
```json
{
    "goodreads_user_id": "YOUR_GOODREADS_USER_ID",
    "storygraph_email": "YOUR_STORYGRAPH_EMAIL",
    "storygraph_password": "YOUR_STORYGRAPH_PASSWORD"
}
```

## Running the Script

### Docker

```bash
docker run \
  -e GOODREADS_USER_ID=<your-id> \
  -e STORYGRAPH_EMAIL=<your-email> \
  -e STORYGRAPH_PASSWORD=<your-password> \
  ghcr.io/roshbhatia/goodreads-to-storygraph:latest
```

### Python (Legacy)

1. Make sure you're in the project directory:
```bash
cd goodreads-to-storygraph
```

2. Run the script:
```bash
python book_sync.py
```

## What to Expect

- The script will create a log file (`sync_log.txt`) that tracks all operations
- Chrome will open automatically and handle the sync process
- The script will:
  1. Fetch your recently read books from Goodreads
  2. Log into your StoryGraph account
  3. Add each book to your StoryGraph reading journal with the correct completion date

## Troubleshooting

### Docker Issues

**Image pull fails:**
- Ensure the repository is public on GHCR
- Check internet connection
- Try `docker pull ghcr.io/roshbhatia/goodreads-to-storygraph:latest` directly

**Container exits immediately:**
- Check logs: `docker logs <container-id>`
- Verify environment variables are set correctly
- Ensure `config.json` exists if using file-based config

**Permission denied errors:**
- Container runs as non-root user (sync-user)
- Ensure mounted volumes have proper read/write permissions

**View logs from Docker:**
```bash
docker run -e GOODREADS_USER_ID=123 \
  -e STORYGRAPH_EMAIL=user@example.com \
  -e STORYGRAPH_PASSWORD=secret \
  ghcr.io/roshbhatia/goodreads-to-storygraph:latest
# Logs will appear directly in terminal
```

### Python (Legacy)

If you encounter errors:
1. Check `sync_log.txt` for detailed error messages
2. Verify your Goodreads ID and StoryGraph credentials in `config.json`
3. Ensure all required Python packages are installed (`pip list`)
4. Make sure Chrome is up to date
5. Look for screenshot files (e.g., `login_error.png` or `book_error_*.png`) that may have been created during errors
6. Update packages: `pip install --upgrade -r requirements.txt`

## Best Practices

1. Keep your `config.json` secure and never share it
2. Run the script periodically (e.g., weekly) to keep your StoryGraph journal up to date
3. Monitor the log file for any issues
4. Update Python packages periodically to ensure compatibility

## Safety Notes

- The script stores your StoryGraph password in plain text in `config.json`
- Keep the config file secure and don't share it

## Support

If you encounter issues:
1. Check the log file for error messages
2. Verify your credentials
3. Ensure all prerequisites are installed
4. Try running the script again after a few minutes
