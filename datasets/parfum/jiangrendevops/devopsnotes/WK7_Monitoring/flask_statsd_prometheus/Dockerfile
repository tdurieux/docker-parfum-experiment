FROM python:3.6.1-alpine
ADD src/ /application
WORKDIR /application
RUN pip install --upgrade pip
RUN set -e; \
	apk add --no-cache --virtual .build-deps \
		gcc \
		libc-dev \
		linux-headers \
	; \
	pip install --upgrade pip; \
	pip install -r requirements.txt; \
	apk del .build-deps;
EXPOSE 5000
VOLUME /application
CMD uwsgi --http :5000  --manage-script-name --mount /application=flask_app:app --enable-threads --processes 5