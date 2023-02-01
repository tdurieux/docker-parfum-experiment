FROM python:3.8-alpine3.13

WORKDIR /opt/project

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY ./requirements/local.txt /requirements.txt

RUN set -xe \
    && apk update \
    && apk add --no-cache --virtual build-deps gcc python3-dev musl-dev libressl-dev libffi-dev make gcc python3-dev \
    && apk add --no-cache postgresql-dev postgresql-client curl \
    && apk add --no-cache jpeg-dev zlib-dev libjpeg \
    && pip install --no-cache-dir Pillow \
    && pip install --no-cache-dir --upgrade pip pip-tools \
    && pip install --no-cache-dir -r /requirements.txt \
    && if [ -f thenewboston.tar.gz ]; then \
    pip install --no-cache-dir thenewboston.tar.gz; fi \
    && apk del build-deps \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache

EXPOSE 8000

COPY . .
