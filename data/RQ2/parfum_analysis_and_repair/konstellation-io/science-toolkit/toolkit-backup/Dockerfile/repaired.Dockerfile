FROM alpine:3.11

RUN apk add --no-cache --update python python-dev py-pip build-base postgresql-client \
    && pip install --no-cache-dir awscli==1.14.10 --upgrade --user
