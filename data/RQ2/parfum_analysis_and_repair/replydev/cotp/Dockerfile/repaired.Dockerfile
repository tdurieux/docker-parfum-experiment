FROM ghcr.io/cross-rs/aarch64-unknown-linux-gnu:edge

RUN dpkg --add-architecture arm64 && \
    apt-get update && \
    apt-get install -y --no-install-recommends --assume-yes libxcb-render0-dev:arm64 libxcb-shape0-dev:arm64 libxcb-xfixes0-dev:arm64 libxkbcommon-dev:arm64 && rm -rf /var/lib/apt/lists/*;