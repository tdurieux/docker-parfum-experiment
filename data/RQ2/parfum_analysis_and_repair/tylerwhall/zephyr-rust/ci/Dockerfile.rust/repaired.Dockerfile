ARG ZEPHYR_VERSION
FROM zephyr:${ZEPHYR_VERSION}

ARG RUST_VERSION

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=${RUST_VERSION}

RUN apt-get install --no-install-recommends -y clang && rm -rf /var/lib/apt/lists/*;
RUN set -eux; \
    wget https://sh.rustup.rs -O rustup.sh; \
    sh rustup.sh -y --no-modify-path --profile minimal --default-toolchain ${RUST_VERSION}; \
    rm rustup.sh; \
    rustup --version; \
    cargo --version; \
    rustc --version;
RUN set -eux; \
    ln -sf ${CARGO_HOME}/bin/cargo /usr/bin/cargo; \
    ln -sf ${CARGO_HOME}/bin/rustup /usr/bin/rustup; \
    ln -sf ${CARGO_HOME}/bin/rustc /usr/bin/rustc;
