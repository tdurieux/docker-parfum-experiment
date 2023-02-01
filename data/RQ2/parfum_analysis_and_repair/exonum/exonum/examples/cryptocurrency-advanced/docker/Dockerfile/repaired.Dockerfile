FROM ubuntu:18.04

ENV ROCKSDB_LIB_DIR=/usr/lib
ENV SNAPPY_LIB_DIR=/usr/lib/x86_64-linux-gnu

RUN apt-get update \
    && apt-get install --no-install-recommends -y software-properties-common \
    && add-apt-repository ppa:exonum/rocksdb \
    && add-apt-repository ppa:maarten-fonville/protobuf \
    && apt-get update \
    && apt-get install --no-install-recommends -y curl git \
    build-essential libsodium-dev libsnappy-dev \
    librocksdb-dev pkg-config clang-7 lldb-7 lld-7 \
    libprotobuf-dev protobuf-compiler && rm -rf /var/lib/apt/lists/*;

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain=stable

RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash \
  && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src
RUN git clone --branch v1.0.0 https://github.com/exonum/exonum.git \
  && mv /root/.cargo/bin/* /usr/bin \
  && cd exonum/examples/cryptocurrency-advanced/backend \
  && cargo update && cargo install --path . \
  && cd ../frontend && npm install && npm run build && npm cache clean --force;
WORKDIR /usr/src/exonum/examples/cryptocurrency-advanced
COPY launch.sh .

ENTRYPOINT ["./launch.sh"]
