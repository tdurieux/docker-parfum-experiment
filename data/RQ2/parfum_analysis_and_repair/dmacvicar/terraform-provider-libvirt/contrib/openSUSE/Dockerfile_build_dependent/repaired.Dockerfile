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