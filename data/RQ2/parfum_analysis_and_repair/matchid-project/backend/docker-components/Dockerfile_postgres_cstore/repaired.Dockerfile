FROM postgres:10.1
ARG proxy
ENV https_proxy $proxy

RUN apt-get update -y -qq && \
    apt-get -y --no-install-recommends -qq install protobuf-c-compiler libprotobuf-c0-dev unzip git build-essential && rm -rf /var/lib/apt/lists/*;

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        postgresql-server-dev-$PG_MAJOR=$PG_VERSION \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src
RUN git clone https://github.com/citusdata/cstore_fdw.git && \
    cd cstore_fdw && \
    make -j"$(nproc)" && \
    make install && \
    cd .. && \
    rm -rf cstore_fdw

WORKDIR /usr/src/postgres
