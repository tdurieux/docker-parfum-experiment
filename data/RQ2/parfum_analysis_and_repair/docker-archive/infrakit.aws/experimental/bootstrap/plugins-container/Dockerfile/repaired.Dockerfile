FROM alpine:3.4

RUN apk update && apk add --no-cache ca-certificates

ADD build/* /usr/local/bin/
