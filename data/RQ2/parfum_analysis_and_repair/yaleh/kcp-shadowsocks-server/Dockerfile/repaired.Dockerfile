# This dockerfile uses the ubuntu image
# VERSION 1 - EDITION 1
# Author: Yale Huang
# Command format: Instruction [arguments / command] ..

# Base image to use, this must be set as the first line
FROM alpine:edge

LABEL maintainer="Yale Huang <calvino.huang@gmail.com>"

# Build arguments
ARG BUILD_DATE
ARG VCS_REF
ARG NAME

# Basic build-time metadata as defined at http://label-schema.org
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile" \
      org.label-schema.license="MIT" \
      org.label-schema.name=$NAME \
      org.label-schema.url="https://github.com/yaleh/kcp-shadowsocks-server" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/yaleh/kcp-shadowsocks-server.git" \
      org.label-schema.vcs-type="Git"

RUN apk --no-cache add --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
	net-tools pwgen bash runit \
	shadowsocks-libev

# Install additional apckages
RUN wget --no-check-certificate -O docker.tgz https://download.docker.com/linux/static/stable/x86_64/docker-20.10.12.tgz && \
	tar xvfz docker.tgz && \
	cp docker/docker /usr/local/bin && \
	rm -rf docker.tgz docker

# Install kcptun