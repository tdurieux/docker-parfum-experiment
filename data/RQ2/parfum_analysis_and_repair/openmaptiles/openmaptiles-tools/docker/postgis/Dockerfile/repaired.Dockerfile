# There is an issue updating to postgis 12:
# the postgis base image has outdated ogr2ogr (gdal-bin package)
# does not support PG12 yet, which means postgis-preloaded cannot be built easily.
# Once it is updated, or there is a different way to build it, we can upgrade to 12.
ARG BASE_POSTGIS_VER=9.6-3.1
FROM postgis/postgis:$BASE_POSTGIS_VER

LABEL maintainer="Yuri Astrakhan <YuriAstrakhan@gmail.com>"

# https://github.com/libgeos/geos/releases
ARG GEOS_VER=3.9.1

# https://github.com/pramsey/pgsql-gzip/releases
ARG PGSQL_GZIP_TAG=v1.0.0
ARG PGSQL_GZIP_REPO=https://github.com/pramsey/pgsql-gzip.git

# https://github.com/JuliaLang/utf8proc/releases
ARG UTF8PROC_TAG=v2.5.0
ARG UTF8PROC_REPO=https://github.com/JuliaLang/utf8proc.git

# osml10n - https://github.com/openmaptiles/mapnik-german-l10n/releases
ARG MAPNIK_GERMAN_L10N_TAG=v2.5.9.1
ARG MAPNIK_GERMAN_L10N_REPO=https://github.com/openmaptiles/mapnik-german-l10n.git


RUN set -eux  ; \
    apt-get -qq -y update  ; \
    ##
    ## Install build dependencies
    apt-get -qq -y --no-install-recommends install \
        build-essential \
        ca-certificates \
        # Required by Nominatim to download data files
        curl \
        git \
        pandoc \
        # $PG_MAJOR is declared in postgres docker
        postgresql-server-dev-$PG_MAJOR \
        libkakasi2-dev \
        libgdal-dev \
    ; \
    ## Install specific GEOS version
    cd /opt/  ; \
    curl -f -o /opt/geos.tar.bz2 https://download.osgeo.org/geos/geos-${GEOS_VER}.tar.bz2; \
    mkdir /opt/geos  ; \
    tar xf /opt/geos.tar.bz2 -C /opt/geos --strip-components=1  ; rm /opt/geos.tar.bz2 \
    cd /opt/geos/  ; \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
    make -j  ; \
    make install  ; \
    rm -rf /opt/geos*  ; \
    ##
    ## gzip extension
    cd /opt/  ; \
    git clone --quiet --depth 1 -b $PGSQL_GZIP_TAG $PGSQL_GZIP_REPO  ; \
    cd pgsql-gzip  ; \
    make  ; \
    make install  ; \
    rm -rf /opt/pgsql-gzip  ; \
    ##
    ## UTF8Proc
    cd /opt/  ; \
    git clone --quiet --depth 1 -b $UTF8PROC_TAG $UTF8PROC_REPO  ; \
    cd utf8proc  ; \
    make  ; \
    make install  ; \
    ldconfig  ; \
    rm -rf /opt/utf8proc  ; \
    ##
    ## osml10n extension (originally Mapnik German)
    cd /opt/  ; \
    git clone --quiet --depth 1 -b $MAPNIK_GERMAN_L10N_TAG $MAPNIK_GERMAN_L10N_REPO  ; \
    cd mapnik-german-l10n  ; \
    make  ; \
    make install  ; \
    rm -rf /opt/mapnik-german-l10n  ; \
    ##
    ## Cleanup
    apt-get -qq -y --auto-remove purge \
        autoconf \
        automake \
        autotools-dev \
        build-essential \
        ca-certificates \
        bison \
        cmake \
        curl \
        dblatex \
        docbook-mathml \
        docbook-xsl \
        git \
        libcunit1-dev \
        libtool \
        make \
        g++ \
        gcc \
        pandoc \
        unzip \
        xsltproc \
        libpq-dev \
        postgresql-server-dev-$PG_MAJOR \
        libxml2-dev \
        libjson-c-dev \
        libgdal-dev \
    ; \
    rm -rf /usr/local/lib/*.a  ; \
    rm -rf /var/lib/apt/lists/*

# The script should run after the parent's 10_postgis.sh runs
# so it must have the name that's listed after that.
COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/20_omt_postgis.sh
