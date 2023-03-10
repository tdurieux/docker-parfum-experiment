FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04 as base
RUN apt-get update -qy --no-upgrade && \
    apt-get install --no-install-recommends -qy --no-upgrade curl && \
    curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly && rm -rf /var/lib/apt/lists/*;

# build the `dream_go` binary and the `libdg_go.so` library
ENV LIBRARY_PATH /usr/local/cuda/lib64/:/usr/local/cuda/lib64/stubs/
RUN mkdir -p /app/code
COPY .staging/code/. /app/code/
WORKDIR /app/code
RUN ~/.cargo/bin/cargo build --locked --all --release && \
    cp target/release/dream_go /app/dream_go && \
    cp target/release/libdg_go.so /app/libdg_go.so

WORKDIR /app
