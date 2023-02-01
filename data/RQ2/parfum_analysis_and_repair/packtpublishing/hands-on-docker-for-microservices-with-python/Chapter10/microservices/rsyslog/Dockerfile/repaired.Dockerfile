FROM alpine:3.9

RUN apk add --no-cache --update rsyslog

COPY rsyslog.conf  /etc/rsyslog.d/rsyslog.conf
