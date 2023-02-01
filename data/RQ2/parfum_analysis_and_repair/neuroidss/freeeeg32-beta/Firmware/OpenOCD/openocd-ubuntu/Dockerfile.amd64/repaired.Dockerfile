## Custom Dockerfile
FROM ubuntu@sha256:b1c268ca7c73556456ffc3318eb2a8e7ac6ad257ef5788d50dc1db4a3e3bd2ac
COPY ./qemu-x86_64-static /usr/bin/

## Install a gedit
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

## switch back to default user
USER 1000
