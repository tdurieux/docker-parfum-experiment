FROM ubuntu:artful

RUN apt-get update \
    && apt-get install --no-install-recommends -y qt5-default build-essential curl cmake gcc python3 python3-pip libssl-dev ca-certificates pkg-config git \
    && apt-get autoremove \
    && apt-get autoclean && rm -rf /var/lib/apt/lists/*;

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain 1.23.0
RUN cargo install mdbook

RUN pip3 install --no-cache-dir ghp-import awscli

WORKDIR /code
