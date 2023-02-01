FROM python:3.6.1 AS base

WORKDIR /app

RUN pip install --no-cache-dir kafka-python

COPY . /app