#
# [ arm32 ] elinks docker development environment v0.1c
#

# [*] base system

# get latest debian
FROM debian:latest

# prepare system
RUN apt-get update && apt-get -y --no-install-recommends install bash \
  rsync vim screen git make automake && rm -rf /var/lib/apt/lists/*;

# [*] source build tools

# install sources build tools and update
RUN apt-get install --no-install-recommends -y apt-src && \
  grep '^deb ' /etc/apt/sources.list | sed 's/deb /deb-src /' >> /etc/apt/sources.list && \
  apt-src update && rm -rf /var/lib/apt/lists/*;

# [*] install sources

# install sources for openssl and zlib1g-dev
RUN cd /root && apt-src install libssl-dev zlib1g-dev

# install dev tools [ platform dependent ]

RUN apt-get -y --no-install-recommends install gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf && rm -rf /var/lib/apt/lists/*;

## [*] elinks openssl development support
# build openssl library for arm32
RUN cd /root && cd `ls -d /root/openssl-*` && \
./Configure linux-armv4 \
  --prefix=/usr/local \
  --cross-compile-prefix=arm-linux-gnueabihf- && \
  make depend && \
  make && \
  make install_runtime_libs && \
  make install_dev

## [*} zlib sources
# build zlib library for arm32
RUN cd /root && cd `ls -d /root/zlib-*` && \
 CC="arm-linux-gnueabihf-gcc" \
LD="arm-linux-gnueabihf-ldd" \
./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \

--static --prefix=/usr/local && \
make && \
make install

# install sources for openssl and zlib1g-dev
RUN cd /root && apt-src install libcrypto++-dev

# build the libcrypto
RUN cd /root/libcrypto* && \
CXX="arm-linux-gnueabihf-gcc" \
LD="arm-linux-gnueabihf-ld" \
AR="arm-linux-gnueabihf-ar" \
make -f GNUmakefile-cross && \
make install

## [*] elinks sources
# get elinks source
RUN cd /root; git clone https://github.com/rkd77/elinks

