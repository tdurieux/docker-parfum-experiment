FROM ubuntu:focal

WORKDIR /home/project

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update \
    && apt-get install --no-install-recommends -y build-essential curl autoconf git m4 \
    iproute2 clang libpq-dev clang && rm -rf /var/lib/apt/lists/*;

ENV PATH="/root/.cargo/bin:/usr/local/cmake/bin:${PATH}"

RUN curl -f --proto '=https' --tlsv1.2 -o rust.sh https://sh.rustup.rs \
    && /bin/bash rust.sh -y

RUN rustup component add rust-analysis --toolchain stable-x86_64-unknown-linux-gnu \
    && rustup component add rust-src --toolchain stable-x86_64-unknown-linux-gnu \
    && rustup component add rls --toolchain stable-x86_64-unknown-linux-gnu