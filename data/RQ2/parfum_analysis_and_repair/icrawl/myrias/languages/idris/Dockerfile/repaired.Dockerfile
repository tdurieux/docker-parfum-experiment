FROM alpine:latest

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache idris@testing

COPY run.sh /var/run/
