FROM ubuntu:18.04 as builder
RUN apt-get update
RUN \
  DEBIAN_FRONTEND=noninteractive \
  apt-get --no-install-recommends install -y \
    build-essential autoconf automake libpcre3-dev libevent-dev \
    pkg-config zlib1g-dev libssl-dev libboost-all-dev cmake flex && rm -rf /var/lib/apt/lists/*;
COPY . /memtier_benchmark
WORKDIR /memtier_benchmark
RUN autoreconf -ivf && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

FROM ubuntu:18.04
LABEL Description="memtier_benchmark"
COPY --from=builder /usr/local/bin/memtier_benchmark /usr/local/bin/memtier_benchmark
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
      libevent-dev \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/ && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["memtier_benchmark"]
