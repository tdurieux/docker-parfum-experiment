FROM python:3

LABEL maintainer="AnhellO"

RUN pip install --no-cache-dir pika

WORKDIR /usr/src/app

COPY ./app .