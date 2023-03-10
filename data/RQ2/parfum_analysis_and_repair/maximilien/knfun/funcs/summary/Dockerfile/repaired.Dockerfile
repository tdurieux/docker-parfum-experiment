# Use the official Golang image to create a build artifact.
# This is based on Debian and sets the GOPATH to /go.
# https://hub.docker.com/_/golang
FROM golang:1.18

ENV GOOS=linux 
ENV GOARCH=amd64

# Create and change to the app directory.
WORKDIR /usr/src/app

# Retrieve application dependencies using go modules.
# Allows container builds to reuse downloaded dependencies.
COPY go.mod go.sum ./
RUN go mod download && go mod verify

# Copy local code to the container image.
COPY . .

# Build the binary.
RUN go build -v -o /usr/local/summary-fn ./funcs/summary/...

# Add start.sh
ADD ./funcs/summary/start.sh /
RUN chmod +x /start.sh

# start it