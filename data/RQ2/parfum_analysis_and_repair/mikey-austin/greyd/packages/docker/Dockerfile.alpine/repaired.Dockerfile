FROM alpine

COPY . /var/build
WORKDIR /var/build

RUN apk add --update-cache \
        gcc \
        build-base \
        libtool \
        libltdl \
        make \
        pkgconfig \
        automake \
        autoconf \
        curl \
        zlib zlib-dev \
        openssl openssl-dev \
        db db-dev \
        libcap libcap-dev \
        ipset ipset-dev \
        libmnl libmnl-dev \
        libnetfilter_conntrack libnetfilter_conntrack-dev \
        libnetfilter_log libnetfilter_log-dev \
        libspf2 libspf2-dev \
        sqlite sqlite-dev \
        mariadb-client \
        mariadb-connector-c \
        mariadb-connector-c-dev \
        #
        # Build and install the software.
        #
        && autoreconf -i \
        && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        DEFAULT_CONFIG="/usr/local/etc/greyd/greyd.docker.conf" \
        GREYD_PIDFILE="/tmp/greyd.pid" \
        GREYLOGD_PIDFILE="/tmp/greylogd.pid" \
        --with-mysql \
        --with-bdb \
        --with-sqlite \
        --with-netfilter \
        --with-spf \
        && make \
        && make install \
        && rm -rf /var/build \
        #
        # Remove dev packages
        #
        && apk del \
        gcc \
        build-base \
        make \
        pkgconfig \
        automake \
        autoconf \
        zlib-dev \
        openssl-dev \
        db-dev \
        libcap-dev \
        ipset-dev \
        libmnl-dev \
        libnetfilter_conntrack-dev \
        libnetfilter_log-dev \
        mariadb-connector-c-dev \
        libspf2-dev \
        #
        # Remove package cache
        #
        && rm -rf /var/cache/apk/*

EXPOSE 8025/tcp

RUN ln -sf /dev/stdout /tmp/greyd.log
RUN addgroup -S greyd
RUN addgroup -S greydb
RUN adduser -HSD greyd greyd
RUN adduser -HSD greydb greydb

ENTRYPOINT [ "/usr/local/sbin/greyd", "-F" ]
