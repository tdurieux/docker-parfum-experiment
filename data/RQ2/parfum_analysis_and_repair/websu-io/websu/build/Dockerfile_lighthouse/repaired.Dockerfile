FROM alpine:3.15

WORKDIR /opt/lighthouse

ARG LH_VERSION="9.4.0"
RUN apk --update-cache --no-cache \
     add npm chromium \
    && npm -g install lighthouse@$LH_VERSION && npm cache clean --force;

VOLUME /var/lighthouse
