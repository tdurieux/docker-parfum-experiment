FROM python:3.5.2

ENV PYTHONUNBUFFERED 1

COPY ./docker/django/django-entrypoint.sh /
COPY ./requirements.txt /django/requirements.txt

WORKDIR /django

RUN pip install --no-cache-dir pip==9.0.1
RUN pip install --no-cache-dir -r requirements.txt
