FROM python:3.7-alpine
MAINTAINER Jan Losinski <losinski@wh2.tu-dresden.de>

ADD requirements.txt /tmp
RUN apk add --no-cache -U --virtual .bdep \
    build-base \
    gcc \
    && \
    pip install --no-cache-dir -r /tmp/requirements.txt && \
    apk del .bdep

ADD . /app
VOLUME /data

WORKDIR /app

EXPOSE 8080

CMD ./service.py --refresher --consumer --interface --env