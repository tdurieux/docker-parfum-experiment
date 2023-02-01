# stage 1 Generate celestia-appd Binary
FROM golang:1.17-alpine as builder
RUN apk update && apk --no-cache add make gcc git musl-dev
COPY . /celestia-app
WORKDIR /celestia-app
RUN make build

# stage 2
FROM alpine
RUN apk update && apk --no-cache add bash

COPY --from=builder /celestia-app/build/celestia-appd /bin/celestia-appd
COPY  docker/entrypoint.sh /opt/entrypoint.sh

# p2p, rpc and prometheus port