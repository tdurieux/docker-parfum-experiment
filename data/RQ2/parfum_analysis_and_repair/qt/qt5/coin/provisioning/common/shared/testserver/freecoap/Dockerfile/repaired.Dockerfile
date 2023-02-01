FROM qt_ubuntu_18.04
ARG packages="avahi-daemon autoconf automake libtool make libgnutls28-dev"
RUN apt-get update && apt-get -y --no-install-recommends install $packages && rm -rf /var/lib/apt/lists/*;

WORKDIR /root/src
ADD FreeCoAP-*.tar.gz .
RUN mv FreeCoAP-* FreeCoAP
WORKDIR /root/src/FreeCoAP
RUN autoreconf --install && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install
WORKDIR sample/time_server
RUN make
WORKDIR /

EXPOSE 5685/udp
