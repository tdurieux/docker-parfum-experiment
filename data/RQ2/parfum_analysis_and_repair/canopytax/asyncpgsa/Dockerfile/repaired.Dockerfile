FROM python:3.8-alpine

RUN apk update && \
    apk add --no-cache \
    gcc \
    musl-dev \
    postgresql-dev

ADD dev-requirements.txt /repo/dev-requirements.txt
RUN pip install --no-cache-dir -r /repo/dev-requirements.txt

ADD . /repo
