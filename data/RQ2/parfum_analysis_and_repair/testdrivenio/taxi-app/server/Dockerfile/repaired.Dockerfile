FROM python:3.7.2-alpine

RUN apk update && apk add --no-cache build-base python-dev py-pip jpeg-dev zlib-dev
ENV LIBRARY_PATH=/lib:/usr/lib

WORKDIR /usr/src/app

COPY ./requirements.txt /usr/src/app

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY . /usr/src/app

WORKDIR /usr/src/app/taxi

RUN python manage.py collectstatic --noinput
