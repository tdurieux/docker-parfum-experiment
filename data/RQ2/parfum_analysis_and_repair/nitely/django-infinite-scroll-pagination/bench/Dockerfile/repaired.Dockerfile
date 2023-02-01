FROM python:3.7.2-alpine

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apk update \
    && apk add --no-cache \
        postgresql-client \
        postgresql-dev \
        gcc \
        musl-dev \
        make \
        libffi-dev

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir Django==2.2.8 \
    && pip install --no-cache-dir psycopg2-binary==2.8.6

CMD until pg_isready --username=postgres --host=database; do sleep 1; done;
ENTRYPOINT /bin/sh
