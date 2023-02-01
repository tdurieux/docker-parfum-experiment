FROM debian:buster-slim

ENV DEBIAN_FRONTEND noninteractive
ENV CCACHE_DIR "/var/spool/ccache"
ENV CCACHE_COMPRESS 1

ENV CMAKE_DIR "/opt/cmake"
ENV CMAKE_VERSION "3.19.1"

ENV PATH "${CMAKE_DIR}/bin:${PATH}"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# configure system for build
RUN echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list && \
    apt-get -q update && \
    apt-get install -q -y -t buster-backports --no-install-recommends \
        binutils \
        bison \
        ccache \
        file \
        flex \
        g++ \
        git \
        google-perftools \
        jq \
        libfl-dev \
        libgoogle-perftools-dev \
        libkrb5-dev \
        libmaxminddb-dev \
        libpcap0.8-dev \
        libssl-dev \
        locales-all \
        make \
        ninja-build \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        swig \
        zlib1g-dev && \
  # Downgrade libcurl3, per https://superuser.com/questions/1642858/git-on-debian-10-backports-throws-fatal-unable-to-access-https-github-com-us
  apt-get install -q -y -t buster-backports --no-install-recommends --allow-downgrades libcurl3-gnutls=7.64.0-4+deb10u2 && \
  pip3 install --no-cache-dir "btest>=0.66" pre-commit && \
  # recent CMake
  mkdir -p "${CMAKE_DIR}" && \
    curl -f -sSL "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz" | tar xzf - -C "${CMAKE_DIR}" --strip-components 1 && rm -rf /var/lib/apt/lists/*;

WORKDIR /root
