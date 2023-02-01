FROM xeor/base-alpine:0.4

ENV REFRESHED_AT 2018-01-21

RUN apk update \
    && apk add --no-cache dnsmasq

COPY root /
