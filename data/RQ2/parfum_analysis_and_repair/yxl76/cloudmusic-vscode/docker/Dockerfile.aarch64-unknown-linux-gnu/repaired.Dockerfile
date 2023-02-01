FROM rustembedded/cross:aarch64-unknown-linux-gnu

ENV PKG_CONFIG_ALLOW_CROSS 1
ENV PKG_CONFIG_PATH /usr/lib/aarch64-linux-gnu/pkgconfig/

RUN dpkg --add-architecture arm64 && \
  apt-get update && \
  apt-get install --no-install-recommends -y libasound2-dev:arm64 libdbus-1-dev:arm64 && rm -rf /var/lib/apt/lists/*;