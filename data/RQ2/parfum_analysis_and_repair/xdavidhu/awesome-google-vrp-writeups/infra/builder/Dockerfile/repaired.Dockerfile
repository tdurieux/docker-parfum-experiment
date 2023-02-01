FROM python:3.9-slim

WORKDIR /app
COPY . ./

RUN pip install --no-cache-dir requests requests_oauthlib

ENTRYPOINT ["python", "/app/builder.py"]