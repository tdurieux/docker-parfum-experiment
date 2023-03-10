FROM golang:1.18.0-alpine3.15 as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git jq bash

COPY ./op-node/go.mod /app/op-node/go.mod
COPY ./op-node/go.sum /app/op-node/go.sum

COPY ./op-bindings /app/op-bindings

WORKDIR /app/op-node
RUN go mod download -x

COPY ./op-node /app/op-node

RUN go build -o ./bin/stateviz ./cmd/stateviz

FROM alpine:3.15

COPY --from=builder /app/op-node/bin/stateviz /usr/local/bin

CMD ["stateviz"]