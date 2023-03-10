FROM    golang:1.9.4-alpine3.6

RUN apk add --no-cache -U git bash coreutils gcc musl-dev

ENV     CGO_ENABLED=0 \
        DISABLE_WARN_OUTSIDE_CONTAINER=1
WORKDIR /go/src/github.com/docker/cli
CMD     ./scripts/build/binary
