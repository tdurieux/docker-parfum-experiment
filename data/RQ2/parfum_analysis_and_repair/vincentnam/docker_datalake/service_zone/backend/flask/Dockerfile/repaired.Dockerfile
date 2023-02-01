FROM python:3.9-alpine

MAINTAINER Li XU

ENV PYTHONUNBUFFERED 1

RUN mkdir /app
WORKDIR /app
COPY ./requirements.txt /app/requirements.txt

RUN apk add --update --no-cache g++ linux-headers && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt
