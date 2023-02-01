FROM rustembedded/cross:armv7-unknown-linux-gnueabihf

ENV PKG_CONFIG_ALLOW_CROSS 1
ENV PKG_CONFIG_PATH /usr/lib/arm-linux-gnueabihf/pkgconfig/

RUN dpkg --add-architecture armhf && \
    apt-get update && \
    apt-get install --no-install-recommends libasound2-dev:armhf openssl:armhf libssl-dev:armhf -y && rm -rf /var/lib/apt/lists/*;