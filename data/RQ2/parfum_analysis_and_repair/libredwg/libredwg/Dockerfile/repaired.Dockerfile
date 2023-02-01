# podman/docker build -t libredwg .
############################
# STEP 1 build package from latest tar.xz
############################

FROM python:3.7.7-buster AS extracting
# libxml2-dev is broken so we need to compile it by our own
ARG LIBXML2VER=2.9.9
RUN apt-get update && \
    apt-get install -y --no-install-recommends autoconf libtool swig texinfo \
            build-essential gcc libxml2 python3-libxml2 libpcre2-dev libpcre2-32-0 curl \
            libperl-dev libxml2-dev && \
    mkdir libxmlInstall && cd libxmlInstall && \
    wget ftp://xmlsoft.org/libxml2/libxml2-$LIBXML2VER.tar.gz && \
    tar xf libxml2-$LIBXML2VER.tar.gz && \
    cd libxml2-$LIBXML2VER/ && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    make install && \
    cd /libxmlInstall && \
    rm -rf gg libxml2-$LIBXML2VER.tar.gz libxml2-$LIBXML2VER && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
RUN tarxz=$( curl -f --silent 'https://ftp.gnu.org/gnu/libredwg/?C=M;O=D' | grep '.tar.xz<' | \
         head -n1 | sed -E 's/.*href="([^"]+)".*/\1/') ; \
    echo "latest release $tarxz"; \
    curl -f --silent --output "$tarxz" https://ftp.gnu.org/gnu/libredwg/$tarxz && \
    mkdir libredwg && \
    tar -C libredwg --xz --strip-components 1 -xf "$tarxz" && \
    rm "$tarxz" && \
    cd libredwg && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-bindings --enable-release && \
    make -j `nproc` && \
    mkdir install && \
    make install DESTDIR="$PWD/install" && \
    make check DOCKER=1 DESTDIR="$PWD/install"

############################
# STEP 2 install into stable-slim
############################

FROM debian:stable-slim
COPY --from=extracting /app/libredwg/install/usr/local/bin/* /usr/local/bin/
COPY --from=extracting /app/libredwg/install/usr/local/include/* /usr/local/include/
COPY --from=extracting /app/libredwg/install/usr/local/lib/* /usr/local/lib/
COPY --from=extracting /app/libredwg/install/usr/local/share/* /usr/local/share/
RUN ldconfig

CMD [ "sh" ]
