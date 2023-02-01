from hyperledger/fabric-baseimage

RUN apt-get update && apt-get install --no-install-recommends pkg-config autoconf libtool -y && rm -rf /var/lib/apt/lists/*;
RUN cd /tmp && git clone https://github.com/bitcoin/secp256k1.git && cd secp256k1/
WORKDIR /tmp/secp256k1
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-module-recovery
RUN make
RUN ./tests
RUN make install

WORKDIR /tmp
RUN apt-get install --no-install-recommends libtool libboost1.55-all-dev -y && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/libbitcoin/libbitcoin-consensus.git
WORKDIR /tmp/libbitcoin-consensus
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN make install

# Now SWIG
WORKDIR /tmp
# Need pcre lib for building
RUN apt-get install --no-install-recommends libpcre3-dev -y && rm -rf /var/lib/apt/lists/*;
RUN wget https://prdownloads.sourceforge.net/swig/swig-3.0.8.tar.gz && tar xvf swig-3.0.8.tar.gz && rm swig-3.0.8.tar.gz
WORKDIR /tmp/swig-3.0.8
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN make install

# Now add this for SWIG execution requirement to get missing stubs-32.h header file
RUN apt-get install --no-install-recommends g++-multilib -y && rm -rf /var/lib/apt/lists/*;

ENV CGO_LDFLAGS="-L/usr/local/lib/ -lbitcoin-consensus -lstdc++"
