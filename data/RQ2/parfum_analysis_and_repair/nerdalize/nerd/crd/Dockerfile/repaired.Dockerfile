FROM alpine:3.1

ADD controller /bin/

RUN apk update && apk add --no-cache ca-certificates

ENTRYPOINT ["/bin/controller"]

