FROM python:3.7-alpine

COPY ./uwsgi.ini /app/

WORKDIR /app/backend

RUN apk add --no-cache build-base linux-headers pcre-dev

COPY ./requirements.txt /app/backend

RUN pip3 install --no-cache-dir --upgrade setuptools
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . /app/backend
