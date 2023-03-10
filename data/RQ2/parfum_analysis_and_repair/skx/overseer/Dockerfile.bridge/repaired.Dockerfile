#
# Dockerfile for the bridge
#
#    docker build -t overseer:bridge -f Dockerfile.bridge .
#

FROM golang:1.15

# Create a working directory
WORKDIR /go/src/app

# Copy our source and build it.
COPY . .

# Install
RUN cd /go/src/app/bridges/telegram-bridge/ && go install -v .

# Entry-point