FROM arm64v8/debian:buster-slim as builder

COPY --from=multiarch/qemu-user-static:x86_64-aarch64 /usr/bin/qemu-aarch64-static /usr/bin/qemu-aarch64-static

# Fluent Bit version
ENV FLB_MAJOR 1
ENV FLB_MINOR 7
ENV FLB_PATCH 1
ENV FLB_VERSION 1.7.1

ARG FLB_TARBALL=https://github.com/fluent/fluent-bit/archive/v$FLB_VERSION.tar.gz
ENV FLB_SOURCE $FLB_TARBALL
RUN mkdir -p /fluent-bit/bin /fluent-bit/etc /fluent-bit/log /tmp/fluent-bit-master/

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    ca-certificates \
    cmake \
    make \
    tar \
    libssl-dev \
    libsasl2-dev \
    pkg-config \
    libsystemd-dev \
    zlib1g-dev \
    libpq-dev \
    postgresql-server-dev-all \
    flex \
    bison \
    && curl -f -L -o "/tmp/fluent-bit.tar.gz" ${FLB_SOURCE} \
    && cd tmp/ && mkdir fluent-bit \
    && tar zxfv fluent-bit.tar.gz -C ./fluent-bit --strip-components=1 \
    && cd fluent-bit/build/ \
    && rm -rf /tmp/fluent-bit/build/* && rm fluent-bit.tar.gz && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp/fluent-bit/build/
RUN cmake -DFLB_RELEASE=On \
          -DFLB_TRACE=Off \
          -DFLB_JEMALLOC=On \
          -DFLB_TLS=On \
          -DFLB_SHARED_LIB=Off \
          -DFLB_EXAMPLES=Off \
          -DFLB_HTTP_SERVER=On \
          -DFLB_IN_SYSTEMD=On \
          -DFLB_OUT_KAFKA=On \
          -DFLB_OUT_PGSQL=On ..

RUN make -j $(getconf _NPROCESSORS_ONLN)
RUN install bin/fluent-bit /fluent-bit/bin/

# Configuration files
COPY conf/fluent-bit.conf \
     conf/parsers.conf \
     conf/parsers_ambassador.conf \
     conf/parsers_java.conf \
     conf/parsers_extra.conf \
     conf/parsers_openstack.conf \
     conf/parsers_cinder.conf \
     conf/plugins.conf \
     /fluent-bit/etc/

FROM arm64v8/debian:buster-slim
COPY --from=builder /usr/bin/qemu-aarch64-static /usr/bin/qemu-aarch64-static

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      libssl1.1 \
      libsasl2-2 \
      pkg-config \
      libpq5 \
      libsystemd0 \
      zlib1g \
      ca-certificates && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /fluent-bit /fluent-bit

RUN rm /usr/bin/qemu-aarch64-static

#
EXPOSE 2020

# Entry point
CMD ["/fluent-bit/bin/fluent-bit", "-c", "/fluent-bit/etc/fluent-bit.conf"]
