ARG RCD_VERSION=1.2.1
FROM larskanis/rake-compiler-dock-mri-x86_64-linux:${RCD_VERSION}

ENV RUBY_TARGET="x86_64-linux" \
    RUST_TARGET="x86_64-unknown-linux-gnu" \
    PKG_CONFIG_ALLOW_CROSS="1" \
    RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH="/usr/local/cargo/bin:$PATH" \
    LIBCLANG_PATH="/opt/rh/llvm-toolset-7/root/usr/lib64" \
    BINDGEN_EXTRA_CLANG_ARGS="--sysroot=/usr -I/usr/lib/gcc/x86_64-redhat-linux/4.8.2/include"

COPY rust.sh /
RUN /rust.sh "$RUST_TARGET" && rm /rust.sh

COPY rubybashrc.sh /
RUN /rubybashrc.sh && rm /rubybashrc.sh

RUN yum install -y llvm-toolset-7 && yum clean all && rm -rf /var/cache/yum
