FROM alpine:3.9
MAINTAINER "Stakater Team"

RUN apk add --no-cache --update ca-certificates

COPY ProxyInjector /bin/ProxyInjector

ENTRYPOINT ["/bin/ProxyInjector"]
