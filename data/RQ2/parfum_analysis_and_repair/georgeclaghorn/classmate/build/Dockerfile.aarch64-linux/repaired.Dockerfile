ARG RCD_VERSION=1.2.1
FROM larskanis/rake-compiler-dock-mri-aarch64-linux:${RCD_VERSION}

ENV RUBY_TARGET="aarch64-linux" \
    RUST_TARGET="aarch64-unknown-linux-gnu" \
    PKG_CONFIG_ALLOW_CROSS="1" \
    RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH="/usr/local/cargo/bin:$PATH" \
    LIBCLANG_PATH="/usr/lib/llvm-10/lib" \
    BINDGEN_EXTRA_CLANG_ARGS="--sysroot=/usr/aarch64-linux-gnu -fdeclspec"

COPY rust.sh /
RUN /rust.sh "$RUST_TARGET" && rm /rust.sh

COPY rubybashrc.sh /
RUN /rubybashrc.sh && rm /rubybashrc.sh

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      clang \
      libclang-dev \
      llvm-dev \
      libc6-arm64-cross \
      libc6-dev-arm64-cross && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives