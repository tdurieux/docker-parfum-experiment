# Set to linux or name of OS
ARG GO_OS

# Set to arch name of your system
ARG GO_ARCH

# Terraform Version
ARG TERRAFORM_VERSION=0.12.0

# Provider Version
ARG VERSION

# Grab the Terraform binary
FROM hashicorp/terraform:$TERRAFORM_VERSION AS terraform

# Building Libvirt Plugin Docker
FROM golang:stretch as libvirt

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
RUN make build && mv terraform-provider-libvirt $GOPATH/bin/

# Base Image
FROM opensuse/tumbleweed:latest

ARG GO_OS
ENV GO_OS=$GO_OS
ARG GO_ARCH
ENV GO_ARCH=$GO_ARCH

# Set working directory
WORKDIR /root/

# Make Directory for Provider Binaries
RUN mkdir -p /root/.terraform.d/plugins/${GO_OS}_${GO_ARCH}/

# Copy binaries from containers
COPY --from=terraform /bin/terraform /bin/
COPY --from=libvirt /go/bin/terraform-provider-libvirt /root/.terraform.d/plugins/${GO_OS}_${GO_ARCH}/

# Install Dependencies
# libvirt-client is needed to run the provider. libxslt-tools needed to use XML/XSLT. mkisofs needed to use cloud init images
RUN zypper update \
    && zypper dist-upgrade \
    && zypper --non-interactive install --no-recommends libvirt-client libxslt-tools mkisofs openssh

# Copy Terraform Files
# COPY libvirt.tf /root/

# Terraform commands
# RUN terraform init