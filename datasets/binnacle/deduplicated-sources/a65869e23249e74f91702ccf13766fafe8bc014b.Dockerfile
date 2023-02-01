FROM bitnami/oraclelinux-runtimes:7-r349
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gcc gcc-c++ git glibc keyutils-libs krb5-libs libcom_err libselinux libtool make ncurses-libs nss-softokn-freebl openssl-libs patch pcre pkgconfig readline unzip wget zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/ruby-2.4.6-0-linux-x86_64-ol-7.tar.gz && \
    echo "09e98e42c237283ef4ae5887ef105cc356edcc9744a8591262756cf4c1402da5  /tmp/bitnami/pkg/cache/ruby-2.4.6-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/ruby-2.4.6-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/ruby-2.4.6-0-linux-x86_64-ol-7.tar.gz

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.4.6-ol-7-r75" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

EXPOSE 3000

WORKDIR /app
CMD [ "irb" ]
