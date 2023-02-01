FROM alpine

RUN apk add --no-cache curl bash gcc libc6-compat musl-dev git
RUN curl -o rustup.sh --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs
RUN sh rustup.sh -y --default-host=x86_64-unknown-linux-musl --default-toolchain=stable
RUN /root/.cargo/bin/rustup install nightly-x86_64-unknown-linux-musl
