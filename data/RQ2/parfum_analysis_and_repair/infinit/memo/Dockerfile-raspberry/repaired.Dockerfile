FROM debian:jessie

RUN apt-get update

RUN apt-get install --no-install-recommends -y \
  fuse \
  g++ \
  git \
  make \
  patch \
  pylint \
  python3 \
  python3-greenlet \
  python3-mako \
  python3-pip \
  realpath \
  gettext \
  qemu-user-binfmt && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir mistune
RUN pip3 install --no-cache-dir oset

# Toolchain
RUN git clone https://github.com/raspberrypi/tools.git toolchain
ENV PATH=$PATH:/toolchain/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/bin

# Libattr
RUN echo 'deb-src http://deb.debian.org/debian jessie main' >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get source attr
WORKDIR attr-2.4.47
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/libattr-arm --host=arm-linux-gnueabihf --enable-static=yes --enable-shared=no
RUN make install-lib

WORKDIR /root
ADD . /root/fs

WORKDIR /root/fs/_build/raspberry
RUN mkdir -p lib src/attr
RUN cp /attr-2.4.47/libattr/.libs/* lib
RUN cp -a /attr-2.4.47/include/*.h src/attr
RUN cp /toolchain/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/arm-linux-gnueabihf/sysroot/lib/libgcc_s.so.1 lib
RUN cp /toolchain/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/arm-linux-gnueabihf/sysroot/lib/libstdc++.so.6 lib
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Parallel builds show races when building and copying .so.
RUN bash -c "for i in 1 2 3 4; do if python3 ./drake -j $(nproc) //install --prefix=/opt/infinit ; then break; fi;done"

# strip
# RUN chmod u+w /opt/infinit/bin/* /opt/infinit/lib/*
# RUN arm-linux-gnueabihf-strip /opt/infinit/bin/* /opt/infinit/lib/*
