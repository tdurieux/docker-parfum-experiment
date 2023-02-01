FROM ubuntu:20.04
SHELL ["/bin/bash", "-c"]

ARG RUST_VERSION=nightly
ARG DEBIAN_FRONTEND=noninteractive

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

# Install prerequisites
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        curl \
        build-essential \
        software-properties-common \
        pkg-config \
        python-is-python3 \
        python-markdown \
        && add-apt-repository ppa:mozillateam/ppa \
        && apt-get update \
        && apt-get install -y --no-install-recommends firefox-esr \
        && ln -s /usr/bin/firefox-esr /usr/bin/firefox \
        && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain none -y \
    && rustup toolchain install $RUST_VERSION --allow-downgrade --profile minimal --component rustfmt clippy \
    && curl -f -sL https://deb.nodesource.com/setup_16.x | bash - && apt-get install --no-install-recommends -y nodejs && npm i -g solc \
    && curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh \
    && curl -f -sL https://raw.githubusercontent.com/Sarcasm/run-clang-format/master/run-clang-format.py > /opt/run-clang-format.py \
    && chmod +x /opt/run-clang-format.py \
    && ln -s /opt/run-clang-format.py /usr/bin \
    && rustup --version; npm cache clean --force; rm -rf /var/lib/apt/lists/*; cargo --version; rustc --version; wasm-pack --version; echo nodejs $(node -v);

RUN cd /opt && curl -f -LO https://github.com/mozilla/geckodriver/releases/download/v0.28.0/geckodriver-v0.28.0-linux64.tar.gz \
    && tar -xzf geckodriver-v0.28.0-linux64.tar.gz geckodriver \
    && ln -s /opt/geckodriver /usr/bin \
    && geckodriver --version \
    && rm -rf geckodriver-v0.28.0-linux64.tar.gz
