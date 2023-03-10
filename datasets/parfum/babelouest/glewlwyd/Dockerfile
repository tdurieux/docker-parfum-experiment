FROM alpine:latest AS builder

COPY README.md /opt/glewlwyd/README.md
COPY CHANGELOG.md /opt/glewlwyd/CHANGELOG.md
COPY docs/ /opt/glewlwyd/docs/
COPY src/ /opt/glewlwyd/src/
COPY CMakeLists.txt /opt/glewlwyd/
COPY cmake-modules/ /opt/glewlwyd/cmake-modules/
COPY webapp/ /opt/glewlwyd/webapp/

# Install required packages
RUN apk add --no-cache \
    git \
    make \
    cmake \
    wget \
    gcc \
    g++ \
    jansson-dev \
    gnutls-dev \
    autoconf \
    automake \
    libmicrohttpd-dev \
    libcurl \
    curl-dev \
    libconfig-dev \
    libgcrypt-dev \
    sqlite-dev \
    mariadb-dev \
    postgresql-dev \
    util-linux-dev \
    openldap-dev \
    bash \
    oath-toolkit-dev \
    libtool \
    libcbor-dev && \
    mkdir /opt/glewlwyd/build && cd /opt/glewlwyd/build/ && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib -DWITH_JOURNALD=off .. && \
    make && make install

FROM alpine:latest AS runner
RUN apk add --no-cache \
    wget \
    sqlite \
    libconfig \
    jansson \
    gnutls \
    libcurl \
    libldap \
    libmicrohttpd \
    sqlite-libs \
    libpq \
    oath-toolkit-liboath \
    mariadb-connector-c \
    libcbor \
    bash

COPY --from=builder /usr/lib/liborcania* /usr/lib/
COPY --from=builder /usr/lib/libyder* /usr/lib/
COPY --from=builder /usr/lib/libhoel* /usr/lib/
COPY --from=builder /usr/lib/libulfius* /usr/lib/
COPY --from=builder /usr/lib/librhonabwy* /usr/lib/
COPY --from=builder /usr/lib/libiddawc* /usr/lib/
COPY --from=builder /usr/lib/glewlwyd/ /usr/lib/glewlwyd/
COPY --from=builder /usr/bin/glewlwyd /usr/bin
COPY --from=builder /usr/share/glewlwyd/ /usr/share/glewlwyd/
COPY --from=builder /usr/share/glewlwyd/webapp/config.json /etc/glewlwyd/
COPY --from=builder /usr/etc/glewlwyd/ /etc/glewlwyd/

RUN rm /usr/share/glewlwyd/webapp/config.json
RUN cp /etc/glewlwyd/config.json /usr/share/glewlwyd/webapp/config.json

COPY ["docs/docker/entrypoint.sh", "/"]

CMD ["/entrypoint.sh"]
