FROM python:3.7

RUN pip install --no-cache-dir -q -U Flask blinker gunicorn

RUN mkdir -p /app
COPY app.py /app

WORKDIR /app
