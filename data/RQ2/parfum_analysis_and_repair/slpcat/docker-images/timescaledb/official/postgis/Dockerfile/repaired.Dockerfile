ARG PG_VERSION_TAG
FROM timescale/timescaledb:1.2.2-${PG_VERSION_TAG}

MAINTAINER Timescale https://www.timescale.com
ARG POSTGIS_VERSION
ENV POSTGIS_VERSION ${POSTGIS_VERSION:-2.5.0}

RUN set -ex \
    && apk add --no-cache --virtual .fetch-deps \
                ca-certificates \
                openssl \
                tar \
    # add libcrypto from (edge:main) for gdal-2.3.0
    && apk add --no-cache --virtual .crypto-rundeps \
                --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
                libressl2.7-libcrypto \
                libcrypto1.1 \
    && apk add --no-cache --virtual .postgis-deps --repository http://nl.alpinelinux.org/alpine/edge/testing \
        geos \
        gdal \
        proj4 \
        protobuf-c \
    && apk add --no-cache --virtual .build-deps --repository http://nl.alpinelinux.org/alpine/edge/testing \
        postgresql-dev \
        perl \
        file \
        geos-dev \
        libxml2-dev \
        gdal-dev \
        proj4-dev \
        protobuf-c-dev \
        json-c-dev \
        gcc g++ \
        make \
    && cd /tmp \
    && wget https://download.osgeo.org/postgis/source/postgis-${POSTGIS_VERSION}.tar.gz -O - | tar -xz \
    && chown root:root -R postgis-${POSTGIS_VERSION} \
    && cd /tmp/postgis-${POSTGIS_VERSION} \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && echo "PERL = /usr/bin/perl" >> extensions/postgis/Makefile \
    && echo "PERL = /usr/bin/perl" >> extensions/postgis_topology/Makefile \
    && make -s \
    && make -s install \
    && apk add --no-cache --virtual .postgis-rundeps \
        json-c \
    && cd / \

    && rm -rf /tmp/postgis-${POSTGIS_VERSION} \
    && apk del .fetch-deps .build-deps
