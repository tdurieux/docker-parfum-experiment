FROM alpine:latest
RUN apk add --no-cache git bash

WORKDIR /output

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh