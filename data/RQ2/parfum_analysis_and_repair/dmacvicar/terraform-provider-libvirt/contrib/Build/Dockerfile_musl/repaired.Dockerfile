# Building Libvirt Plugin Docker
FROM golang:alpine

ARG VERSION
ENV VERSION=$VERSION

# Install Needed Packages. Libc-dev installs musl-dev
RUN apk update \
    && apk upgrade \
    && apk add --no-cache git make gcc pkgconfig libvirt-dev libc-dev

# Pull Go lint for building
RUN go get -u golang.org/x/lint/golint

# Make directory
RUN mkdir -p $GOPATH/src/github.com/dmacvicar/

# Set Work Directory for Clone
WORKDIR $GOPATH/src/github.com/dmacvicar/

# Clone Project
RUN git clone https://github.com/dmacvicar/terraform-provider-libvirt.git

# Set Workdir for bin build
WORKDIR $GOPATH/src/github.com/dmacvicar/terraform-provider-libvirt

# Checkout Version and download go dependencies
RUN git checkout $VERSION && env GO111MODULE=on go mod download

# Build and move the Binary