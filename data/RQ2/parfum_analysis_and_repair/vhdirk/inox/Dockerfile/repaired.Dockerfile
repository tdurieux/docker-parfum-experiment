FROM buildpack-deps:buster

# The Rust toolchain to use when building our image.  Set by `hooks/build`.
ARG TRAVIS_RUST_VERSION=nightly

RUN apt-get update

# Set up path
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

# Install the Rust toolchain
RUN set -eux; \
    \
    url="https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init"; \
    wget "$url"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain $TRAVIS_RUST_VERSION; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

# Install additional dependencies
RUN apt-get install --no-install-recommends -y libgmime-3.0-dev libgtk-3-dev libnotmuch-dev sassc && rm -rf /var/lib/apt/lists/*;

# Install tools for testing
RUN apt-get install --no-install-recommends -y notmuch git && rm -rf /var/lib/apt/lists/*;

# Create the workdir
RUN mkdir -p /opt/rust/src
WORKDIR /opt/rust/src
