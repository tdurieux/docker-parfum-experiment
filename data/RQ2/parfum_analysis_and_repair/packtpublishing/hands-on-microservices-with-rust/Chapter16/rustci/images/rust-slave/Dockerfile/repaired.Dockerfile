FROM jetbrains/teamcity-minimal-agent:latest

ENV RUST_VERSION=1.32.0

RUN curl https://sh.rustup.rs -sSf \
  | sh -s -- -y --no-modify-path --default-toolchain $RUST_VERSION

ENV PATH=/root/.cargo/bin:$PATH

RUN rustup --version; \
    cargo --version; \
    rustc --version;

RUN apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

RUN rustup component add rustfmt
RUN rustup component add clippy
