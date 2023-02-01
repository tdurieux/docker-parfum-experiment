FROM rust:slim-bullseye

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends dpkg-dev pkg-config python3; rm -rf /var/lib/apt/lists/*; \
    cargo install cargo-deb ; \
    apt-get install -y --no-install-recommends \
      cmake \
      g++ \
      libasound2-dev \
      ffmpeg \
      libavutil-dev \
      libclang-dev \
      libkrb5-dev \
      libx264-dev \
      libx264-dev \
      libxcb-render0-dev \
      libxcb-shape0-dev \
      libxcb-xfixes0-dev \
      libxdamage-dev \
      libxext-dev \
      x264 \
      xcb \
      libavformat-dev \
      libavfilter-dev \
      libavdevice-dev \
      dpkg-dev \
      libpam0g-dev \
      libdbus-1-dev ;

WORKDIR /SRC
CMD cargo deb $CARGODEB_OPT -- $CARGO_OPT
