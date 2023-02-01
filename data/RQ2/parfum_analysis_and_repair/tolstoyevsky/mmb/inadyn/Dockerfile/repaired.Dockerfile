FROM cusdeb/alpine3.7:amd64
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV INADYN_VERSION v2.1
ENV LIBITE_VERSION v1.8.3
ENV LIBCONFUSE_VERSION v3.0

RUN apk --update add \
    automake \
    autoconf \
    build-base \
    ca-certificates \
    curl \
    flex \
    # gettext \
    gettext-dev \
    git \
    libtool \
    openssl-dev \
    tar \
 && mkdir -p /tmp/src/inadyn /tmp/src/libconfuse /tmp/src/libite \
 # libConfuse \
 && curl -f -Lo /tmp/src/libconfuse.tar.gz https://github.com/martinh/libconfuse/archive/$LIBCONFUSE_VERSION.tar.gz \
 && tar -C /tmp/src/libconfuse --strip-components=1 -xzvf /tmp/src/libconfuse.tar.gz \
 && cd /tmp/src/libconfuse && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && make && make install \
 # libite
 && curl -f -Lo /tmp/src/libite.tar.gz https://github.com/troglobit/libite/archive/$LIBITE_VERSION.tar.gz \
 && tar -C /tmp/src/libite --strip-components=1 -xzvf /tmp/src/libite.tar.gz \
 && cd /tmp/src/libite && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && make && make install-strip \
 # inadyn
 && curl -f -Lo /tmp/src/inadyn.tar.gz https://github.com/troglobit/inadyn/archive/$INADYN_VERSION.tar.gz \
 && tar -C /tmp/src/inadyn --strip-components=1 -xzvf /tmp/src/inadyn.tar.gz \
 && cd /tmp/src/inadyn && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-openssl && make && make install \
 # cleanup
 && rm -rf /tmp/src \
 && apk del \
    automake \
    autoconf \
    build-base \
    curl \
    flex \
    git \
    libtool \
    tar \
 && rm -rf /var/cache/apk/* && rm /tmp/src/libconfuse.tar.gz

ENTRYPOINT ["/usr/local/sbin/inadyn", "--foreground"]
CMD ["--loglevel=info"]
