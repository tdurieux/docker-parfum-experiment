FROM alpine:latest
RUN apk add --no-cache git bash openssh

WORKDIR /output

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh