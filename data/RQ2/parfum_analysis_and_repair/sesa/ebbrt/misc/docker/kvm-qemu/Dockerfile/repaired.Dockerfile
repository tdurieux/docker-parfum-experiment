FROM ubuntu:xenial
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    autoconf \
    automake \
    build-essential \
    git \
    libglib2.0-dev \
    libpixman-1-dev \
    zlib1g-dev \
    iputils-ping \
    iproute2 \
    ebtables \
    dnsmasq && rm -rf /var/lib/apt/lists/*;

RUN git clone -b pin-threads https://github.com/SESA/qemu.git /qemu
WORKDIR /qemu
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --target-list=x86_64-softmmu --enable-vhost-net --enable-kvm
RUN make -j
RUN make install
RUN make clean
WORKDIR /
RUN rm -rf /qemu

COPY start.sh /root/start.sh
COPY launch.sh /root/launch.sh

RUN apt-get update && apt-get install --no-install-recommends -y gdb && rm -rf /var/lib/apt/lists/*;

EXPOSE 22
EXPOSE 1234
ENTRYPOINT ["/root/start.sh"]
