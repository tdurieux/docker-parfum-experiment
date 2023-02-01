FROM golang AS builder
LABEL maintainer="lotus Docker Maintainers https://fuckcloudnative.io"

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.46.0 \
    LOTUS_REP=https://github.com/filecoin-project/lotus.git \
    BRANCH=master \
    COMMIT=HEAD \
    REPO_DIR=lotus

RUN apt update; \
    apt install --no-install-recommends -y mesa-opencl-icd ocl-icd-opencl-dev gcc git bzr jq pkg-config curl clang; rm -rf /var/lib/apt/lists/*; \
    apt upgrade -y


# Install Rust
RUN set -eux; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        amd64) rustArch='x86_64-unknown-linux-gnu'; rustupSha256='49c96f3f74be82f4752b8bffcf81961dea5e6e94ce1ccba94435f12e871c3bdb' ;; \
        armhf) rustArch='armv7-unknown-linux-gnueabihf'; rustupSha256='5a2be2919319e8778698fa9998002d1ec720efe7cb4f6ee4affb006b5e73f1be' ;; \
        arm64) rustArch='aarch64-unknown-linux-gnu'; rustupSha256='d93ef6f91dab8299f46eef26a56c2d97c66271cea60bf004f2f088a86a697078' ;; \
        i386) rustArch='i686-unknown-linux-gnu'; rustupSha256='e3d0ae3cfce5c6941f74fed61ca83e53d4cd2deb431b906cbd0687f246efede4' ;; \
        *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac; \
    url="https://static.rust-lang.org/rustup/archive/1.22.1/${rustArch}/rustup-init"; \
    wget "$url"; \
    echo "${rustupSha256}  *rustup-init" | sha256sum -c -; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION --default-host ${rustArch}; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

# Get lotus
RUN git clone --depth=1 -b $BRANCH $LOTUS_REP $REPO_DIR; \
    cd $REPO_DIR; \
    git checkout $COMMIT; \
    git submodule init; \
    git submodule update; \
    sed -i 's/"check_cpu_for_feature": null/"check_cpu_for_feature": "sha_ni"/g' extern/filecoin-ffi/rust/rustc-target-features-optimized.json; \
    env RUSTFLAGS='-C target-cpu=native -g' FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1 FIL_PROOFS_USE_GPU_TREE_BUILDER=1 FFI_BUILD_FROM_SOURCE=1 make clean && make lotus;

RUN curl -f -sOL https://github.com/krallin/tini/releases/download/v0.19.0/tini; \
    chmod +x tini;

FROM debian:buster-slim
LABEL maintainer="lotus Docker Maintainers https://fuckcloudnative.io"

ENV FIL_PROOFS_PARAMETER_CACHE=/proofs \
    LOTUS_PATH=/lotus/lotus-daemon \
    RUST_LOG=Info

RUN mkdir -p $LOTUS_PATH

# Certs
COPY --from=builder /etc/ssl/certs /etc/ssl/certs

# Required libs
COPY --from=builder /usr/lib/x86_64-linux-gnu/libdl.so /lib/libdl.so.2
COPY --from=builder /usr/lib/x86_64-linux-gnu/libutil.so /lib/libutil.so.1
COPY --from=builder /usr/lib/x86_64-linux-gnu/librt.so /lib/librt.so.1
COPY --from=builder /usr/lib/gcc/x86_64-linux-gnu/8/libgcc_s.so.1 /lib/libgcc_s.so.1
COPY --from=builder /usr/lib/x86_64-linux-gnu/libOpenCL.so.1 /lib/libOpenCL.so.1
COPY --from=builder /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /lib/libstdc++.so.6

# PID1 tini
COPY --from=builder /go/tini /usr/local/bin/tini

# Lotus bin
COPY --from=builder /go/$REPO_DIR/lotus/lotus /usr/local/bin/lotus
COPY config.toml $LOTUS_PATH/config.toml

# Lotus sync port
EXPOSE 2333

# Lotus home && proofs (optional)
# VOLUME /lotus
# VOLUME /proofs

ENTRYPOINT ["tini", "--"]

# Run lotus daemon
CMD ["lotus", "daemon"]
