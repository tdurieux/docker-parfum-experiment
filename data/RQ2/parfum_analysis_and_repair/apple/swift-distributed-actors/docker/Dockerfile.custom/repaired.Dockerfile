FROM ubuntu:16.04

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && apt-get -q update && \
    apt-get -q --no-install-recommends install -y \
    libatomic1 \
    libcurl3 \
    libxml2 \
    libedit2 \
    libsqlite3-0 \
    libc6-dev \
    binutils \
    libgcc-5-dev \
    libstdc++-5-dev \
    zlib1g-dev \
    libpython3.5 \
    tzdata \
    git \
    pkg-config \
    curl && rm -rf /var/lib/apt/lists/*;

ARG TOOLCHAIN_URL

RUN set -ex; \
    curl -fsSL "$TOOLCHAIN_URL" -o swift.tar.gz \
    && tar -xzf swift.tar.gz --directory /usr --strip-components=1 \
    && chmod -R o+r /usr/lib/swift && rm swift.tar.gz

RUN swift --version
