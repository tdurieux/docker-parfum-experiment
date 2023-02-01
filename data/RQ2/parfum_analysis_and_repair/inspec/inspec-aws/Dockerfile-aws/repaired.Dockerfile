FROM python:3.7.7-alpine3.10

RUN apk add --no-cache \
    bash \
    curl \
    jq \
    && pip3 install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir awscli

WORKDIR /app

ENTRYPOINT ["aws"]
