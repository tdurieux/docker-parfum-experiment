# Dockerfile for Shadowsocks-Python based alpine
# Copyright (C) 2018 - 2019 Teddysun <i@teddysun.com>
# Reference URL:
# https://github.com/shadowsocks/shadowsocks/tree/master

FROM python:3.7-alpine
LABEL maintainer="Teddysun <i@teddysun.com>"

RUN set -ex \
	&& apk add --no-cache unzip libsodium-dev openssl mbedtls \
	&& cd /tmp \
	&& wget -O shadowsocks.zip https://github.com/shadowsocks/shadowsocks/archive/master.zip \
	&& unzip shadowsocks.zip \
	&& cd shadowsocks-master \
	&& python setup.py install \
	&& cd /tmp \
	&& rm -fr shadowsocks.zip shadowsocks-master 

COPY config_sample.json /etc/shadowsocks-python/config.json
VOLUME /etc/shadowsocks-python

CMD [ "ssserver", "-c", "/etc/shadowsocks-python/config.json" ]
