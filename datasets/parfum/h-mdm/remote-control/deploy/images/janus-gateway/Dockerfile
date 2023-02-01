FROM ubuntu:20.04 AS BUILD

# Build deps
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        libmicrohttpd-dev \
		libjansson-dev \
		libssl-dev \
		libglib2.0-dev \
		libopus-dev \
		libogg-dev \
		libcurl4-openssl-dev \
		liblua5.3-dev \
		libconfig-dev \
		libpcre3-dev \
		zlib1g-dev \
		pkg-config \
		gengetopt \
		libtool \
		automake \
		cmake \
		build-essential \
		wget \
		curl \
		git \
		ca-certificates \
		golang \
        gtk-doc-tools \
        # for libnice versions >= 0.1.18
        meson \
        ninja-build \
    && apt-get autoremove -y && apt-get clean && rm -r /var/lib/apt/lists/*

RUN mkdir /tmp/sources

# Build libnice
RUN cd /tmp/sources/ && git clone https://gitlab.freedesktop.org/libnice/libnice.git/ \
    && cd libnice \
    && git checkout tags/0.1.19 \
#   for versions >= 0.1.18 (Using meson & ninja)
    && meson builddir \
    && ninja -C builddir \
    && ninja -C builddir test \
    && ninja -C builddir install
#   for versions < 0.1.18
#    && ./autogen.sh \
#    && ./configure --prefix=/usr \
#    && make && make install

# Build libsrtp
RUN cd /tmp/sources/ && wget https://github.com/cisco/libsrtp/archive/v2.4.2.tar.gz \
    && tar xfv v2.4.2.tar.gz \
    && cd libsrtp-2.4.2 \
    && ./configure --prefix=/usr --enable-openssl \
    && make shared_library && make install

# Build usrsctp (for DataChannels support)
RUN cd /tmp/sources/ && git clone https://github.com/sctplab/usrsctp \
    && cd usrsctp \
    && git checkout 0.9.5.0 \
    && ./bootstrap \
    && ./configure --prefix=/usr \
    && make && make install

# Build libwebsockets (for WebSockets transport support)
RUN cd /tmp/sources/ && git clone https://github.com/warmcat/libwebsockets.git \
    && cd libwebsockets \
    && git checkout v4.3.2 \
    && mkdir build && cd build \
    && cmake -DLWS_MAX_SMP=1 -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_C_FLAGS="-fpic" .. \
    && make && make install

# Build BoringSSL (instead of OpenSSL, for DTLS timeout)
RUN cd /tmp/sources/ && git clone https://boringssl.googlesource.com/boringssl \
    && cd boringssl \
    && git checkout 78b3337a10a7f7b3495b6cb8140a74e265290898 \
    && sed -i s/" -Werror"//g CMakeLists.txt \
    && mkdir -p build && cd build \
    && cmake -DCMAKE_CXX_FLAGS="-lrt" .. && make && cd .. \
    && mkdir -p /opt/boringssl && cp -R include /opt/boringssl/ && mkdir -p /opt/boringssl/lib \
    && cp build/ssl/libssl.a /opt/boringssl/lib/ && cp build/crypto/libcrypto.a /opt/boringssl/lib/

# Build Janus Gateway
RUN cd /tmp/sources/ && git clone https://github.com/meetecho/janus-gateway.git \
    && cd janus-gateway \
    && git checkout v0.12.3 \
    && sh autogen.sh \
    && ./configure \
      # General
      --prefix=/usr/local \
      --enable-boringssl \
      --enable-dtls-settimeout \
      # Transports
      --disable-rabbitmq --disable-mqtt --disable-unix-sockets --disable-nanomsg \
      # Plugins
      --disable-plugin-echotest --disable-plugin-audiobridge --disable-plugin-recordplay --disable-plugin-sip --disable-plugin-nosip --disable-plugin-videocall --disable-plugin-videoroom --disable-plugin-voicemail \
    && make && make install


FROM ubuntu:20.04

RUN apt-get -y update \
	&& apt-get install -y \
		libmicrohttpd12 \
		libjansson4 \
		libssl1.1 \
		libglib2.0-0 \
		libopus0 \
		libogg0 \
		libcurl4 \
		liblua5.3-0 \
		libconfig9 \
	&& apt-get autoremove -y && apt-get clean && rm -r /var/lib/apt/lists/*

# COPY libnice
COPY --from=BUILD /usr/local/lib/x86_64-linux-gnu/libnice.so.10.12.0 /usr/local/lib/x86_64-linux-gnu/libnice.so.10.12.0

# COPY to /usr/lib
COPY --from=BUILD \
  ## SOURCES
  # libsrtp
  /usr/lib/libsrtp2.so.1 \
  # usrsctp
  /usr/lib/libusrsctp.la \
  /usr/lib/libusrsctp.so.2.0.0 \
  # libwebsockets
  /usr/lib/libwebsockets.so.19 \
  ## DESTINATION
  /usr/lib/

# RUN stuff
RUN \
  # libnice symlinks
    ln -s /usr/local/lib/x86_64-linux-gnu/libnice.so.10.12.0 /usr/local/lib/x86_64-linux-gnu/libnice.so.10 \
 && ln -s /usr/local/lib/x86_64-linux-gnu/libnice.so.10.12.0 /usr/local/lib/x86_64-linux-gnu/libnice.so \
 && ln -s /usr/local/lib/x86_64-linux-gnu/libnice.so.10.12.0 /usr/lib/libnice.so.10.12.0 \
 && ln -s /usr/local/lib/x86_64-linux-gnu/libnice.so.10.12.0 /usr/lib/libnice.so.10 \
 && ln -s /usr/local/lib/x86_64-linux-gnu/libnice.so.10.12.0 /usr/lib/libnice.so \
  # libsrtp symlinks
 && ln -s /usr/lib/libsrtp2.so.1 /usr/lib/libsrtp2.so \
  # usrsctp symlinks
 && ln -s /usr/lib/libusrsctp.so.2.0.0 /usr/lib/libusrsctp.so \
 && ln -s /usr/lib/libusrsctp.so.2.0.0 /usr/lib/libusrsctp.so.2 \
  # libwebsockets symlinks
 && ln -s /usr/lib/libwebsockets.so.19 /usr/lib/libwebsockets.so \
  # Janus config dir
 && mkdir /usr/local/etc/janus

## Janus Gateway
# binaries
COPY --from=BUILD /usr/local/bin/janus /usr/local/bin/janus
COPY --from=BUILD /usr/local/bin/janus-cfgconv /usr/local/bin/janus-cfgconv
# libs
COPY --from=BUILD /usr/local/lib/janus /usr/local/lib/janus
# assets, demos, etc
COPY --from=BUILD /usr/local/share/janus /usr/local/share/janus

# SECURE ports (REST, Admin&Monitor REST, WebSockets, Admin&Monitor WebSockets)
# EXPOSE 8089 7889 8989 7989  # default ports, but disabled due to "host" network mode

# INSECURE ports (REST, Admin&Monitor REST, WebSockets, Admin&Monitor WebSockets)
# EXPOSE 8088 7088 8188 7188  # default ports, but disabled due to "host" network mode

# RTP/RTCP ports
# EXPOSE 10000-10200/udp  # default ports, but disabled due to "host" network mode

CMD ["/usr/local/bin/janus"]

