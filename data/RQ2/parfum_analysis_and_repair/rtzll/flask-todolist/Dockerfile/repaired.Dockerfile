FROM python:3-alpine

RUN apk add --no-cache build-base

ADD . /code
WORKDIR /code

RUN pip install --no-cache-dir gunicorn
RUN pip install --no-cache-dir -r requirements.txt
