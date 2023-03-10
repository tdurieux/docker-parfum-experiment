FROM --platform=$BUILDPLATFORM golang:1.17 as builder

WORKDIR /src

# Build
ARG TARGETOS TARGETARCH
RUN --mount=target=. \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg \
    CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -a -o /out/onionbalance-local-manager ./agents/onionbalance/main.go

FROM alpine:latest

ARG VERSION=0.2.2

RUN apk add --no-cache --update git python3 py3-pip py3-wheel py3-cryptography py3-setproctitle py3-pycryptodomex
RUN python3 -m pip install git+https://gitlab.torproject.org/tpo/core/onionbalance.git@${VERSION}

COPY --from=builder /out/onionbalance-local-manager .

# ENTRYPOINT ["/usr/bin/onionbalance"]
ENTRYPOINT ["./onionbalance-local-manager"]
