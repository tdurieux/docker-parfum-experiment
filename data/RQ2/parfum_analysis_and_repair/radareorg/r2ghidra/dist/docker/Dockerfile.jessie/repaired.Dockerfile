FROM debian:jessie

RUN apt-get update && apt-get -y --no-install-recommends install git g++ pkg-config flex bison && rm -rf /var/lib/apt/lists/*;

RUN cd /root && git clone --depth 1 https://github.com/radareorg/radare2 && cd radare2 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && make -j4 && make install

CMD []

