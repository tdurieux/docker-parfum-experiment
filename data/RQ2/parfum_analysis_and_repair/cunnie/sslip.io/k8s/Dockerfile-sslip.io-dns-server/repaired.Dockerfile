#
# cunnie/sslip.io-dns-server: sslip.io DNS server Dockerfile
#
# Dockerfile of a (Golang-based) DNS server that responds to DNS queries of
# hostnames with embedded IP addresses (e.g. "169.254.169.254.example.com")
# with the IP address ("169.254.169.254). See https://sslip.io for more
# information
#
# To build:
#
#   docker buildx build -f Dockerfile-sslip.io-dns-server -t cunnie/sslip.io-dns-server --platform linux/arm64/v8,linux/amd64 --push .
#
# Typical start command:
#
#   docker run -d --rm -p 3353:53/udp cunnie/sslip.io-dns-server
#
# To test from host:
#
#    dig +short 127.0.0.1.example.com @localhost -p 3353
#    127.0.0.1
#
FROM alpine AS sslip.io

LABEL org.opencontainers.image.authors="Brian Cunnie <brian.cunnie@gmail.com>"

RUN apk update && apk add --no-cache bind-tools

ARG TARGETARCH # amd64, arm64 (so I can run on AWS graviton2)
RUN wget https://github.com/cunnie/sslip.io/releases/download/2.5.4/sslip.io-dns-server-linux-$TARGETARCH \
    -O /usr/sbin/sslip.io-dns-server; \
  chmod 755 /usr/sbin/sslip.io-dns-server

CMD ["/usr/sbin/sslip.io-dns-server"]

# DNS listens on port 53 UDP
# The `EXPOSE` directive doesn't do much in our case. We use it for documentation.
EXPOSE 53/udp
