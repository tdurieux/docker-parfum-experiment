FROM python:3-alpine

RUN apk add --no-cache bash shadow groff

RUN useradd build \
  && pip install --no-cache-dir awscli

COPY root /

WORKDIR /mount
