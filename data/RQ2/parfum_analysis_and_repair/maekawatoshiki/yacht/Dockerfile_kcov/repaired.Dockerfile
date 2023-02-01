FROM rustlang/rust:nightly

RUN set -x && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends zlib1g-dev apt-utils -y && \
  apt-get install --no-install-recommends opt libedit-dev build-essential make libgc-dev -y; \
  apt-get install --no-install-recommends software-properties-common -y; rm -rf /var/lib/apt/lists/*;

RUN set -x && \
  apt-add-repository -y "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch-6.0 main" && \
  wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|apt-key add - && \
  apt-get update && \
  apt-get install --no-install-recommends -y llvm-6.0 && \
  ln -s /usr/bin/llvm-config-6.0 /usr/bin/llvm-config; rm -rf /var/lib/apt/lists/*;

RUN set -x && \
  apt-get install --no-install-recommends -y cmake g++ pkg-config jq && \
  apt-get install --no-install-recommends -y libcurl4-openssl-dev libelf-dev libdw-dev binutils-dev libiberty-dev && \
  cargo install cargo-kcov && \
  cargo kcov --print-install-kcov-sh | sh && rm -rf /var/lib/apt/lists/*;

ADD . /opt/rapidus

WORKDIR /opt/rapidus

RUN set -x && \
  export PATH=~/.cargo/bin:$PATH && \
  export PATH=~/usr/local/bin:$PATH && \
  rustup override set nightly
