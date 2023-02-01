FROM tiangolo/uvicorn-gunicorn-fastapi:python3.7

RUN pip install --no-cache-dir requests

ENV HOST=0.0.0.0
ENV PORT=8080

COPY ./app /app
