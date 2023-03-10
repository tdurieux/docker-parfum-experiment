FROM python:3-alpine

RUN apk add --update --no-cache python3-dev build-base pcre-dev linux-headers
RUN pip install --no-cache-dir flask uwsgi

WORKDIR /app
COPY ./flask_app.py .
COPY ./uwsgi_app.py .
COPY ./uwsgi.ini .

ENV PYTHONUNBUFFERED=1
