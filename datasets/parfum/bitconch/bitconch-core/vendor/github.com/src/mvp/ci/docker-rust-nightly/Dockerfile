FROM solanalabs/rust
ARG date

RUN set -x && \
    rustup install nightly-$date && \
    rustup default nightly-$date && \
    rustup component add clippy-preview --toolchain=nightly-$date && \
    rustc --version && \
    cargo --version && \
    cargo +nightly-$date install cargo-cov
