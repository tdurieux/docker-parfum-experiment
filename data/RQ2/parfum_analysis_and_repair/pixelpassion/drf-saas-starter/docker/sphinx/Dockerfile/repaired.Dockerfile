FROM python:3.6.2-slim

ENV PYTHONUNBUFFERED 1

# Requirements have to be pulled and installed here, otherwise caching won't work
COPY ./requirements/documentation.txt /requirements/documentation.txt

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r /requirements/documentation.txt

COPY ./docs/ /app

WORKDIR /app
