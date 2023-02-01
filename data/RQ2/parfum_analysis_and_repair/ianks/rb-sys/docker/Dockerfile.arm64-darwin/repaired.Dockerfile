FROM larskanis/rake-compiler-dock-mri-arm64-darwin:1.2.2

ENV RUBY_TARGET="arm64-darwin" \
    RUST_TARGET="aarch64-apple-darwin" \
    RUSTUP_DEFAULT_TOOLCHAIN="stable" \
    PKG_CONFIG_ALLOW_CROSS="1" \
    RUSTUP_HOME="/usr/local/rustup" \
    CARGO_HOME="/usr/local/cargo" \
    PATH="/usr/local/cargo/bin:$PATH" \
    LIBCLANG_PATH="/usr/lib/llvm-10/lib/" \
    BINDGEN_EXTRA_CLANG_ARGS="--sysroot=/opt/osxcross/target/SDK/MacOSX11.1.sdk/"

COPY setup/lib.sh /lib.sh

COPY setup/rubybashrc.sh /
RUN /rubybashrc.sh

COPY setup/rustup.sh /
RUN /rustup.sh x86_64-unknown-linux-gnu $RUST_TARGET $RUSTUP_DEFAULT_TOOLCHAIN

COPY setup/rubygems.sh /
RUN /rubygems.sh

RUN bash -c "source /lib.sh && install_packages libclang-dev clang libc6-arm64-cross libc6-dev-arm64-cross"

COPY setup/osxcross-shebang.sh /
RUN /osxcross-shebang.sh