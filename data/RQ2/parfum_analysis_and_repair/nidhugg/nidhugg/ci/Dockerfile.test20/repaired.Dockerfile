FROM ubuntu:20.04 as build
ARG LLVM_VERSION=13.0.0

COPY ci/install_deps.sh /ci/
RUN \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC \
      apt-get --no-install-recommends -y install \
      libboost-dev \
      libboost-test-dev \
      libboost-system-dev \
      libc6 \
      libc6-dev \
      libstdc++6 \
      g++ \
      autoconf \
      automake \
      python3 \
      libffi-dev \
      libz-dev \
      libtinfo-dev \
      libxml2-dev \
      wget ca-certificates \
      xz-utils \
      make && \
    /ci/install_deps.sh && rm -rf /var/lib/apt/lists/*;

COPY . /nidhugg

RUN \
    /bin/bash -c \
    "cd /nidhugg && \
     autoreconf --install && \
     (CC=/opt/clang+llvm-$LLVM_VERSION/bin/clang \
      CXX=/opt/clang+llvm-$LLVM_VERSION/bin/clang++ \
      ./configure --prefix=/usr/local/ --with-llvm=/opt/clang+llvm-$LLVM_VERSION || (cat config.log; false)) && \
     make -Csrc -j`nproc` all unittest"

CMD make -C /nidhugg -j3 test
