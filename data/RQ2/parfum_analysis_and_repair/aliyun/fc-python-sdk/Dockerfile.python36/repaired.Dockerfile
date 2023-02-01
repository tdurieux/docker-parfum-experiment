FROM python:3.6

RUN pip install --no-cache-dir nose requests websockets-client==0.59.0

WORKDIR /code
