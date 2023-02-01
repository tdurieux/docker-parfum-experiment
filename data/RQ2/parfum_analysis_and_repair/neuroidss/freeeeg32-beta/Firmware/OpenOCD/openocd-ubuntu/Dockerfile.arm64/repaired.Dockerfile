FROM ubuntu@sha256:43e923f6dc5e20420c75aebdcfe96dd67c64ed54bcc5ea838613a4b1295ce044
COPY ./qemu-aarch64-static /usr/bin/

USER 0

RUN apt update \
&& apt install --no-install-recommends -y git libudev-dev libusb-1.0-0-dev \
&& apt install --no-install-recommends -y gcc \
&& git clone https://github.com/libusb/hidapi.git \
&& apt install --no-install-recommends -y autoconf \
&& apt-get install --no-install-recommends -y libtool \
&& apt install --no-install-recommends -y pkg-config g++ \
&& cd hidapi \
&& ./bootstrap \
&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
&& make install \
&& cd .. \
&& git clone https://git.code.sf.net/p/openocd/code openocd-code \
&& cd openocd-code \
&& ./bootstrap \
&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
&& make install \
&& cd .. && rm -rf /var/lib/apt/lists/*;

USER 1000
