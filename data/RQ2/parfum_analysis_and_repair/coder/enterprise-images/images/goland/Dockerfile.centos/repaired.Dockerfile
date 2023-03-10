FROM codercom/enterprise-golang:centos

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

# Install goland.
RUN mkdir -p /opt/goland
RUN curl -f -L "https://download.jetbrains.com/product?code=GO&latest&distribution=linux" | tar -C /opt/goland --strip-components 1 -xzvf -

# Add a binary to the PATH that points to the goland startup script.
RUN ln -s /opt/goland/bin/goland.sh /usr/bin/goland

# Set back to coder user
USER coder
