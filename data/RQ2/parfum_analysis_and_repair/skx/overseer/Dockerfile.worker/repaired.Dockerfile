#
# Dockerfile for the worker process
#
#    docker build -t overseer:worker -f Dockerfile.worker .
#

FROM golang:1.15

# Create a working directory
WORKDIR /go/src/app

# Copy our source and build it.
COPY . .

# Install
RUN go install -v ./...

# Entry-point