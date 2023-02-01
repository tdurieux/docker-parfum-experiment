FROM debian:bullseye
MAINTAINER Andrey Volk <andrey@signalwire.com>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -yq install git && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/signalwire/freeswitch /usr/src/freeswitch
RUN git clone https://github.com/signalwire/libks /usr/src/libs/libks
RUN git clone https://github.com/freeswitch/sofia-sip /usr/src/libs/sofia-sip
RUN git clone https://github.com/freeswitch/spandsp /usr/src/libs/spandsp
RUN git clone https://github.com/signalwire/signalwire-c /usr/src/libs/signalwire-c

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -yq install \

    build-essential cmake automake autoconf 'libtool-bin|libtool' pkg-config \

    libssl-dev zlib1g-dev libdb-dev unixodbc-dev libncurses5-dev libexpat1-dev libgdbm-dev bison erlang-dev libtpl-dev libtiff5-dev uuid-dev \

    libpcre3-dev libedit-dev libsqlite3-dev libcurl4-openssl-dev nasm \

    libogg-dev libspeex-dev libspeexdsp-dev \

    libldns-dev \

    python3-dev \

    libavformat-dev libswscale-dev libavresample-dev \

    liblua5.2-dev \

    libopus-dev \

    libpq-dev \

    libsndfile1-dev libflac-dev libogg-dev libvorbis-dev && rm -rf /var/lib/apt/lists/*;

RUN cd /usr/src/libs/libks && cmake . -DCMAKE_INSTALL_PREFIX=/usr -DWITH_LIBBACKTRACE=1 && make install
RUN cd /usr/src/libs/sofia-sip && ./bootstrap.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" CFLAGS="-g -ggdb" --with-pic --with-glib=no --without-doxygen --disable-stun --prefix=/usr && make -j`nproc --all` && make install
RUN cd /usr/src/libs/spandsp && ./bootstrap.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" CFLAGS="-g -ggdb" --with-pic --prefix=/usr && make -j`nproc --all` && make install
RUN cd /usr/src/libs/signalwire-c && PKG_CONFIG_PATH=/usr/lib/pkgconfig cmake . -DCMAKE_INSTALL_PREFIX=/usr && make install

RUN cd /usr/src/freeswitch && ./bootstrap.sh -j
RUN cd /usr/src/freeswitch && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN cd /usr/src/freeswitch && make -j`nproc` && make install

# Cleanup the image
RUN apt-get clean

# Uncomment to cleanup even more
#RUN rm -rf /usr/src/*