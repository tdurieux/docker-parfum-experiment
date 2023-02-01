FROM larskanis/rake-compiler-dock-mri-x86_64-linux:1.2.2

ENV RUBY_TARGET="x86_64-linux" \
    RUST_TARGET="x86_64-unknown-linux-gnu" \
    RUSTUP_DEFAULT_TOOLCHAIN="stable" \
    PKG_CONFIG_ALLOW_CROSS="1" \
    RUSTUP_HOME="/usr/local/rustup" \
    CARGO_HOME="/usr/local/cargo" \
    PATH="/usr/local/cargo/bin:$PATH"

COPY setup/lib.sh /lib.sh

COPY setup/rustup.sh /
RUN /rustup.sh x86_64-unknown-linux-gnu $RUST_TARGET $RUSTUP_DEFAULT_TOOLCHAIN

COPY setup/rubygems.sh /
RUN /rubygems.sh

RUN source /lib.sh && install_packages llvm-toolset-7

ENV LIBCLANG_PATH="/opt/rh/llvm-toolset-7/root/usr/lib64" \
    BINDGEN_EXTRA_CLANG_ARGS="--sysroot=/usr -I/usr/lib/gcc/x86_64-redhat-linux/4.8.2/include"

COPY setup/rubybashrc.sh /
RUN /rubybashrc.sh