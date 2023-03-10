FROM alpine:3.12
MAINTAINER Ahmed

# install apache2 and remove un-needed services
RUN apk update && \
  apk add --no-cache openrc apache2 bash ca-certificates tinyproxy && \
  rc-update add apache2 && \
  rc-update add tinyproxy && \
  rm -rf /etc/init.d/networking /etc/init.d/hwdrivers /var/cache/apk/* /tmp/*
RUN mkfifo /pipe
