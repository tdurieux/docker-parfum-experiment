FROM alpine

RUN set -e; \
	apk update; \
	apk add --no-cache \
					autoconf \
					build-base \
					ca-certificates \
					libev-dev \
					openssl-dev \
					automake \
					py3-docutils \
					flex \
					bison \
					pkgconfig \
					make
