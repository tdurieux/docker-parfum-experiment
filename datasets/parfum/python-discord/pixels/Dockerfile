FROM --platform=linux/amd64 python:3.9-slim

# Set pip to have no saved cache
ENV PIP_NO_CACHE_DIR=false \
    POETRY_VIRTUALENVS_CREATE=false \
    MAX_WORKERS=10

# Install poetry
RUN pip install -U poetry

# Create the working directory
WORKDIR /pixels

# Install project dependencies
COPY pyproject.toml poetry.lock ./
RUN poetry install --no-dev

# Copy in the Gunicorn config
COPY ./gunicorn_conf.py /gunicorn_conf.py

# Define Git SHA build argument
ARG git_sha="development"

# Set Git SHA environment variable for Sentry
ENV GIT_SHA=$git_sha

# Copy the source code in last to optimize rebuilding the image
COPY . .

EXPOSE 80

# Run the start script, it will check for an /app/prestart.sh script (e.g. for migrations),
# and then it will start Gunicorn with Uvicorn workers.
CMD ["gunicorn", "-k", "uvicorn.workers.UvicornWorker", "-c", "/gunicorn_conf.py", "pixels:app"]
