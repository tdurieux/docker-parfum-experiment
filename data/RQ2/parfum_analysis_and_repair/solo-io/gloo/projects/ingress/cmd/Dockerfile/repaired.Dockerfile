FROM alpine:3.15.4

ARG GOARCH=amd64

RUN apk -U upgrade

COPY ingress-linux-$GOARCH /usr/local/bin/ingress

USER 10101

ENTRYPOINT ["/usr/local/bin/ingress"]