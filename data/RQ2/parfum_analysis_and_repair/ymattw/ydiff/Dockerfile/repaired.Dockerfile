FROM python:3-alpine

COPY requirements-dev.txt /tmp/

RUN pip install --no-cache-dir -r /tmp/requirements-dev.txt && \
    apk add --no-cache bash git less make
