FROM BASE_IMAGE

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain RUST_TOOLCHAIN

# .cargo/bin in PATH is needed for running cargo, rustup etc.
ENV PATH=/root/.cargo/bin:$PATH

# A tool for visualizing Rust build dependencies. Handy for debugging the build inside the container.
RUN cargo install cargo-tree

# Installing the musl target!
RUN rustup target add x86_64-unknown-linux-musl

# SETTING THE ENV VARS FOR MUSL BUILDS - WHY THESE?
# PKG_CONFIG_PATH Some of the build.rs script of *-sys crates use pkg-config to probe for libs.
# PKG_CONFIG_ALLOW_CROSS This tells the rust pkg-config crate to be enabled even when cross-compiling
# PKG_CONFIG_ALL_STATIC This tells the rust pkg-config crate to statically link the native dependencies
# The pq-sys crate doesn't use PKG_CONFIG, and we must manually pass PQ_LIB_STATIC for it to link statically.
# PATH /musl/bin is needed because the build.rs of pq-sys runs a postgres binary pg_config from there that tells it the lib dir.

ENV PATH=$MUSL_PREFIX/bin:$PATH \
    PKG_CONFIG_ALLOW_CROSS=true \
    PKG_CONFIG_ALL_STATIC=true \
    PKG_CONFIG_PATH=$MUSL_PREFIX/lib/pkgconfig \
    PQ_LIB_STATIC_X86_64_UNKNOWN_LINUX_MUSL=true \
    PG_CONFIG_X86_64_UNKNOWN_LINUX_GNU=/usr/bin/pg_config \ 
    OPENSSL_STATIC=true \
    OPENSSL_DIR=$MUSL_PREFIX \
    SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
    SSL_CERT_DIR=/etc/ssl/certs \
    LIBZ_SYS_STATIC=1
    
WORKDIR /workdir