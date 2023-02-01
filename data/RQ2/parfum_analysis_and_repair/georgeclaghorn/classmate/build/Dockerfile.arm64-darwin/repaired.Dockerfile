ARG RCD_VERSION=1.2.1
FROM larskanis/rake-compiler-dock-mri-arm64-darwin:${RCD_VERSION}

ENV RUBY_TARGET="arm64-darwin" \
    RUST_TARGET="aarch64-apple-darwin" \
    PKG_CONFIG_ALLOW_CROSS="1" \
    RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH="/usr/local/cargo/bin:$PATH" \
    LIBCLANG_PATH="/usr/lib/llvm-10/lib/" \
    BINDGEN_EXTRA_CLANG_ARGS="--sysroot=/opt/osxcross/target/SDK/MacOSX11.1.sdk/"

COPY rust.sh /
RUN /rust.sh "$RUST_TARGET" && rm /rust.sh

COPY rubybashrc.sh /
RUN /rubybashrc.sh && rm /rubybashrc.sh

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      clang \
      libclang-dev \
      libc6-arm64-cross \
      libc6-dev-arm64-cross && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives