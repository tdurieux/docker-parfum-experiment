# https://github.com/tiangolo/uvicorn-gunicorn-fastapi-docker
FROM tiangolo/uvicorn-gunicorn:latest

COPY ./ /app
WORKDIR /app/
ENV PYTHONPATH=/app

RUN pip install --no-cache-dir -r requirements.txt