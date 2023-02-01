FROM alpine:3.10.3

RUN apk update && apk add --no-cache bash jq curl

ENTRYPOINT [ "curl" ]