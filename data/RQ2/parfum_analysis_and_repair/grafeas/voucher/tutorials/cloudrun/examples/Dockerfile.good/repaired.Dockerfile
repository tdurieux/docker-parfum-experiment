FROM alpine:3.8

RUN apk add --no-cache util-linux
CMD uuidgen > /IAMUNIQUE