FROM ubuntu:rolling

ARG GO_VERSION=1.16
RUN mkdir -p /build \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
        git make curl pkg-config build-essential \
        libpulse-dev libgstreamer1.0 libgstreamer1.0-dev \
        libgstreamer-plugins-bad1.0-dev libgstreamer-plugins-base1.0-dev \
    && curl -f -JLO https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && ln -s /usr/local/go/bin/go /usr/bin/go \
    && rm -f go${GO_VERSION}.linux-amd64.tar.gz && rm -rf /var/lib/apt/lists/*;