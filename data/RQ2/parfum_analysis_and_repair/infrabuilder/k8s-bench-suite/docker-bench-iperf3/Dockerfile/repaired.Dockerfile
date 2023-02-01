FROM alpine:3
RUN apk add --no-cache --update iperf3 && rm -rf /var/cache/apk/*
