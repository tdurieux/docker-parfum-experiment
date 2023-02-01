FROM python:3.4.3
MAINTAINER Filipe Garcia <filipe.garcia@seedstarslabs.com>

ENV PYTHONUNBUFFERED 1

COPY ./docker/django/django-entrypoint.sh /
COPY ./py-requirements /django/py-requirements

WORKDIR /django

RUN pip install --no-cache-dir pip==9.0.1
RUN pip install --no-cache-dir -r py-requirements/dev.txt
