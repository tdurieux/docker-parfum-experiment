FROM debian:unstable-slim AS builder

RUN echo "deb-src http://deb.debian.org/debian unstable main" >> \
        /etc/apt/sources.list.d/deb-src.list && \
    apt update && apt install -y --no-install-recommends \
        gcc make patch autoconf automake libtool pkg-config \
        libjson-c-dev uuid-dev curl ca-certificates && rm -rf /var/lib/apt/lists/*;

ARG ACCEL_CONFIG_VERSION="3.4.6.4"
ARG ACCEL_CONFIG_DOWNLOAD_URL="https://github.com/intel/idxd-config/archive/accel-config-v$ACCEL_CONFIG_VERSION.tar.gz"
ARG ACCEL_CONFIG_SHA256="5f9ee68f51913d803b9b0e51cdadaff14ea1523f6e9e4d4ab3e85de644ba6d21"

RUN curl -fsSL "$ACCEL_CONFIG_DOWNLOAD_URL" -o accel-config.tar.gz && \
    echo "$ACCEL_CONFIG_SHA256  accel-config.tar.gz" | sha256sum -c - && \
    tar -xzf accel-config.tar.gz && rm accel-config.tar.gz

RUN cd idxd-config-accel-config-v$ACCEL_CONFIG_VERSION && \
    ./git-version-gen && \
    autoreconf -i && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" -q --libdir=/usr/lib64 --disable-test --disable-docs && \
    make && \
    make install
###
FROM debian:unstable-slim

RUN apt update && apt install --no-install-recommends -y libjson-c5 jq && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /usr/lib64/libaccel-config.so.1.0.0 "/lib/x86_64-linux-gnu/"
RUN ldconfig && mkdir -p /licenses/accel-config

COPY --from=builder /usr/bin/accel-config /usr/bin/
COPY --from=builder /accel-config.tar.gz /licenses/accel-config/

ADD demo/idxd-init.sh /usr/local/bin/
ADD demo/dsa.conf /idxd-init/
ADD demo/iax.conf /idxd-init/

RUN mkdir /idxd-init/scratch

WORKDIR /idxd-init
ENTRYPOINT bash /usr/local/bin/idxd-init.sh
