FROM debian:stretch-slim

# https://github.com/rust-lang/docker-rust/blob/29bf41a2cc4fb8d3f588cf51eb6a8ba883808c4b/1.35.0/stretch/slim/Dockerfile

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    CARGO_TARGET_DIR=/opt/target \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.35.0

WORKDIR /opt/
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        gcc \
        build-essential \
        curl \
        libc6-dev \
        wget \
        ; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        amd64) rustArch='x86_64-unknown-linux-gnu'; rustupSha256='a46fe67199b7bcbbde2dcbc23ae08db6f29883e260e23899a88b9073effc9076' ;; \
        armhf) rustArch='armv7-unknown-linux-gnueabihf'; rustupSha256='6af5abbbae02e13a9acae29593ec58116ab0e3eb893fa0381991e8b0934caea1' ;; \
        arm64) rustArch='aarch64-unknown-linux-gnu'; rustupSha256='51862e576f064d859546cca5f3d32297092a850861e567327422e65b60877a1b' ;; \
        i386) rustArch='i686-unknown-linux-gnu'; rustupSha256='91456c3e6b2a3067914b3327f07bc182e2a27c44bff473263ba81174884182be' ;; \
        *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac; \
    url="https://static.rust-lang.org/rustup/archive/1.18.3/${rustArch}/rustup-init"; \
    wget "$url"; \
    echo "${rustupSha256}  *rustup-init" | sha256sum -c -; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain nightly; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version; \
    rustup target add wasm32-wasi --toolchain nightly; \
    curl -f -L https://github.com/WebAssembly/wabt/releases/download/1.0.11/wabt-1.0.11-linux.tar.gz | tar zx; \
        mv wabt-1.0.11/wasm-strip /usr/bin; \
        rm -rf wabt*; \
    wget https://github.com/mozilla/sccache/releases/download/0.2.9/sccache-0.2.9-x86_64-unknown-linux-musl.tar.gz; \
    tar -zxvf sccache-0.2.9-x86_64-unknown-linux-musl.tar.gz; rm sccache-0.2.9-x86_64-unknown-linux-musl.tar.gz \
    mv ./sccache-0.2.9-x86_64-unknown-linux-musl/sccache /usr/bin/sccache; \
    rm -rf sccache*; \
    apt-get remove -y --auto-remove \
        wget \
        ; \
    rm -rf /var/lib/apt/lists/*;




