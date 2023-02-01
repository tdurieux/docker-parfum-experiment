FROM ubuntu:18.04

# Enviroment
ENV DEBIAN_FRONTEND noninteractive

# Install dependency
RUN set -eux \
    && apt-get update -y \
    && apt-get install --no-install-recommends -y gcc-4.8 \
    && apt-get install --no-install-recommends -y g++-4.8 \
    && apt-get install --no-install-recommends -y debhelper libz-dev libsqlite3-dev default-jdk \
                          default-jre ant tcl rsync zip python3 \
                          systemd-sysv ubuntu-standard \
    && apt-get clean all && rm -rf /var/lib/apt/lists/*;

# Create softlink gcc g++
RUN set -eux \
    && ln -sf /usr/bin/g++-4.8 /usr/bin/g++ \
    && ln -sf /usr/bin/gcc-4.8 /usr/bin/gcc \
