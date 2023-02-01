FROM python:3

RUN pip install --no-cache-dir pika

WORKDIR /usr/src/app

COPY ./app .