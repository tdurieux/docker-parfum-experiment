FROM debian:stretch as openssl
LABEL maintainer="Matthew Vance"

ENV VERSION_OPENSSL=openssl-1.1.1c \
    SHA256_OPENSSL=f6fb3079ad15076154eda9413fed42877d668e7069d9b87396d0804fdb3f4c90 \
    SOURCE_OPENSSL=https://www.openssl.org/source/ \
    OPGP_OPENSSL=7953AC1FBC3DC8B3B292393ED5E9E43F7DF9EE8C

WORKDIR /tmp/src

RUN set -e -x && \
    build_deps="build-essential ca-certificates curl dirmngr gnupg libidn2-0-dev libssl-dev" && \
    DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
      $build_deps && \
    curl -f -L $SOURCE_OPENSSL$VERSION_OPENSSL.tar.gz -o openssl.tar.gz && \
    echo "${SHA256_OPENSSL}  ./openssl.tar.gz" | sha256sum -c - && \
    curl -f -L $SOURCE_OPENSSL$VERSION_OPENSSL.tar.gz.asc -o openssl.tar.gz.asc && \
    GNUPGHOME="$(mktemp -d)" && \
    export GNUPGHOME && \
    ( gpg --batch --no-tty --keyserver ipv4.ha.pool.sks-keyservers.net --recv-keys "$OPGP_OPENSSL" \
    || gpg --batch --no-tty --keyserver ha.pool.sks-keyservers.net --recv-keys "$OPGP_OPENSSL") && \
    gpg --batch --verify openssl.tar.gz.asc openssl.tar.gz && \
    tar xzf openssl.tar.gz && \
    cd $VERSION_OPENSSL && \
    ./config --prefix=/opt/openssl no-weak-ssl-ciphers no-ssl3 no-shared enable-ec_nistp_64_gcc_128 -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong && \
    make depend && \
    make && \
    make install_sw && \
    apt-get purge -y --auto-remove \
      $build_deps && \
    rm -rf \
        /tmp/* \
        /var/tmp/* \
        /var/lib/apt/lists/* && rm openssl.tar.gz

FROM debian:stretch
LABEL maintainer="Matthew Vance"

ENV NAME=unbound \
    UNBOUND_VERSION=1.7.3 \
    UNBOUND_SHA256=c11de115d928a6b48b2165e0214402a7a7da313cd479203a7ce7a8b62cba602d \
    UNBOUND_DOWNLOAD_URL=https://nlnetlabs.nl/downloads/unbound/unbound-1.7.3.tar.gz \
    VERSION=1 \
    SUMMARY="${NAME} is a validating, recursive, and caching DNS resolver." \
    DESCRIPTION="${NAME} is a validating, recursive, and caching DNS resolver."

LABEL summary="${SUMMARY}" \
      description="${DESCRIPTION}" \
      io.k8s.description="${DESCRIPTION}" \
      io.k8s.display-name="Unbound ${UNBOUND_VERSION}" \
      name="mvance/${NAME}" \
      maintainer="Matthew Vance"

EXPOSE 53

WORKDIR /tmp/src

COPY --from=openssl /opt/openssl /opt/openssl

RUN build_deps="ca-certificates curl gcc libc-dev libevent-dev libexpat1-dev make" && \
    set -x && \
    DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
      $build_deps \
      bsdmainutils \
      ldnsutils \
      libevent-2.0 \
      libexpat1 && \
    curl -f -sSL $UNBOUND_DOWNLOAD_URL -o unbound.tar.gz && \
    echo "${UNBOUND_SHA256}  *unbound.tar.gz" | sha256sum -c - && \
    tar xzf unbound.tar.gz && \
    rm -f unbound.tar.gz && \
    cd unbound-1.7.3 && \
    groupadd _unbound && \
    useradd -g _unbound -s /etc -d /dev/null _unbound && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        --disable-dependency-tracking \
        --prefix=/opt/unbound \
        --with-pthreads \
        --with-username=_unbound \
        --with-ssl=/opt/openssl \
        --with-libevent \
        --enable-event-api && \
    make install && \
    mv /opt/unbound/etc/unbound/unbound.conf /opt/unbound/etc/unbound/unbound.conf.example && \
    apt-get purge -y --auto-remove \
      $build_deps && \
    rm -rf \
        /opt/unbound/share/man \
        /tmp/* \
        /var/tmp/* \
        /var/lib/apt/lists/*

COPY a-records.conf /opt/unbound/etc/unbound/
COPY unbound.sh /

RUN chmod +x /unbound.sh

WORKDIR /opt/unbound/

ENV PATH /opt/unbound/sbin:"$PATH"

CMD ["/unbound.sh"]
