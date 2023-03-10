FROM ubuntu:bionic

ARG VERSION=$VERSION
RUN test -n "$VERSION"



# https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md
RUN apt-get update && apt-get install --no-install-recommends -y \
  git \
  build-essential libtool autotools-dev autoconf pkg-config libevent-dev libgmp-dev \
  libboost-all-dev \

  software-properties-common \

  libssl1.0-dev && rm -rf /var/lib/apt/lists/*;
  #  libssl-dev

# Berkley DB
RUN add-apt-repository ppa:bitcoin/bitcoin && apt-get update && apt-get install --no-install-recommends -y \
  libdb4.8-dev libdb4.8++-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/ncopa/su-exec.git \
  && cd su-exec && make && cp su-exec /usr/local/bin/ \
  && cd .. && rm -rf su-exec

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/BlocknetDX/blocknet \
  && cd blocknet \
  && ./autogen.sh \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --without-gui --without-upnp --disable-tests \
  && make -j 4 \
  && make install-strip \
  # Cleanup
  && cd .. && rm -rf blocknet \
  # && apt-get remove -qq -y build-essential libtool autotools-dev autoconf pkg-config libssl1.0-dev libevent-dev libgmp-dev software-properties-common git \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#
## Build source
#RUN mkdir -p $DISTDIR \
#  && cd $PROJECTDIR \
#  && chmod +x ./autogen.sh; sync \
#  && ./autogen.sh \
#  && CONFIG_SITE=$BASEPREFIX/$HOST/share/config.site ./configure CC=gcc-8 CXX=g++-8 --without-gui --enable-debug --prefix=/ \
#  && make clean \
#  && echo "Building with cores: $ecores" \
#  # && make CC=gcc-8 CXX=g++-8 -j$ecores \
#  && make CC=gcc-8 CXX=g++-8 -j$ecores \
#  && make install DESTDIR=${DISTDIR} \
#  && make clean



RUN useradd -r blocknetdx

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME ["/home/blocknetdx/.blocknetdx"]

# Port, RPC, Test Port, Test RPC
EXPOSE 41412 41414 41474 41419

ENTRYPOINT ["/entrypoint.sh"]

CMD ["blocknetdxd"]


