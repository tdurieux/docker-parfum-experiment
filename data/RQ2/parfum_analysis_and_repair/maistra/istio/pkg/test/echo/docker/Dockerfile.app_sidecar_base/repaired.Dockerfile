ARG VM_IMAGE_NAME=ubuntu
ARG VM_IMAGE_VERSION=bionic
FROM ${VM_IMAGE_NAME}:${VM_IMAGE_VERSION}
# Dockerfile for different VM OS versions
ENV DEBIAN_FRONTEND=noninteractive

# Do not add more stuff to this list that isn't small or critically useful.
# If you occasionally need something on the container do
# sudo apt-get update && apt-get whichever

# hadolint ignore=DL3005,DL3008
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    iptables \
    iproute2 \
    sudo \
    ca-certificates \
    && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf  /var/log/*log /var/lib/apt/lists/* /var/log/apt/* /var/lib/dpkg/*-old /var/cache/debconf/*-old

# Fix the bug of --to-ports not available.
# Redeclare ARGs to acquire values declared outside of build stage
ARG VM_IMAGE_NAME
ARG VM_IMAGE_VERSION
RUN if [ "$VM_IMAGE_NAME" = "debian" ] && [ "$VM_IMAGE_VERSION" = "10" ]; then \
    update-alternatives --set iptables /usr/sbin/iptables-legacy && \
    update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy; fi

# Add a user that will run the application. This allows running as this user and capture iptables
RUN useradd -m --uid 1338 application && \
    echo "application ALL=NOPASSWD: ALL" >> /etc/sudoers