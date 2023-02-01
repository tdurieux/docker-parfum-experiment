# Prebuilt libjq.
FROM --platform=${TARGETPLATFORM:-linux/amd64} flant/jq:b6be13d5-musl as libjq

# Go builder.
FROM --platform=${TARGETPLATFORM:-linux/amd64} golang:1.16-alpine3.15 AS builder

ARG appVersion=latest
RUN apk --no-cache add git ca-certificates gcc musl-dev libc-dev

# Cache-friendly download of go dependencies.
ADD go.mod go.sum /app/
WORKDIR /app
RUN go mod download

COPY --from=libjq /libjq /libjq
ADD . /app

# Clone shell-operator to get frameworks
RUN git clone https://github.com/flant/shell-operator shell-operator-clone && \
    cd shell-operator-clone && \
    git checkout v1.0.9

RUN shellOpVer=$(go list -m all | grep shell-operator | cut -d' ' -f 2-) \
    CGO_ENABLED=1 \
    CGO_CFLAGS="-I/libjq/include" \
    CGO_LDFLAGS="-L/libjq/lib" \
    GOOS=linux \
    go build -ldflags="-linkmode external -extldflags '-static' -s -w -X 'github.com/flant/shell-operator/pkg/app.Version=$shellOpVer' -X 'github.com/flant/addon-operator/pkg/app.Version=$appVersion'" \
             -tags='release' \
             -o addon-operator \
             ./cmd/addon-operator

# Final image
FROM --platform=${TARGETPLATFORM:-linux/amd64} alpine:3.15
ARG TARGETPLATFORM
# kubectl url has no variant (v7)
# helm url has dashes and no variant (v7)