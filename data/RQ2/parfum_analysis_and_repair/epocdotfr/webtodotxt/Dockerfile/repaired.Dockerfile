FROM python:3.6-alpine
MAINTAINER Jan Losinski

ADD requirements.txt /requirements.txt

RUN apk add --no-cache -U \
	libxml2 \
	libxslt \
	&& \
    apk add --no-cache -U --virtual .bdeps \
	gcc \
	linux-headers \
	libxml2-dev \
	libxslt-dev \
	git \
	musl-dev \
	&& \
    pip install --no-cache-dir uwsgi && \
    pip install --no-cache-dir -r /requirements.txt && \
    pip install --no-cache-dir webdavclient3 && \
    apk del .bdeps

ADD . /app

RUN cd /app && \
    cp config.docker.py config.py && \
    pybabel compile -d translations && \ 
    mkdir /data && \
    adduser -S uwsgi && \
    chown -R uwsgi /data && \
    chown -R uwsgi /app/storage

WORKDIR /app
ENV MODE=http
VOLUME /data
EXPOSE 9000

CMD uwsgi --master --wsgi-file uwsgi.py --callable app \
	--processes 2 --threads 2 --$MODE :9000 --uid uwsgi
