FROM golang:1.6

RUN apt-get update && apt-get install --no-install-recommends libssl-dev -q -y && rm -rf /var/lib/apt/lists/*;

# Musl
ENV MUSL_VERSION 1.1.10
RUN wget https://www.musl-libc.org/releases/musl-${MUSL_VERSION}.tar.gz
RUN tar zxvf musl-${MUSL_VERSION}.tar.gz && rm musl-${MUSL_VERSION}.tar.gz
RUN cd musl-${MUSL_VERSION} && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j4 && make install

# OpenSSL
ENV OPENSSL_VERSION 1.0.2h
RUN wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
RUN tar zxvf openssl-${OPENSSL_VERSION}.tar.gz && rm openssl-${OPENSSL_VERSION}.tar.gz
RUN cd openssl-${OPENSSL_VERSION} && CC='/usr/local/musl/bin/musl-gcc -static' ./Configure no-shared linux-x86_64 && make

ENV SOCAT socat-1.7.3.0
RUN wget https://www.dest-unreach.org/socat/download/$SOCAT.tar.gz
RUN tar -zvxf $SOCAT.tar.gz && rm $SOCAT.tar.gz
RUN cd $SOCAT && CC='/usr/local/musl/bin/musl-gcc -static' \
    CFLAGS='-fPIC' \
    CPPFLAGS='-I/build -I/build/openssl-1.0.2/include -DNETDB_INTERNAL=-1' \
    LDFLAGS="-L/build/openssl-${OPENSSL_VERSION}" \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \



    && make -j4 && strip socat && mv ./socat /go/
