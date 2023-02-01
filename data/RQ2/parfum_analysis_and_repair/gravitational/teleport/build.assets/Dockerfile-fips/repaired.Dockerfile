# This Dockerfile makes the FIPS "build box": the container used to build official
# FIPS releases of Teleport and its documentation.

# Use Ubuntu 18.04 as base to get an older glibc version.
# Using a newer base image will build against a newer glibc, which creates a
# runtime requirement for the host to have newer glibc too. For example,
# teleport built on any newer Ubuntu version will not run on Centos 7 because
# of this.
FROM ubuntu:18.04

COPY locale.gen /etc/locale.gen
COPY profile /etc/profile

ENV LANGUAGE="en_US.UTF-8" \
    LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    LC_CTYPE="en_US.UTF-8" \
    DEBIAN_FRONTEND="noninteractive"

RUN apt-get update -y --fix-missing && \
    apt-get -q -y upgrade && \
    apt-get install -y --no-install-recommends apt-utils ca-certificates curl && \
    apt-get install -q -y --no-install-recommends \
        clang-10 \
        clang-format-10 \
        gcc \
        git \
        gzip \
        libc6-dev \
        libelf-dev \
        libpam-dev \
        libsqlite3-0 \
        llvm-10 \
        locales \
        make \
        net-tools \
        openssh-client \
        pkg-config \
        tar \
        tree \
        unzip \
        zip \
        zlib1g-dev \
        && \
    dpkg-reconfigure locales && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

ARG UID
ARG GID
RUN (groupadd ci --gid=$GID -o && useradd ci --uid=$UID --gid=$GID --create-home --shell=/bin/sh && \
     mkdir -p -m0700 /var/lib/teleport && chown -R ci /var/lib/teleport)

# Install etcd.
RUN ( curl -f -L https://github.com/coreos/etcd/releases/download/v3.3.9/etcd-v3.3.9-linux-amd64.tar.gz | tar -xz && \
     cp etcd-v3.3.9-linux-amd64/etcd* /bin/)

# Install Go.
ARG BORINGCRYPTO_RUNTIME
RUN mkdir -p /opt && cd /opt && curl -f https://go-boringcrypto.storage.googleapis.com/${BORINGCRYPTO_RUNTIME}.linux-amd64.tar.gz | tar xz && \
    mkdir -p /go/src/github.com/gravitational/teleport && \
    chmod a+w /go && \
    chmod a+w /var/lib && \
    chmod a-w /
ENV GOPATH="/go" \
    GOROOT="/opt/go" \
    PATH="$PATH:/opt/go/bin:/go/bin:/go/src/github.com/gravitational/teleport/build"

# Install libbpf
ARG LIBBPF_VERSION
RUN mkdir -p /opt && cd /opt && curl -f -L https://github.com/gravitational/libbpf/archive/refs/tags/v${LIBBPF_VERSION}.tar.gz | tar xz && \
    cd /opt/libbpf-${LIBBPF_VERSION}/src && \
    make && \
    make install

# Install PAM module and policies for testing.
COPY pam/ /opt/pam_teleport/
RUN make -C /opt/pam_teleport install

VOLUME ["/go/src/github.com/gravitational/teleport"]
EXPOSE 6600 2379 2380
