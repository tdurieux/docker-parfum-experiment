FROM alpine:latest
MAINTAINER Matthew Gall <docker@matthewgall.com>

RUN apk add --update \
	build-base \
	python3 \
	python3-dev \
	py-pip \
	openssl-dev \
	libffi-dev \
	&& rm -rf /var/cache/apk/*

WORKDIR /app
COPY . /app

RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r /app/requirements.txt

EXPOSE 5000
CMD ["python3", "/app/app.py"]