# Build
FROM golang:1.11-alpine AS octo-cli-build-env

RUN apk add --no-cache git musl-dev gcc bash

WORKDIR /go/src/github.com/octo-cli/octo-cli
COPY . .

RUN script/build

# Package
FROM alpine

COPY --from=octo-cli-build-env /go/src/github.com/octo-cli/octo-cli/bin/octo /bin/octo
RUN apk add --no-cache ca-certificates jq
ENTRYPOINT ["octo"]
