# This two-phase Dockerfile allows us to avoid re-downloading APT packages and wasi-sdk with every
# build.

# First, retrieve wasi-sdk:

FROM ubuntu:18.04 AS builder
WORKDIR /
RUN apt update && apt install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# Download and extract wasi-sdk.
RUN wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-12/wasi-sdk-12.0-linux.tar.gz
RUN tar xvf wasi-sdk-12.0-linux.tar.gz && rm wasi-sdk-12.0-linux.tar.gz

# Second, compile the benchmark to Wasm.

FROM ubuntu:18.04
WORKDIR /
COPY --from=builder /wasi-sdk-12.0 /wasi-sdk-12.0/

# Set common env vars.
ENV CC=/wasi-sdk-12.0/bin/clang
ENV CXX=/wasi-sdk-12.0/bin/clang++
ENV LD=/wasi-sdk-12.0/bin/lld
ENV CFLAGS=--sysroot=/wasi-sdk-12.0/share/wasi-sysroot
ENV CXXFLAGS=--sysroot=/wasi-sdk-12.0/share/wasi-sysroot
ENV PATH /wasi-sdk-12.0

# Compile `benchmark.c` to `./benchmark.wasm`.
COPY benchmark.c .
COPY sightglass.h .
RUN $CC $CFLAGS benchmark.c -O3 -g -DNDEBUG -I. -o benchmark.wasm
