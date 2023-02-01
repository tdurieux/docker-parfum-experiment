FROM python:3.9-alpine
WORKDIR /polybot
COPY . .
RUN apk add --no-cache --virtual .build-deps gcc musl-dev libffi-dev openssl-dev && \
        pip install --no-cache-dir requests mastodon.py tweepy && \
	pip install --no-cache-dir . && \
        apk del .build-deps && \
	rm -Rf /polybot
