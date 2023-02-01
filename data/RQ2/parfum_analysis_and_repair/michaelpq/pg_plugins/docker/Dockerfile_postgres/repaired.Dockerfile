FROM alpine-armv7l:edge
RUN echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories  && \
apk --update && \
 apk add --no-cache shadow postgresql bash
