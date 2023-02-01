FROM python:2.7.13

RUN pip install --no-cache-dir nose requests websockets-client==0.59.0

WORKDIR /code
