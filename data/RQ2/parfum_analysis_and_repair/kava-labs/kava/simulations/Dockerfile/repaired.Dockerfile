FROM golang:1.13-alpine AS build-env

# Set up dependencies
# bash for debugging
# git, make for installation
# libc-dev, gcc, linux-headers, eudev-dev are used for cgo and ledger installation (possibly)
RUN apk add --no-cache bash git make libc-dev gcc linux-headers eudev-dev jq

# Install aws cli
RUN apk add --no-cache python py-pip
RUN pip install --no-cache-dir awscli

# Set working directory for the build
WORKDIR /root/kava
# default home directory is /root

# Download dependencies before adding source files to speed up build times
COPY go.mod .
COPY go.sum .
RUN go mod download

# Add source files
COPY app app
COPY cli_test cli_test
COPY cmd cmd
COPY app app
COPY x x
COPY Makefile .

COPY simulations simulations

# kvd and kcli binaries are not necessary for running the simulations