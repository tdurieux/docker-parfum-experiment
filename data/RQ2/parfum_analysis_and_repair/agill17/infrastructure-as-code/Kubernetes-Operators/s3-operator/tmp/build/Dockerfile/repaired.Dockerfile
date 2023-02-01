FROM alpine:3.6

RUN apk --update upgrade && apk add --no-cache ca-certificates

ADD tmp/_output/bin/s3-operator /usr/local/bin/s3-operator
