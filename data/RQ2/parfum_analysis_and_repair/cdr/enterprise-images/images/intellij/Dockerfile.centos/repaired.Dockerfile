FROM codercom/enterprise-java:centos

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

# Install intellij
RUN mkdir -p /opt/idea
RUN curl -f -L "https://download.jetbrains.com/product?code=IIC&latest&distribution=linux" | tar -C /opt/idea --strip-components 1 -xzvf -

# Add a binary to the PATH that points to the intellij startup script.
RUN ln -s /opt/idea/bin/idea.sh /usr/bin/intellij-idea-ultimate

# Set back to coder user
USER coder
