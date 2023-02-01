# Dockerfile for bundling cfitsio-dev for armv7
FROM rustembedded/cross:armv7-unknown-linux-gnueabihf-0.2.1

RUN dpkg --add-architecture armhf && \
    apt-get update && \
    apt-get install -y --no-install-recommends --assume-yes libcfitsio-dev:armhf && rm -rf /var/lib/apt/lists/*;
ENV PKG_CONFIG_PATH=/usr/lib/arm-linux-gnueabihf/pkgconfig:$PKG_CONFIG_PATH
