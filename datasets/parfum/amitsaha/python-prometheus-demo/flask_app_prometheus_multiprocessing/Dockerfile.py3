FROM python:3.6.1-alpine
ADD . /application
WORKDIR /application
RUN set -e; \
	apk add --no-cache --virtual .build-deps \
		gcc \
		libc-dev \
		linux-headers \
	; \
	pip install -r src/requirements.txt; \
	apk del .build-deps;
EXPOSE 5000
VOLUME /application
RUN mkdir /tmp/prom_data
ENV prometheus_multiproc_dir /tmp/prom_data
CMD uwsgi --http :5000  --manage-script-name --mount /myapplication=flask_app:app --enable-threads --processes 5
