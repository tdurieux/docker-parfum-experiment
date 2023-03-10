ARG BASE=alpine:3.9
FROM ${BASE}
MAINTAINER IOTech <support@iotechsys.com>
RUN apk add --update --no-cache build-base wget git gcc cmake make yaml-dev libcurl curl-dev libmicrohttpd-dev util-linux-dev ncurses-dev && mkdir -p /edgex-c-sdk/build
COPY VERSION /edgex-c-sdk/
COPY src /edgex-c-sdk/src/
COPY include /edgex-c-sdk/include/
COPY scripts /edgex-c-sdk/scripts
COPY LICENSE /edgex-c-sdk/
COPY Attribution.txt /edgex-c-sdk/
WORKDIR /edgex-c-sdk
ENTRYPOINT ["/edgex-c-sdk/scripts/entrypoint.sh"]