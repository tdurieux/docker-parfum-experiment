FROM alpine

RUN apk update
RUN apk add --no-cache qemu qemu-img qemu-system-x86_64 qemu-ui-gtk
RUN apk add --no-cache proot --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing
