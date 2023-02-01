FROM python:3.8-alpine

RUN apk add --no-cache \
    bash \
    build-base \
    libffi-dev \
    openssl-dev \
    postgresql-dev \
    python3-dev

COPY . /app
WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir pytest
RUN pip install --no-cache-dir .
