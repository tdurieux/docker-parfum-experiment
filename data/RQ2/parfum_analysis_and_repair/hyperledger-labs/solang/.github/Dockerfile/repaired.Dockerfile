FROM ubuntu:20.04 as builder

LABEL org.opencontainers.image.licenses="Apache-2.0" \
    org.opencontainers.image.description="CI container for github actions"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install --no-install-recommends -y libz-dev pkg-config libssl-dev git cmake ninja-build gcc g++ python3 && rm -rf /var/lib/apt/lists/*;

RUN git clone --single-branch --branch solana-rustc/13.0-2021-08-08 \
    https://github.com/solana-labs/llvm-project.git

WORKDIR /llvm-project

RUN cmake -G Ninja -DLLVM_ENABLE_ASSERTIONS=On -DLLVM_ENABLE_TERMINFO=Off \
    -DLLVM_ENABLE_PROJECTS=clang\;lld \
    -DLLVM_TARGETS_TO_BUILD=WebAssembly\;BPF \
    -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=/llvm13.0 llvm

RUN cmake --build . --target install

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install --no-install-recommends -y zlib1g-dev pkg-config libssl-dev git libffi-dev curl gcc g++ make && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
RUN apt-get autoclean

# Get Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y --default-toolchain 1.59.0

COPY --from=builder /llvm13.0 /llvm13.0/

ENV PATH="/llvm13.0/bin:/root/.cargo/bin:${PATH}"
