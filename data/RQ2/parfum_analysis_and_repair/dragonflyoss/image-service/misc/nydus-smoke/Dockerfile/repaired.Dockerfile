FROM rust:1.61.0
ARG ARCH=x86_64

RUN mkdir /root/.cargo/
RUN rustup component add rustfmt && rustup component add clippy

ENV CARGO_HOME=/root/.cargo
RUN apt update && apt install --no-install-recommends -y tree && rm -rf /var/lib/apt/lists/*;

WORKDIR /nydus-rs

CMD make fusedev-release smoke
