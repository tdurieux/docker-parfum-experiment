FROM alpine

RUN apk add --no-cache rsync

COPY entrypoint.sh /
