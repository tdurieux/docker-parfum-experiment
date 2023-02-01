FROM rustlang/rust:nightly

RUN set -x && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends zlib1g-dev apt-utils -y && \
  apt-get install --no-install-recommends opt libedit-dev build-essential make -y; \
  apt-get install --no-install-recommends software-properties-common -y; rm -rf /var/lib/apt/lists/*;

RUN set -x && \
  apt-get install --no-install-recommends -y cmake g++ clang pkg-config jq && \
  apt-get install --no-install-recommends -y libcurl4-openssl-dev libelf-dev libdw-dev binutils-dev libiberty-dev && \
  cargo install cargo-kcov && \
  cargo kcov --print-install-kcov-sh | sh && rm -rf /var/lib/apt/lists/*;

ADD . /opt/sericum

WORKDIR /opt/sericum

RUN set -x && \
  export PATH=~/.cargo/bin:$PATH && \
  export PATH=~/usr/local/bin:$PATH && \
  rustup override set nightly
