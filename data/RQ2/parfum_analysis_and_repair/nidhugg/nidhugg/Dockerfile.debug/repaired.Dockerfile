FROM ubuntu:18.04 as build

RUN \
    apt-get update && \
    apt-get --no-install-recommends -y install \
      clang \
      libboost-dev \
      libboost-test-dev \
      libboost-system-dev \
      libc6 \
      libc6-dev \
      libstdc++6 \
      autoconf \
      automake \
      python3 \
      libffi-dev \
      libz-dev \
      xz-utils \
      cmake \
      make && rm -rf /var/lib/apt/lists/*;

ADD https://releases.llvm.org/6.0.1/llvm-6.0.1.src.tar.xz /

RUN \
    /bin/bash -c \
    "cd / && \
     tar xf llvm-6.0.1.src.tar.xz && \
     mkdir /build && \
     cd /build && \
     cmake -DCMAKE_INSTALL_PREFIX=/usr/local/ \
           -DCMAKE_BUILD_TYPE=MinSizeRel      \
           -DLLVM_TARGETS_TO_BUILD=""         \
           -DLLVM_LINK_LLVM_DYLIB=ON          \
           -DLLVM_OPTIMIZED_TABLEGEN=ON       \
           -DLLVM_ENABLE_ASSERTIONS=ON        \
           /llvm-6.0.1.src/ &&                \
     make -j6 &&                              \
     cmake -DCMAKE_INSTALL_PREFIX=/usr/local -P cmake_install.cmake && \
     cd / && rm -r /build/ /llvm-6.0.1.src/ && \
     strip /usr/local/lib/libLLVM-6.0.so /usr/local/bin/llvm-link"

COPY . /nidhugg

RUN \
    /bin/bash -c \
    "cd /nidhugg && \
    autoreconf --install && \
    ./configure --prefix=/usr/local/ --enable-asserts CXXFLAGS='-Og -g' \
                LDFLAGS='-g -Wl,-rpath=/usr/local/lib/' && \
    make -Csrc -j6 nidhugg unittest && \
    make install && \
    install src/unittest /usr/local/bin/nidhugg-unittest && \
    strip /usr/local/bin/nidhugg-unittest"

FROM ubuntu:18.04
RUN \
    apt-get update && \
    apt-get --no-install-recommends -y install \
      clang \
      libboost-system1.65.1 \
      libboost-test1.65.1 \
      python3 \
      vim-tiny && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=build /usr/local/lib/libLLVM-6.0.so /usr/local/lib/
COPY --from=build /usr/local/bin/llvm-link /usr/local/bin/
COPY --from=build /usr/local/bin/nidhugg* /usr/local/bin/
WORKDIR /root
