FROM alpine:3.7

RUN apk add --no-cache --update \
	bind \
	bind-dev \
	bind-libs \
	gcc \
	libcap-dev \
	make \
	musl-dev \
	libressl2.6-libcrypto \
	libcrypto1.0 \
	openssl-dev \
    libxml2-dev
