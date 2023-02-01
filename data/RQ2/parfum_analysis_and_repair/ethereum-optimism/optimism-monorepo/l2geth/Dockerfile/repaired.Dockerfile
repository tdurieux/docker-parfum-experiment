# Build Geth in a stock Go builder container
FROM golang:1.18.0-alpine3.15 as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

COPY ./l2geth /app/l2geth

WORKDIR /app/l2geth
RUN make geth

# Pull Geth into a second stage deploy alpine container