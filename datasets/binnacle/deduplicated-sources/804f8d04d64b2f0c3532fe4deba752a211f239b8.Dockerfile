FROM debian:stretch

RUN apt-get update -qq && apt-get install -yq --no-install-recommends ca-certificates curl scons cmake build-essential mingw-w64 nsis unzip

ENV LIBJANSSON_VERSION 2.10
ENV LIBJANSSON_URL "http://www.digip.org/jansson/releases/jansson-${LIBJANSSON_VERSION}.tar.bz2"
RUN curl "${LIBJANSSON_URL}" | tar xjf - -C /usr/src
WORKDIR "/usr/src/jansson-${LIBJANSSON_VERSION}"
RUN CC=i686-w64-mingw32-gcc CPPFLAGS=-D__MINGW_USE_VC2005_COMPAT ./configure --host=i686-w64-mingw32
RUN make

ENV LIBRESSL_VERSION 2.6.4
ENV LIBRESSL_URL "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-${LIBRESSL_VERSION}.tar.gz"
RUN curl "${LIBRESSL_URL}" | tar xzf - -C /usr/src
WORKDIR "/usr/src/libressl-${LIBRESSL_VERSION}"
RUN CC=i686-w64-mingw32-gcc CPPFLAGS=-D__MINGW_USE_VC2005_COMPAT ./configure --host=i686-w64-mingw32
RUN make

ENV LIBEVENT_VERSION 2.0.22
ENV LIBEVENT_URL "https://github.com/libevent/libevent/releases/download/release-${LIBEVENT_VERSION}-stable/libevent-${LIBEVENT_VERSION}-stable.tar.gz"
RUN curl -L "${LIBEVENT_URL}" | tar xzf - -C /usr/src
WORKDIR "/usr/src/libevent-${LIBEVENT_VERSION}-stable"
RUN CC=i686-w64-mingw32-gcc CPPFLAGS="-D__MINGW_USE_VC2005_COMPAT" ./configure --host=i686-w64-mingw32 \
                CPPFLAGS="-I/usr/src/libressl-${LIBRESSL_VERSION}/include/" \
                LDFLAGS="-L/usr/src/libressl-${LIBRESSL_VERSION}/ssl/.libs/ -L/usr/src/libressl-${LIBRESSL_VERSION}/crypto/.libs/"
RUN make

ENV LIBCURL_VERSION "7.61.1"
ENV LIBCURL_URL "https://curl.haxx.se/download/curl-${LIBCURL_VERSION}.tar.gz"
RUN curl "${LIBCURL_URL}" | tar xzf - -C /usr/src
WORKDIR "/usr/src/curl-${LIBCURL_VERSION}"
RUN CC=i686-w64-mingw32-gcc ./configure --host=i686-w64-mingw32 --disable-ftp --disable-file --disable-ldap --disable-ldaps --disable-rtsp --disable-proxy --disable-dict --disable-telnet --disable-tftp --disable-pop3 --disable-imap --disable-smb --disable-smtp --disable-gopher \
		CPPFLAGS="-I/usr/src/libressl-${LIBRESSL_VERSION}/include/" \
                LDFLAGS="-L/usr/src/libressl-${LIBRESSL_VERSION}/ssl/.libs/ -L/usr/src/libressl-${LIBRESSL_VERSION}/crypto/.libs/"
RUN make
RUN make ca-bundle


CMD true && \
    cp -r /usr/src/netvirt/tapcfg /usr/src/tapcfg && \
    cd /usr/src/tapcfg && \
    scons --force-mingw32 && \
    mkdir -p /usr/src/netvirt-build.windows.cli && \
    cd /usr/src/netvirt-build.windows.cli && \
    cmake -DCMAKE_TOOLCHAIN_FILE=win32/toolchain-mingw32.cmake \
          -DLIBRESSL_ROOT_DIR="/usr/src/libressl-${LIBRESSL_VERSION}" \
          -DLIBJANSSON_ROOT_DIR="/usr/src/jansson-${LIBJANSSON_VERSION}" \
          -DLIBEVENT_ROOT_DIR="/usr/src/libevent-${LIBEVENT_VERSION}-stable" \
          -DLIBCURL_ROOT_DIR="/usr/src/curl-${LIBCURL_VERSION}" \
          -DTAPCFG_ROOT_DIR="/usr/src/tapcfg" \
          -DCROSS_COMPILER="i686-w64-mingw32" \
          -DWITH_GUI="no" \
          ../netvirt && \
    make netvirt-agent2 VERBOSE=1 && \
    makensis -DLIBRESSL_PATH="/usr/src/libressl-${LIBRESSL_VERSION}" \
             -DLIBEVENT_PATH="/usr/src/libevent-${LIBEVENT_VERSION}-stable" \
             -DLIBCURL_PATH="/usr/src/curl-${LIBCURL_VERSION}" \
             -DLIBJANSSON_PATH="/usr/src/jansson-${LIBJANSSON_VERSION}" \
             -DTAPCFG_PATH="/usr/src/tapcfg" \
             -DMINGW_PATH="/usr/lib/gcc/i686-w64-mingw32/6.3-win32" \
             -DBDIR="${PWD}" \
             -DOUTFILE="/tmp/netvirt-agent2-cli_x86.exe" \
             ../netvirt/win32/package_win32_cli.nsi && \
    true
