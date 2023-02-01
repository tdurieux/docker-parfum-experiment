FROM alpine:3.16.0

RUN apk update && apk upgrade
RUN apk add --no-cache bash curl wget iputils busybox-extras bind-tools tcpdump net-tools procps sysstat
