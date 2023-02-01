FROM python:3.6.1-alpine

RUN apk update \
  && apk add --no-cache \
    build-base \
    postgresql \
    postgresql-dev \
    libpq

RUN mkdir /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY ./requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ENV PYTHONUNBUFFERED 1

COPY . .
