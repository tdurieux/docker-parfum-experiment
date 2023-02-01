FROM python:3.8-slim

ENV PYTHONUNBUFFERED=True \
    PORT=${PORT:-9090} \
    PIP_CACHE_DIR=/.cache

WORKDIR /app
COPY requirements.txt .

RUN --mount=type=cache,target=$PIP_CACHE_DIR \
    pip3 install --no-cache-dir -r requirements.txt

COPY . ./

EXPOSE $PORT

CMD exec gunicorn --preload --bind :$PORT --workers 1 --threads 8 --timeout 0 _wsgi:app
