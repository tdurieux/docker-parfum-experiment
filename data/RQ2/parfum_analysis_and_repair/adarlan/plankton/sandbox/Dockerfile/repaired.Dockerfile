FROM alpine:latest

RUN apk update
RUN apk add --no-cache docker
ENTRYPOINT [ "dockerd" ]
