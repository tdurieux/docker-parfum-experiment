FROM python:3.6-alpine3.6
ENV PYTHONUNBUFFERED 1

RUN apk update
RUN apk add --no-cache postgresql-libs gcc
RUN apk add --no-cache musl-dev postgresql-client postgresql-dev libxslt-dev libxml2-dev pkgconfig xmlsec-dev

RUN pip install --no-cache-dir -U pip

RUN mkdir /PawPrints

WORKDIR /PawPrints

ADD ./requirements.txt /PawPrints/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

ADD . /PawPrints
