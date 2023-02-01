FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  gcc xz-utils ca-certificates make libc6-dev gdb curl && rm -rf /var/lib/apt/lists/*;

ENV GETTEXT_VERSION 0.19.8.1
RUN curl -f -sL https://ftp.gnu.org/gnu/gettext/gettext-${GETTEXT_VERSION}.tar.gz -o gettext-${GETTEXT_VERSION}.tar.gz && \
    tar -xf gettext-${GETTEXT_VERSION}.tar.gz && \
    cd gettext-${GETTEXT_VERSION} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --without-emacs --disable-java --disable-c++ --enable-fast-install --prefix=/result \
      --disable-csharp --enable-static --with-included-gettext --with-included-glib \
      --with-included-libcroco --with-included-libunistring && \
    make -j2 && \
    make install && \
    cd .. && \
    rm -rf gettext-${GETTEXT_VERSION} gettext-${GETTEXT_VERSION}.tar.gz
