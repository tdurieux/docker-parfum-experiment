FROM python:3.7-alpine

ENV PYTHONUNBUFFERED 1

RUN mkdir /code

WORKDIR /code

ADD reqs.txt /code/

RUN apk update && \
 apk add --no-cache postgresql-libs && \
 apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
 python3 -m pip install -r reqs.txt --no-cache-dir && \
 apk --purge del .build-deps

ADD . /code/
