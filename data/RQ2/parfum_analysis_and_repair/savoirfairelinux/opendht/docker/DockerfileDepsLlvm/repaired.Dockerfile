FROM ubuntu:22.04
LABEL maintainer="Adrien Béraud <adrien.beraud@savoirfairelinux.com>"
LABEL org.opencontainers.image.source https://github.com/savoirfairelinux/opendht

RUN apt-get update && apt-get install --no-install-recommends -y \
        dialog apt-utils \
    && apt-get clean \
    && echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && rm -rf /var/lib/apt/lists/*;

RUN apt-get update \
    && apt-get install --no-install-recommends -y llvm llvm-dev lldb clang gdb make cmake pkg-config \
       libtool git wget libncurses5-dev libreadline-dev \
       nettle-dev libgnutls28-dev libuv1-dev libmsgpack-dev libjsoncpp-dev cython3 python3-dev \
       python3-setuptools libcppunit-dev python3-pip python3-build python3-virtualenv \
       autotools-dev autoconf libssl-dev libargon2-dev \
       libfmt-dev libhttp-parser-dev libasio-dev \
    && apt-get remove -y gcc g++ && apt-get autoremove -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

ENV CC cc
ENV CXX c++

RUN echo "*** Downloading RESTinio ***" \
    && mkdir restinio && cd restinio \
    && wget https://github.com/aberaud/restinio/archive/e0a261dd8488246a3cb8bbb3ea781ea5139c3c94.tar.gz \
    && ls -l && tar -xzf e0a261dd8488246a3cb8bbb3ea781ea5139c3c94.tar.gz \
    && cd restinio-e0a261dd8488246a3cb8bbb3ea781ea5139c3c94/dev \
    && cmake -DCMAKE_INSTALL_PREFIX=/usr -DRESTINIO_TEST=OFF -DRESTINIO_SAMPLE=OFF \
             -DRESTINIO_INSTALL_SAMPLES=OFF -DRESTINIO_BENCH=OFF -DRESTINIO_INSTALL_BENCHES=OFF \
             -DRESTINIO_FIND_DEPS=ON -DRESTINIO_ALLOW_SOBJECTIZER=Off -DRESTINIO_USE_BOOST_ASIO=none . \
    && make -j8 && make install \
    && cd ../../ && rm -rf restinio* && rm e0a261dd8488246a3cb8bbb3ea781ea5139c3c94.tar.gz
