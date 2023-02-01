FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y llvm-11 clang-11 lld-11 nodejs && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/wasm-ld-11 /usr/bin/wasm-ld

WORKDIR /src
