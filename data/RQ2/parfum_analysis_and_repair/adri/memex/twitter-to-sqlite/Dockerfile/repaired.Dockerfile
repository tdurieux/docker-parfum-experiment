FROM python:3.7-alpine

WORKDIR /home

RUN pip install --no-cache-dir twitter-to-sqlite