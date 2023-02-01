FROM alpine:3.12
LABEL maintainer="me@iskywind.com"

RUN { \
	apk add --no-cache --update linux-headers gcc python3-dev libffi-dev openssl-dev cargo libxslt-dev zlib-dev libxml2-dev musl-dev nginx bash supervisor transmission-daemon python3 cargo curl tzdata; \
	curl -f https://bootstrap.pypa.io/get-pip.py | python3; \
	pip install --no-cache-dir cryptography; \
	pip install --no-cache-dir 'transmissionrpc'; \
}

