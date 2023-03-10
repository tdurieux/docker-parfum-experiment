FROM golang:1.18.0-alpine3.15 as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git jq bash

COPY ./op-bindings /app/op-bindings
COPY ./op-node /app/op-node
COPY ./op-proposer /app/op-proposer

WORKDIR /app/op-proposer

RUN make op-proposer

FROM alpine:3.15

COPY --from=builder /app/op-proposer/bin/op-proposer /usr/local/bin

CMD ["op-proposer"]