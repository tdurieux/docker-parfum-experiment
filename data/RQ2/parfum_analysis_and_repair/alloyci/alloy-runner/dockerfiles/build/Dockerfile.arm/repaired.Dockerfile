FROM multiarch/alpine:armhf-v3.4

RUN apk add --no-cache --update bash ca-certificates git miniperl \
	&& ln -s miniperl /usr/bin/perl

COPY ./ /usr/bin
