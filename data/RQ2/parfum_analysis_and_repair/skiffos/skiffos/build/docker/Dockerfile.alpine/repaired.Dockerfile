FROM alpine:edge
RUN apk --update upgrade
RUN apk add --no-cache make git bash ncurses gcc wget curl \
    musl-dev file g++ perl python3 rsync bc patch \
    libintl libtool alpine-sdk gettext
RUN adduser -D -u 1000 -g 1001 buildroot && \
    mkdir -p /home/buildroot && chown buildroot:buildroot /home/buildroot
USER buildroot
WORKDIR /home/buildroot
