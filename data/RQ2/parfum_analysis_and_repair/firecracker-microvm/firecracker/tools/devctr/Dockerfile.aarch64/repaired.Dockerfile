FROM ubuntu:18.04

# TODO: use a multi-stage build to reduce the download size when updating this container.
# The Rust toolchain layer will get updated most frequently, but we could keep the system
# dependencies layer intact for much longer.

ARG RUST_TOOLCHAIN="1.52.1"
ARG TINI_VERSION_TAG="v0.18.0"
ARG TMP_BUILD_DIR=/tmp/build
ARG TMP_POETRY_DIR
ARG FIRECRACKER_SRC_DIR="/firecracker"
ARG FIRECRACKER_BUILD_DIR="$FIRECRACKER_SRC_DIR/build"
ARG CARGO_REGISTRY_DIR="$FIRECRACKER_BUILD_DIR/cargo_registry"
ARG CARGO_GIT_REGISTRY_DIR="$FIRECRACKER_BUILD_DIR/cargo_git_registry"
ARG DEBIAN_FRONTEND=noninteractive
# By default we don't provide a poetry.lock file
ARG POETRY_LOCK_PATH="/dev/null/*"

ENV CARGO_HOME=/usr/local/rust
ENV RUSTUP_HOME=/usr/local/rust
ENV PATH="$PATH:$CARGO_HOME/bin"
ENV LC_ALL=C.UTF-8

# Install system dependencies
#
RUN apt-get update \
    && apt-get -y install --no-install-recommends \
        binutils-dev \
        # Needed in order to be able to compile `userfaultfd-sys`.
        clang \
        cmake \
        curl \
        file \
        g++ \
        gcc \
        git \
        iperf3 \
        iproute2 \
        jq \
        libbfd-dev \
        libcurl4-openssl-dev \
        libdw-dev \
        libfdt-dev \
        libiberty-dev \
        libssl-dev \
        lsof \
        make \
        musl-tools \
        net-tools \
        openssh-client \
        pkgconf \
        python \
        python3 \
        python3-dev \
        python3-pip \
        python3-venv    \
        zlib1g-dev \
        screen \
        tzdata \
        xz-utils \
        bc \
        flex \
        bison \
        build-essential \
        zlib1g-dev \
        libncurses5-dev \
        libgdbm-dev \
        libnss3-dev \
        libssl-dev \
        libreadline-dev \
        libffi-dev \
        wget \
    && python3 -m pip install \
        setuptools \
        setuptools_rust \
        wheel \
    && python3 -m pip install --upgrade pip \
    && rm -rf /var/lib/apt/lists/*

# Update Python to 3.10
# This method isn't ideal, compiling from source can be dropped
# once the container definition is based on ubuntu:22.04
RUN wget https://www.python.org/ftp/python/3.10.4/Python-3.10.4.tgz \
    && tar -xf Python-3.10.4.tgz \
    && cd ./Python-3.10.4 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations \
    && make -j 8 \
    && make install && rm Python-3.10.4.tgz

RUN python3 -m pip install poetry
RUN mkdir "$TMP_POETRY_DIR"
COPY tools/devctr/pyproject.toml $POETRY_LOCK_PATH "$TMP_POETRY_DIR/"
RUN cd "$TMP_POETRY_DIR" \
    &&  poetry config virtualenvs.create false \
    &&  poetry install --no-dev --no-interaction

# Install the Rust toolchain
#
RUN mkdir "$TMP_BUILD_DIR" \
    && curl https://sh.rustup.rs -sSf | sh -s -- -y --profile minimal --default-toolchain "$RUST_TOOLCHAIN" \
        && rustup target add aarch64-unknown-linux-musl \
        && cd "$TMP_BUILD_DIR" \
                    && cargo install cargo-kcov \
                    && cargo kcov --print-install-kcov-sh | sh \
        && rm -rf "$CARGO_HOME/registry" \
        && ln -s "$CARGO_REGISTRY_DIR" "$CARGO_HOME/registry" \
        && rm -rf "$CARGO_HOME/git" \
        && ln -s "$CARGO_GIT_REGISTRY_DIR" "$CARGO_HOME/git" \
    && cd / \
    && rm -rf "$TMP_BUILD_DIR"

RUN ln -s /usr/bin/musl-gcc /usr/bin/aarch64-linux-musl-gcc

# help musl-gcc find linux headers
RUN cd /usr/include/aarch64-linux-musl \
    && ln -s ../aarch64-linux-gnu/asm asm \
    && ln -s ../linux linux \
    && ln -s ../asm-generic asm-generic

# Build iperf3-vsock
RUN mkdir "$TMP_BUILD_DIR" && cd "$TMP_BUILD_DIR" \
    && git clone https://github.com/stefano-garzarella/iperf-vsock \
    && cd iperf-vsock && git checkout 9245f9a \
    && mkdir build && cd build \
    && ../configure "LDFLAGS=--static" --disable-shared && make \
    && cp src/iperf3 /usr/local/bin/iperf3-vsock \
    && cd / \
    && rm -rf "$TMP_BUILD_DIR"

# Add the tini init binary.
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION_TAG}/tini-static-arm64 /sbin/tini
RUN chmod +x /sbin/tini

WORKDIR "$FIRECRACKER_SRC_DIR"
ENTRYPOINT ["/sbin/tini", "--"]
