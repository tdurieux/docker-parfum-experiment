#FROM tensorflow/tensorflow:1.13.1-py3

FROM python:3.6-slim

ADD requirements.txt requirements.txt
RUN \
  pip install --no-cache-dir -r requirements.txt
