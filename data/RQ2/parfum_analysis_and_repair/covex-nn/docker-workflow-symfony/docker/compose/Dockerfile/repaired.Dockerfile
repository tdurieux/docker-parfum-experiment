FROM docker:stable

RUN apk add --no-cache py-pip \
    && pip install --no-cache-dir docker-compose
