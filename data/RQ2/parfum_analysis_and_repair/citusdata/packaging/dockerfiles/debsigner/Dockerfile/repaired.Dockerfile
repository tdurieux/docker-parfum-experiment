# vim:set ft=dockerfile:
FROM ubuntu:xenial

# install build tools and PostgreSQL development files
RUN apt-get update \
    && apt-get install -y --no-install-recommends debsigs expect \
    && rm -rf /var/lib/apt/lists/*

# place scripts on path and declare output volume
ENV PATH /scripts:$PATH
COPY scripts /scripts
VOLUME /packages

ENTRYPOINT ["/scripts/import_and_sign"]