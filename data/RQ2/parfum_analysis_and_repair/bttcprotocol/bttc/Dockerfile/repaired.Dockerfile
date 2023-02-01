# Build Geth in a stock Go builder container
FROM golang:1.17-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git bash

ADD . /bor
RUN cd /bor && make bttc-all

CMD ["/bin/bash"]

# Pull Bor into a second stage deploy alpine container