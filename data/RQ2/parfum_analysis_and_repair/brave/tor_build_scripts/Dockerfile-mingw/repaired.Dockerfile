FROM ubuntu:jammy

ARG zlib_version
ARG zlib_hash

ARG libevent_version
ARG libevent_hash

ARG openssl_version
ARG openssl_hash

ARG tor_version
ARG tor_hash

ARG jobs

COPY gpg-keys/tor.gpg /tor.gpg
COPY gpg-keys/libevent.gpg /libevent.gpg

RUN apt-get update -qq && apt-get install -y --no-install-recommends -qq \
  build-essential \
  curl \
  ca-certificates \
  gnupg \
  mingw-w64 \
  ; rm -rf /var/lib/apt/lists/*; # end of apt-get install

ENV PATH="/usr/i686-w64-mingw32/bin:$PATH"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN \
  curl --proto '=https' --tlsv1.3 -fsSL "https://zlib.net/zlib-${zlib_version}.tar.gz" -o "zlib-$zlib_version.tar.gz" && \
  echo "$zlib_hash  zlib-$zlib_version.tar.gz" | shasum -a 256 -c - && \
  tar -zxvf "zlib-$zlib_version.tar.gz" && \
  cd "zlib-$zlib_version" && \
  make ${jobs:+-j$jobs} -f win32/Makefile.gcc PREFIX=i686-w64-mingw32- && \
  make ${jobs:+-j$jobs} -f win32/Makefile.gcc PREFIX=i686-w64-mingw32- \
    BINARY_PATH="$PWD/install/bin" \
    INCLUDE_PATH="$PWD/install/include" \
    LIBRARY_PATH="$PWD/install/lib" \
    install && rm "zlib-$zlib_version.tar.gz"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN \
  curl --proto '=https' --tlsv1.3 -fsSL "https://www.openssl.org/source/openssl-$openssl_version.tar.gz" -o "openssl-$openssl_version.tar.gz" && \
  echo "$openssl_hash  openssl-$openssl_version.tar.gz" | shasum -a 256 -c - && \
  tar -xvzf "openssl-$openssl_version.tar.gz" && \
  cd "openssl-$openssl_version" && \
  ./Configure --prefix="$PWD/root"  --cross-compile-prefix=i686-w64-mingw32- \
    mingw no-shared no-dso && \
  make ${jobs:+-j$jobs} && make ${jobs:+-j$jobs} install_sw && rm "openssl-$openssl_version.tar.gz"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN \
  curl --proto '=https' --tlsv1.3 -fsSL "https://github.com/libevent/libevent/releases/download/release-$libevent_version/libevent-$libevent_version.tar.gz" -o "libevent-$libevent_version.tar.gz" && \
  curl --proto '=https' --tlsv1.3 -fsSL "https://github.com/libevent/libevent/releases/download/release-$libevent_version/libevent-$libevent_version.tar.gz.asc" -o "libevent-$libevent_version.tar.gz.asc" && \
  gpg --batch --keyring /libevent.gpg --verify "libevent-$libevent_version.tar.gz.asc" "libevent-$libevent_version.tar.gz" && \
  echo "$libevent_hash  libevent-$libevent_version.tar.gz" | shasum -a 256 -c - && \
  tar -zxvf "libevent-$libevent_version.tar.gz" && \
  cd "libevent-$libevent_version" && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
              --disable-openssl \
              --prefix="$PWD/install" \
              --disable-shared \
              --enable-static \
              --with-pic \
              --host=i686-w64-mingw32 && \
  make ${jobs:+-j$jobs} && make ${jobs:+-j$jobs} install && rm "libevent-$libevent_version.tar.gz.asc"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN \
  curl --proto '=https' --tlsv1.3 -fsSL "https://dist.torproject.org/tor-$tor_version.tar.gz" -o "tor-$tor_version.tar.gz" && \
  curl --proto '=https' --tlsv1.3 -fsSL "https://dist.torproject.org/tor-$tor_version.tar.gz.sha256sum.asc" -o "tor-$tor_version.tar.gz.sha256sum.asc" && \
  echo "$tor_hash  tor-$tor_version.tar.gz" > "tor-$tor_version.tar.gz.sha256sum" && \
  gpg --batch --keyring /tor.gpg --verify "tor-$tor_version.tar.gz.sha256sum.asc" "tor-$tor_version.tar.gz.sha256sum" && \
  sha256sum -c "tor-$tor_version.tar.gz.sha256sum" && \
  tar -xvzf "tor-$tor_version.tar.gz" && \
  cd "tor-$tor_version" && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix="$PWD/install" \
              --enable-static-tor \
              --with-libevent-dir="$PWD/../libevent-$libevent_version/install" \
              --with-openssl-dir="$PWD/../openssl-$openssl_version/root" \
              --with-zlib-dir="$PWD/../zlib-$zlib_version/install" \
              --disable-asciidoc \
              --disable-html-manual \
              --disable-lzma \
              --disable-manpage \
              --disable-zstd \
              --host=i686-w64-mingw32 \
              LIBS=-lcrypt32 && \
  make ${jobs:+-j$jobs} && make ${jobs:+-j$jobs} install && rm "tor-$tor_version.tar.gz.sha256sum.asc"

ENTRYPOINT ["sh", "-c", "while true; do sleep 2; done"]
