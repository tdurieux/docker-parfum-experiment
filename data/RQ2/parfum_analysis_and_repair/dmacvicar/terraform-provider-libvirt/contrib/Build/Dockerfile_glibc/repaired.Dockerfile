# Building Libvirt Plugin Docker
FROM golang:stretch

ARG VERSION
ENV VERSION=$VERSION

# Install Needed Packages
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install \
    -y --no-install-recommends \
    git make pkg-config gcc libc-dev libvirt-dev \
    && rm -rf /var/lib/apt/lists/*

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