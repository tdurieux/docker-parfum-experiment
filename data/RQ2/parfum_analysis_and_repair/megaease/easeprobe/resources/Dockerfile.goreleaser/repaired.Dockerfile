FROM --platform=$BUILDPLATFORM alpine:latest

WORKDIR /opt/

COPY easeprobe /opt/
COPY resources/scripts/entrypoint.sh /
RUN apk update && apk add --no-cache tini tzdata busybox-extras curl redis

ENV PATH /opt/:$PATH
ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]
