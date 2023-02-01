FROM python:3.7

RUN pip install --no-cache-dir fastapi uvicorn aiofiles requests

EXPOSE 5000

COPY ./app /app
