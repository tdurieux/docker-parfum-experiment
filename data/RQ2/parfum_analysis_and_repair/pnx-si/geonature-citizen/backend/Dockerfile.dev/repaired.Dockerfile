FROM python:3.8.10

WORKDIR /app

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir poetry

CMD poetry install; poetry run python3 wsgi.py