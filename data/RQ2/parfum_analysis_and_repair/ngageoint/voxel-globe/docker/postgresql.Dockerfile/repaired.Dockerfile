FROM postgres:9.5.3

MAINTAINER Andrew Neff <andrew.neff@visionsystemsinc.com>

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        postgresql-9.5-postgis-2.2 && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y wget && \
    cd /usr/share/proj && \
    wget https://download.osgeo.org/proj/vdatum/egm96_15/egm96_15.gtx && \
    DEBIAN_FRONTEND=noninteractive apt-get purge -y --auto-remove wget && \
    rm -rf /var/lib/apt/lists/*

ARG TINI_VERSION=v0.9.0
RUN build_deps='curl ca-certificates' && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ${build_deps} && \
    curl -f -Lo /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini && \
    curl -f -Lo /tini.asc https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc && \
    chmod +x /tini && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys 0527A9B7 && \
    gpg --batch --verify /tini.asc /tini && \
    DEBIAN_FRONTEND=noninteractive apt-get purge -y --auto-remove ${build_deps} && \
    rm -r /var/lib/apt/lists/* && rm -rf -d

EXPOSE 5432

ENV USER_ID=999 \
    GROUP_ID=999

COPY 00_init_postgis.sql /docker-entrypoint-initdb.d/

ADD postgresql_entrypoint.bsh /

ENTRYPOINT ["/tini", "--", "/postgresql_entrypoint.bsh"]

CMD ["postgres"]