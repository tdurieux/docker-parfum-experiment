## Custom Dockerfile
FROM ubuntu@sha256:78f4191fb6e8bc346b2b0fce8e87d7ad342664a71cc4dfcfe228ea75a254232f
COPY ./qemu-arm-static /usr/bin/

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
