FROM alpine:3.8

RUN apk add --no-cache ca-certificates && update-ca-certificates

COPY rootfs/brigade-api /usr/bin/brigade-api

CMD /usr/bin/brigade-api
