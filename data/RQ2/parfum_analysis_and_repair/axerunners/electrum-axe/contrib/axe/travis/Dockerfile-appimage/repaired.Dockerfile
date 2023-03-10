FROM ubuntu:14.04@sha256:cac55e5d97fad634d954d00a5c2a56d80576a08dcc01036011f26b88263f1578

ENV LC_ALL=C.UTF-8 LANG=C.UTF-8 \
    PYTHON_VERSION=3.6.8 \
    LIBSECP_VERSION=b408c6a8b287003d1ade5709e6f7bc3c7f1d5be7 \
    APPDIR=/var/build/appimage/electrum-dash.AppDir


RUN apt-get update -q && \
    apt-get install --no-install-recommends -qy \
        git \
        wget \
        make \
        autotools-dev \
        autoconf \
        libtool \
        xz-utils \
        libssl-dev \
        zlib1g-dev \
        libffi6 \
        libffi-dev \
        libusb-1.0-0-dev \
        libudev-dev \
        gettext \
        libzbar0 \
        libdbus-1-3 \
        && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean


RUN wget -O python.tar.xz https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz \
    && tar xf python.tar.xz \
    && cd Python-$PYTHON_VERSION \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
      --prefix="$APPDIR/usr" \
      --enable-ipv6 \
      --enable-shared \
      --with-threads \
      -q \
    && make -s \
    && make -s install > /dev/null \
    && cd .. && rm -rf python.tar.xz Python-$PYTHON_VERSION \
    && git clone https://github.com/bitcoin-core/secp256k1 \
    && cd secp256k1 \
    && git reset --hard "$LIBSECP_VERSION" \
    && git clean -f -x -q \
    && ./autogen.sh \
    && echo "LDFLAGS = -no-undefined" >> Makefile.am \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
      --prefix="$APPDIR/usr" \
      --enable-module-recovery \
      --enable-experimental \
      --enable-module-ecdh \
      --disable-jni \
      -q \
    && make -s \
    && make -s install > /dev/null \
    && cd .. && rm -rf secp256k1
