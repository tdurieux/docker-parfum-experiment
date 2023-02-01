# Docker Parliament triple store

# Requires appropriate credentials and docker login to Ironbank repo:
FROM registry1.dso.mil/ironbank/redhat/openjdk/openjdk8-devel:latest

USER root

RUN dnf clean all
RUN rm -rf /var/cache/dnf

RUN useradd --system --user-group --uid 501 tenant

RUN mkdir -p /var/parliament-data
RUN chmod -R u=rwx,go=rx /var/parliament-data
RUN chown -R tenant:tenant /var/parliament-data

ARG parliament_version
COPY parliament-$parliament_version /opt/parliament-$parliament_version/

# These are needed because the unzip task in ant doesn't preserve file permissions: