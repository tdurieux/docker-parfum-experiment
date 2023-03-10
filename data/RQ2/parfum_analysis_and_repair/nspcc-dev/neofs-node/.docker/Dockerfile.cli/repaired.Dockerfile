FROM golang:1.17 as builder
ARG BUILD=now
ARG VERSION=dev
ARG REPO=repository
WORKDIR /src
COPY . /src

RUN make bin/neofs-cli

# Executable image
FROM alpine AS neofs-cli
RUN apk add --no-cache bash

WORKDIR /

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /src/bin/neofs-cli /bin/neofs-cli

CMD ["neofs-cli"]