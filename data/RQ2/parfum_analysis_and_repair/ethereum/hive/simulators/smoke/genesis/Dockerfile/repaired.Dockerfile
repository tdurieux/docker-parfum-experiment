# Build the simulator.
FROM golang:1-alpine AS builder
RUN apk --no-cache add gcc musl-dev linux-headers
ADD . /genesis
WORKDIR /genesis
RUN go build .

# Build the runner container.