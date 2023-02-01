FROM python:3.6.8-alpine
LABEL maintainer="Datadog Inc."

COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
