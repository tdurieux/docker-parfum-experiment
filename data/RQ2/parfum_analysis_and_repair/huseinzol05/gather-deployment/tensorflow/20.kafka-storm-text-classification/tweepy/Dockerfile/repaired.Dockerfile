FROM python:3.6.7-jessie AS base

RUN pip install --no-cache-dir tweepy unidecode requests
RUN pip install --no-cache-dir kafka-python

WORKDIR /app

COPY . /app