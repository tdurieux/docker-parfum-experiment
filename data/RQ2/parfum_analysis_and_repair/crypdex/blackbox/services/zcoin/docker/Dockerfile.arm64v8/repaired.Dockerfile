FROM arm64v8/ubuntu:bionic

ARG VERSION

LABEL maintainer.0="David Michael"

RUN useradd -r zcoin

RUN apt-get update \
  && apt-get install --no-install-recommends -qq -y build-essential \
  libtool \
  autotools-dev \
  automake \
  pkg-config \
  libssl-dev \
  libevent-dev \
  bsdmainutils \
  libboost-system1.65.1 \
  libboost-filesystem1.65.1 \
  libboost-program-options1.65.1 \
  libboost-thread1.65.1 \
  libboost-chrono1.65.1 \
  libboost-all-dev \
  software-properties-common \
  git \
  && add-apt-repository ppa:bitcoin/bitcoin \
  && apt-get update \
  && apt-get install --no-install-recommends -qq -y libdb4.8-dev \
  libdb4.8++-dev \
  libzmq3-dev \
  libqt5core5a \
  libqt5dbus5 \
  qttools5-dev \
  qttools5-dev-tools \
  libprotobuf-dev \
  protobuf-compiler \
  libqrencode-dev \
  && git clone --depth=1 --branch=${RELEASE_TAG} https://github.com/zcoinofficial/zcoin \
  && cd zcoin \
  && ./autogen.sh \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --without-gui --without-upnp --disable-tests \
  && make -j8 \
  && make install-strip \
  && cd .. && rm -rf zcoin \
  && apt-get remove -qq -y libminiupnpc-dev qttools5-dev qttools5-dev-tools libprotobuf-dev libqrencode-dev build-essential libtool autotools-dev automake pkg-config libssl-dev bsdmainutils libboost-all-dev software-properties-common git \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/ncopa/su-exec.git \
  && cd su-exec && make && cp su-exec /usr/local/bin/ \
  && cd .. && rm -rf su-exec

VOLUME ["/home/zcoin/.zcoin"]

EXPOSE 8168 8888

ENTRYPOINT ["/entrypoint.sh"]

CMD ["zcoind"]
