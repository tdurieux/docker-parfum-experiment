FROM rustembedded/cross:armv7-unknown-linux-gnueabihf

ENV PKG_CONFIG_ALLOW_CROSS 1
ENV PKG_CONFIG_PATH /usr/lib/arm-linux-gnueabihf/pkgconfig/

RUN dpkg --add-architecture armhf && \
  apt-get update && \
  apt-get install --no-install-recommends -y libasound2-dev:armhf libdbus-1-dev:armhf && rm -rf /var/lib/apt/lists/*;