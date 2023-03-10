# This image containts all tools required for building the drakvuf-bundle:
# Xen, LibVMI and DRAKVUF
FROM debian:buster

# DRAKVUF build deps
RUN echo "deb-src http://deb.debian.org/debian buster main" >> /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y build-essential git wget curl cmake flex bison libjson-c-dev autoconf-archive clang python3-dev gcc-7 g++-7 lsb-release patch libsystemd-dev nasm bc && rm -rf /var/lib/apt/lists/*;

# Install Golang
RUN wget -q -O /usr/local/go1.15.3.linux-amd64.tar.gz https://golang.org/dl/go1.15.3.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf /usr/local/go1.15.3.linux-amd64.tar.gz && rm /usr/local/go1.15.3.linux-amd64.tar.gz

# Xen deps
RUN apt-get -y build-dep xen

RUN ln -sf /usr/bin/gcc-7 /usr/bin/gcc && \
    ln -sf /usr/bin/g++-7 /usr/bin/g++

COPY ./*.sh /scripts/
ENTRYPOINT ["/scripts/custom_bundle.sh"]
