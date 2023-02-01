FROM alpine:latest
MAINTAINER Miek Gieben <miek@miek.nl> (@miekg)

RUN apk --update --no-cache add bind-tools && rm -rf /var/cache/apk/*

ADD skydns skydns

EXPOSE 53 53/udp
ENTRYPOINT ["/skydns"]
