FROM alpine:3.10.2
ARG ROOT=/usr/local
COPY ovs-musl.patch /
RUN apk upgrade --no-cache && apk add --no-cache build-base \
    libtool pkgconfig autoconf automake cmake doxygen file py-six \
    linux-headers libuv-dev boost-dev openssl-dev git \
    libnetfilter_conntrack-dev rapidjson-dev python-dev bzip2-dev \
    && apk add --no-cache libexecinfo-dev --repository \
    http://nl.alpinelinux.org/alpine/edge/main
ENV CFLAGS='-fPIE -D_FORTIFY_SOURCE=2  -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security'
ENV CXXFLAGS='-fPIE -D_FORTIFY_SOURCE=2  -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security'
ENV LDFLAGS='-pie -Wl,-z,now -Wl,-z,relro'
ARG make_args=-j4
RUN git clone https://github.com/openvswitch/ovs.git --branch v2.6.0 --depth 1 \
  && cd ovs \
  && patch -p1 < /ovs-musl.patch \
  && ./boot.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-ssl --disable-libcapng --enable-shared \
  && make $make_args && make install \
  && mkdir -p $ROOT/include/openvswitch/openvswitch \
  && mv $ROOT/include/openvswitch/*.h $ROOT/include/openvswitch/openvswitch \
  && mv $ROOT/include/openflow $ROOT/include/openvswitch \
  && cp include/*.h "$ROOT/include/openvswitch/" \
  && find lib -name "*.h" -exec cp --parents {} "$ROOT/include/openvswitch/" \;
RUN wget https://sourceforge.net/projects/boost/files/boost/1.58.0/boost_1_58_0.tar.gz \
  && tar zxvf boost_1_58_0.tar.gz \
  && cd boost_1_58_0 \
  && ./bootstrap.sh --prefix=$ROOT/boost_1_58_0 \
  && ./b2 cxxflags=-fPIC cflags=-fPIC -a \
  && ./b2 install --prefix=$ROOT/boost_1_58_0 \
  && cd .. \
  && rm -Rf boost_1_58_0.tar.gz \
  && rm -Rf boost_1_58_0 \;
