FROM alpine:3
RUN apk add --no-cache ca-certificates
COPY iptv-proxy /
ENTRYPOINT ["/iptv-proxy"]
