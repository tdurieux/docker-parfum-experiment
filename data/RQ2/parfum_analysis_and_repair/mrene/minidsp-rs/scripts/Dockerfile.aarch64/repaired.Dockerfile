FROM rustembedded/cross:aarch64-unknown-linux-gnu-0.2.1
RUN dpkg --add-architecture arm64 && apt-get update && apt-get install --no-install-recommends -y libusb-1.0-0-dev:arm64 pkg-config && rm -rf /var/lib/apt/lists/*;
ENV PKG_CONFIG_LIBDIR=/usr/lib/aarch64-linux-gnu/pkgconfig
