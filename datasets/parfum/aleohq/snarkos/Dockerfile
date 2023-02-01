FROM ubuntu:18.04 AS builder
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    DEBIAN_FRONTEND=noninteractive
RUN set -eux ; \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        gcc \
        libc6-dev \
        wget \
        build-essential \
        clang \
        gcc \
        libssl-dev \
        make \
        pkg-config \
        xz-utils && \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        amd64) rustArch='x86_64-unknown-linux-gnu' ;; \
        arm64) rustArch='aarch64-unknown-linux-gnu' ;; \
        *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac; \
    \
    url="https://static.rust-lang.org/rustup/dist/${rustArch}/rustup-init"; \
    wget "$url"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain stable; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version; \
    apt-get remove -y --auto-remove wget && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*;
WORKDIR /usr/src/snarkOS
COPY . .
RUN cargo build --release
FROM ubuntu:18.04
SHELL ["/bin/bash", "-c"]
VOLUME ["/aleo/data"]
RUN set -ex && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y -o DPkg::Options::=--force-confold && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates curl jq && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /aleo/{bin,data} && \
    mkdir /usr/local/cargo
COPY --from=builder /usr/src/snarkOS/target/release/snarkos /aleo/bin/
COPY --from=builder /usr/src/snarkOS/start /aleo/
CMD ["/aleo/start"]