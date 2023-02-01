FROM alpine:3.10.3 as build-env

RUN apk update && apk add --no-cache bash jq

ENTRYPOINT [ "jq" ]