ARG RCD_VERSION=1.2.1
FROM larskanis/rake-compiler-dock-mri-x86_64-darwin:${RCD_VERSION}

ENV RUBY_TARGET="x86_64-darwin" \
    RUST_TARGET="x86_64-apple-darwin" \
    PKG_CONFIG_ALLOW_CROSS="1" \
    RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH="/usr/local/cargo/bin:$PATH" \
    LIBCLANG_PATH="/usr/lib/llvm-10/lib" \
    BINDGEN_EXTRA_CLANG_ARGS="-I/usr/include/x86_64-linux-gnu/"

COPY rust.sh /
RUN /rust.sh "$RUST_TARGET" && rm /rust.sh

COPY rubybashrc.sh /
RUN /rubybashrc.sh && rm /rubybashrc.sh

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends clang libclang-dev && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives