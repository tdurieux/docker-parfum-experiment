# Create a virtual environment with all tools installed
# ref: https://quay.io/repository/centos/centos
FROM quay.io/centos/centos:stream AS env
LABEL maintainer="corentinl@google.com"
# Install system build dependencies
ENV PATH=/usr/local/bin:$PATH
RUN dnf -y update \
&& dnf -y install git wget gcc-toolset-11 \
&& dnf clean all \
&& rm -rf /var/cache/dnf

RUN echo "source /opt/rh/gcc-toolset-11/enable" >> /etc/bashrc
SHELL ["/bin/bash", "--login", "-c"]

# Install bazel 5
# see: https://docs.bazel.build/versions/master/install-redhat.html#installing-on-centos-7