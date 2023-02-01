# Build the simulator.
FROM golang:1-alpine AS builder
RUN apk --no-cache add gcc musl-dev linux-headers
ADD . /clique
WORKDIR /clique
RUN go build .

# Build the runner container.