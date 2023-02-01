FROM python:3.8-alpine
ENV PYTHONUNBUFFERED 1

RUN apk add --no-cache alpine-sdk
RUN apk add --no-cache bash
RUN apk add --no-cache vim
RUN apk add --no-cache mariadb-dev
RUN apk add --no-cache jpeg-dev
RUN apk add --no-cache libpng-dev
RUN apk add --no-cache libffi-dev

RUN mkdir /game_portal
WORKDIR /game_portal

ADD game_portal ./
ADD requirements.txt ./

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt

CMD gunicorn game_portal.wsgi:application --bind 0.0.0.0:8000 --reload