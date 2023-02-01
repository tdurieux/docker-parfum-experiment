FROM quay.io/azavea/postgis:2.3-postgres9.6-slim
MAINTAINER Azavea
LABEL type=pfb-analysis

ENV GIT_BRANCH_OSM2PGROUTING osm2pgrouting-2.1.0
ENV GIT_BRANCH_OSM2PGSQL 0.90.1
ENV GIT_BRANCH_QUANTILE master

# Copy django requirements (will copy the rest later, so that any change to
# the code doesn't trigger re-running the whole provisioning step)
COPY ./django/requirements.txt /opt/pfb/django/requirements.txt

# Install apt and pip packages
# Installs everything then removes the build dependencies all in one gigantic command to
# avoid making a build layer that includes the dependencies that we don't need to keep permanently.
# The 'hash -r' after upgrading pip is because otherwise the subsequent 'pip install' command will
# still use the old version.
RUN set -xe && \
    BUILD_DEPS=" \
        postgresql-server-dev-$PG_MAJOR \
        libexpat1-dev \
        cmake \
        libboost-all-dev make \
        g++ \
        zlib1g-dev \
        libbz2-dev \
        libpq-dev \
        libgeos-dev \
        libgeos++-dev \
        libproj-dev \
        libgdal-dev \
        git" \
    DEPS=" \
        ca-certificates \
        liblua5.2-dev \
        lua5.2 \
        expat \
        wget \
        bc \
        time \
        parallel \
        postgresql-plpython-$PG_MAJOR \
        postgresql-$PG_MAJOR-pgrouting \
        python-gdal \
        gdal-bin \
        unzip \
        zip \
        postgis \
        python-dev \
        python-pip" && \
    apt-get update && apt-get install -y ${BUILD_DEPS} ${DEPS} --no-install-recommends && \
    \
    mkdir /tmp/build/ && cd /tmp/build && \
      git clone --branch $GIT_BRANCH_OSM2PGROUTING https://github.com/pgRouting/osm2pgrouting.git && \
        (cd osm2pgrouting && mkdir build && cmake -H. -Bbuild && cd build && make install) && \
      git clone --branch $GIT_BRANCH_OSM2PGSQL https://github.com/openstreetmap/osm2pgsql.git && \
        (cd osm2pgsql && mkdir build && cd build && cmake ../ && make install) && \
      git clone --branch $GIT_BRANCH_QUANTILE https://github.com/tvondra/quantile.git && \
        (cd quantile && make install) && \
    \
    pip install --upgrade pip setuptools && \
    hash -r && \
    pip install -r /opt/pfb/django/requirements.txt && \
    \
    cd /tmp/ && rm -rf /tmp/build/ /var/lib/apt/lists/* && \
    apt-get purge -y --auto-remove ${BUILD_DEPS}

RUN set -xe && \
    wget -q "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" && \
    unzip awscli-bundle.zip && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
    rm -r ./awscli-bundle*

RUN set -xe && \
    wget -q -O /usr/local/bin/osmconvert "https://s3.amazonaws.com/pfb-binaries-us-east-1/osmconvert64" && \
    chmod +x /usr/local/bin/osmconvert

COPY ./django /opt/pfb/django

COPY ./analysis/scripts/setup_database.sh /docker-entrypoint-initdb.d/setup_database.sh
COPY ./analysis/ /opt/pfb/analysis/

ENTRYPOINT /opt/pfb/analysis/scripts/entrypoint.sh
