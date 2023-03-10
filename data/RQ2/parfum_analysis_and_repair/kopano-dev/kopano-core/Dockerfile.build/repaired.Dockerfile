# SPDX-License-Identifier: LGPL-3.0-or-later
# Copyright 2019, Kopano and its licensors

# Kopano Groupware Core Dockerfile
#
# Build command:
# `docker build . -f Dockerfile.build -t kopanocore-builder`
#
# Run command:
# `docker run -it --rm -v $(pwd):/build -u $(id -u) kopanocore-builder`

FROM debian:buster

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Build args
ARG DEPENDENCY_HASH=51c3a68
ARG CONFIGURE_ARGS=--enable-kcoidc
ARG EXTRA_PACKAGES=

# Noninteractive for package manager
ENV DEBIAN_FRONTEND noninteractive

# Lang for tests
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install curl before adding dependency-repository
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    apt-utils \
    curl \
    gnupg2 && rm -rf /var/lib/apt/lists/*;

# Get kopano-dependencies and create local repository
RUN curl -f -sSL https://download.kopano.io/community/dependencies:/kopano-dependencies-${DEPENDENCY_HASH}-Debian_10-amd64.tar.gz | \
    tar -C /var/local/ -vxzf - && \
    cd /var/local/kopano-dependencies/ && \
    apt-ftparchive packages . | gzip -c9 > Packages.gz && \
    echo "deb [trusted=yes] file:/var/local/kopano-dependencies ./" > /etc/apt/sources.list.d/local.list

# Install buildttime dependencies
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        autotools-dev \
        binutils \
        debhelper \
        devscripts \
        dh-systemd \
        flake8 \
        g++ \
        gettext \
        gsoap \
        libcurl4-openssl-dev \
        libgoogle-perftools-dev \
        libgsoap-dev \
        libhx-dev \
        libical-dev \
        libicu-dev \
        libjsoncpp-dev \
        libkcoidc-dev \
        libkrb5-dev \
        libldap2-dev \
        libmariadbclient-dev \
        libncurses-dev \
        libpam0g-dev \
        librrd-dev \
        libs3-dev \
        libssl-dev \
        libtool \
        libtool-bin \
        libvmime-dev \
        libxml2-dev \
        lsb-release \
        m4 \
        php-dev \
        pkg-config \
        python3-dateutil \
        python3-dev \
        python3-pillow \
        python3-pytest \
        python3-setuptools \
        python3-tz \
        python3-tzlocal \
        swig \
        tidy-html5-dev \
        uuid-dev \
        zlib1g-dev \
        $EXTRA_PACKAGES \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
ENV WORKSPACE=/build
WORKDIR ${WORKSPACE}

# Create build user
RUN groupadd -r -g 1000 builder && useradd -l -r -u 1000 -g builder builder

COPY test/docker-entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/*.sh

USER builder

ENTRYPOINT ["docker-entrypoint.sh"]

ENV CONFIGURE_ARGS $CONFIGURE_ARGS

# Default command (requires mounting kopanocore directory to /build/)
CMD ./bootstrap.sh && PYTHON=/usr/bin/python3 ./configure $CONFIGURE_ARGS && make -j $(nproc)
