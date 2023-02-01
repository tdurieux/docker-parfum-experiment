FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y meson python3 ninja-build && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libuv1-dev libiniparser-dev libjansson-dev libeina-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /opt/zigbridge
WORKDIR /opt/zigbridge

COPY . .

RUN mkdir -p /etc/zigbdrige && cp config/config_sample.ini /etc/zigbdrige/config.ini

RUN meson builddir
RUN ninja -C builddir