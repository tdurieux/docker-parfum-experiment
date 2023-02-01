# Build Geth in a stock Go builder container
FROM golang:1.17-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git bash

ADD . /bor
RUN cd /bor && make bttc-all

CMD ["/bin/bash"]

# Pull Bor into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /bor/build/bin/bttc /usr/local/bin/
COPY --from=builder /bor/build/bin/bootnode /usr/local/bin/

EXPOSE 8545 8546 8547 30303 30303/udp
