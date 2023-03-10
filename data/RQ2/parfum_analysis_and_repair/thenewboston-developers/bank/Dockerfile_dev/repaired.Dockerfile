FROM python:3.8-alpine

WORKDIR /opt/project

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY ./requirements/local.txt /requirements.txt
COPY ./dist/ ./

RUN set -xe \
    && apk update \
    && apk add --no-cache --virtual build-deps gcc python3-dev musl-dev libressl-dev libffi-dev make \
    && apk add --no-cache postgresql-dev postgresql-client curl \
    && pip install --no-cache-dir --upgrade pip pip-tools \
    && pip install --no-cache-dir -r /requirements.txt \
    && if [ -f thenewboston.tar.gz ]; then \
    pip install --no-cache-dir thenewboston.tar.gz; fi \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache

EXPOSE 8000

#HEALTHCHECK --interval=5m --timeout=3s \
#  CMD curl -f http://localhost:8000/config || exit 1

COPY . .
