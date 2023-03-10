FROM ubuntu:bionic
RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-utils \
    clang \
    cmake \
    curl \
    git \
    libc++-dev \
    libc++abi-dev \
    libglib2.0-dev \
    libgmp-dev \
    ninja-build \
    python && rm -rf /var/lib/apt/lists/*;
ADD . /code/wasm-c-api
WORKDIR /code/wasm-c-api
RUN make v8-checkout
RUN make -j v8
RUN make
