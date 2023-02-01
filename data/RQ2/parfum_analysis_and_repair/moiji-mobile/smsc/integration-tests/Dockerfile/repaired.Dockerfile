FROM python:2-alpine

COPY requirements.txt /integration-tests/

WORKDIR /integration-tests

RUN apk update && apk add --no-cache curl git && \
    pip install --no-cache-dir -r requirements.txt && rm requirements.txt
