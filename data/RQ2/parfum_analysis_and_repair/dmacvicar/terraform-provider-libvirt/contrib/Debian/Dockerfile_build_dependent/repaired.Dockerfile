# Set to linux or name of OS
ARG GO_OS

# Set to arch name of your system
ARG GO_ARCH

# Terraform Version
ARG TERRAFORM_VERSION=0.12.0

# Grab the Terraform binary
FROM hashicorp/terraform:$TERRAFORM_VERSION AS terraform

# Grab the Terraform Libvirt Provider binary
FROM provider-libvirt:v0.5.2-debian AS libvirt

# Base Image
FROM ubuntu:18.04

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
# libvirt0 is needed to run the provider. xsltproc needed to use XML/XSLT. mkisofs needed to use cloud init images
# ca-certificates to avoid terraform init 509 error. openssh-client to talk to remote libvirt server
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install \
    -y --no-install-recommends \
    libvirt0 xsltproc mkisofs ca-certificates openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Copy Terraform Files
# COPY libvirt.tf /root/

# Terraform commands
# RUN terraform init