FROM ubuntu:xenial
# https://github.com/ElementsProject/elements/blob/elements-0.13.1/doc/build-unix.md
RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev \
    bsdmainutils curl openssl jq git libboost-system-dev libboost-filesystem-dev libboost-chrono-dev \
    libboost-program-options-dev libboost-test-dev libboost-thread-dev libdb-dev libdb++-dev iputils-ping && rm -rf /var/lib/apt/lists/*;
RUN git clone -b elements-0.13.1 --depth=1 https://github.com/ElementsProject/elements.git /opt/elements && \
    cd /opt/elements && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-incompatible-bdb --without-gui --disable-tests && \
    make && make install
ADD elements.conf /root/.bitcoin/
