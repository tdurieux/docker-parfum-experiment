FROM rust:slim as builder

RUN apt update && \
    apt install --no-install-recommends -y \
    build-essential \
    clang \
    protobuf-compiler \
    python3 \
    libx11-xcb-dev \
    libxcb-xfixes0-dev \
    libxcb-render0-dev \
    libxcb-shape0-dev && \
    rustup default stable && \
    rustup component add rustfmt && rm -rf /var/lib/apt/lists/*;

ENV PROTOC /usr/bin/protoc

WORKDIR /build

ADD . /build

RUN cargo build --release --features=all

FROM debian:stable-slim

COPY --from=builder /build/target/release/clipcatd       /usr/bin
COPY --from=builder /build/target/release/clipcatctl     /usr/bin
COPY --from=builder /build/target/release/clipcat-menu   /usr/bin
COPY --from=builder /build/target/release/clipcat-notify /usr/bin

RUN apt update && apt install --no-install-recommends -y xcb libxcb-xfixes0 && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "clipcatd", "--version" ]
