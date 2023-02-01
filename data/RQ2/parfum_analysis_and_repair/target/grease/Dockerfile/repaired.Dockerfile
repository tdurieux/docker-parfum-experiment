FROM python:3-alpine

RUN apk update

RUN apk add --no-cache --virtual deps gcc python-dev linux-headers musl-dev postgresql-dev

RUN apk add --no-cache libpq

RUN pip install --no-cache-dir requests pymongo psutil

ADD . /tgt_grease_core

WORKDIR /tgt_grease_core

RUN python ./setup.py install
