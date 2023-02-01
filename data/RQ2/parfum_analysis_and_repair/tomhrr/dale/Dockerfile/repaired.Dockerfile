FROM debian:stable

RUN apt-get update && apt-get install --no-install-recommends -y \
    llvm \
    llvm-dev \
    cmake \
    clang \
    pkg-config \
    gdb \
    vim \
    rlwrap \
    zlib1g \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir /build
COPY ./ /build/
WORKDIR /build
ARG Dale_VERSION_REV=0
RUN Dale_VERSION_REV=${Dale_VERSION_REV} \
    cmake \
    -DLLVM_CONFIG=/usr/bin/llvm-config \
    -DCMAKE_BUILD_TYPE=Release \
    .
RUN make -j8
RUN make install
CMD sleep 1 && rlwrap daleci
