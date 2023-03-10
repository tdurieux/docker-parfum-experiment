# Build Geth in a stock Go builder container
FROM golang:1.15-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

ADD . /go-ethereum
RUN cd /go-ethereum && GO111MODULE=on go run build/ci.go install ./cmd/geth

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache groff less python3 curl jq ca-certificates && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache-dir --no-cache --upgrade pip setuptools awscli

COPY --from=builder /go-ethereum/build/bin/geth /usr/local/bin/

COPY ./infra/start-mev-geth-node.sh /root/start-mev-geth-node.sh
RUN chmod 755 /root/start-mev-geth-node.sh

EXPOSE 8545 8546 30303 30303/udp
ENTRYPOINT ["/root/start-mev-geth-node.sh"]
