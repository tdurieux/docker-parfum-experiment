{%- set CRATE_TAR_GZ   = CRATE_URL.split("/")[-1] -%}
{%- set CRATE_FILENAME = CRATE_TAR_GZ.replace(".tar.gz", "") -%}
## -*- docker-image-name: "docker-crate" -*-
#
# Crate Dockerfile
# https://github.com/crate/docker-crate
#

FROM centos:7

RUN groupadd crate && useradd -u 1000 -g crate -d /crate crate

RUN curl -f --retry 8 -o /openjdk.tar.gz {{ JDK_URL }} \
    && echo "{{ JDK_SHA256 }} */openjdk.tar.gz" | sha256sum -c - \
    && tar -C /opt -zxf /openjdk.tar.gz \
    && rm /openjdk.tar.gz

ENV JAVA_HOME /opt/jdk-{{ JDK_VERSION }}

# REF: https://github.com/elastic/elasticsearch-docker/issues/171
RUN ln -sf /etc/pki/ca-trust/extracted/java/cacerts /opt/jdk-{{ JDK_VERSION }}/lib/security/cacerts

# install crate
RUN yum install -y yum-utils \
    && yum makecache \
    && yum install -y python36 openssl \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && curl -fSL -O {{ CRATE_URL }} \
    && curl -fSL -O {{ CRATE_URL }}.asc \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 90C23FC6585BC0717F8FBFC37FAAE51A06F6EAEB \
    && gpg --batch --verify {{ CRATE_TAR_GZ }}.asc {{ CRATE_TAR_GZ }} \
    && rm -rf "$GNUPGHOME" {{ CRATE_TAR_GZ }}.asc \
    && tar -xf {{ CRATE_TAR_GZ }} -C /crate --strip-components=1 \
    && rm {{ CRATE_TAR_GZ }} \
    && ln -sf /usr/bin/python3.6 /usr/bin/python3

# install crash
RUN curl -fSL -O {{ CRASH_URL }} \
    && curl -fSL -O {{ CRASH_URL }}.asc \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 90C23FC6585BC0717F8FBFC37FAAE51A06F6EAEB \
    && gpg --batch --verify crash_standalone_{{ CRASH_VERSION }}.asc crash_standalone_{{ CRASH_VERSION }} \
    && rm -rf "$GNUPGHOME" crash_standalone_{{ CRASH_VERSION }}.asc \
    && mv crash_standalone_{{ CRASH_VERSION }} /usr/local/bin/crash \
    && chmod +x /usr/local/bin/crash

ENV PATH /crate/bin:$PATH
# Default heap size for Docker, can be overwritten by args
ENV CRATE_HEAP_SIZE 512M

RUN mkdir -p /data/data /data/log

VOLUME /data

WORKDIR /data

# http: 4200 tcp
# transport: 4300 tcp
# postgres protocol ports: 5432 tcp
EXPOSE 4200 4300 5432

# These COPY commands have been moved before the last one due to the following issues:
# https://github.com/moby/moby/issues/37965#issuecomment-448926448
# https://github.com/moby/moby/issues/38866
COPY --chown=1000:0 config/crate.yml /crate/config/crate.yml
COPY --chown=1000:0 config/log4j2.properties /crate/config/log4j2.properties

LABEL maintainer="Crate.io <office@crate.io>" \
    org.opencontainers.image.created="{{ BUILD_TIMESTAMP }}" \
    org.opencontainers.image.title="crate" \
    org.opencontainers.image.description="CrateDB is a distributed SQL database that handles massive amounts of machine data in real-time." \
    org.opencontainers.image.url="https://crate.io/products/cratedb/" \
    org.opencontainers.image.source="https://github.com/crate/docker-crate" \
    org.opencontainers.image.vendor="Crate.io" \
    org.opencontainers.image.version="{{ CRATE_VERSION }}"

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["crate"]
