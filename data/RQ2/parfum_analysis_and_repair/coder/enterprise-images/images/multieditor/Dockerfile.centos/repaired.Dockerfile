FROM codercom/enterprise-base:centos

# Run everything as root
USER root

# Packages required for multi-editor support
RUN yum update -y && yum install -y \
    openssl \
    libXtst \
    libXrender \
    fontconfig \
    libXi \
    gtk3 \
    libGL && rm -rf /var/cache/yum

# Set back to coder user
USER coder
