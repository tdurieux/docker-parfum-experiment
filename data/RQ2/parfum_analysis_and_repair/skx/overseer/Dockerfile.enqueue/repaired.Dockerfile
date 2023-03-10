#
# Dockerfile for enqueue process
#
#    docker build -t oversser:enqueue -f Dockerfile.enqueue .
#

FROM golang:1.15

# Create a working directory
WORKDIR /go/src/app

# Copy our source and build it.
COPY . .

# Install
RUN go install -v ./...

# Entry-point