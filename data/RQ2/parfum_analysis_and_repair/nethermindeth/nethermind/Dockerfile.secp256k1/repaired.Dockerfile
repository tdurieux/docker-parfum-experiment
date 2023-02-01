FROM debian@sha256:acf7795dc91df17e10effee064bd229580a9c34213b4dba578d64768af5d8c51 AS secp256k1
WORKDIR /source

RUN apt-get update && apt-get install --no-install-recommends -y git autoconf automake libtool build-essential && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/NethermindEth/secp256k1 . && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-module-recovery --enable-experimental --enable-module-ecdh --enable-shared --with-bignum=no && \
    make -j16

RUN strip .libs/libsecp256k1.so


FROM debian@sha256:acf7795dc91df17e10effee064bd229580a9c34213b4dba578d64768af5d8c51 AS libsecp256k1
WORKDIR /nethermind
COPY --from=secp256k1 /source/.libs/libsecp256k1.so .
