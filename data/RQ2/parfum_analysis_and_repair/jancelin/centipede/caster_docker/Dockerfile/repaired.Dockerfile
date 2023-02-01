ARG DISTRO=debian
ARG IMAGE_VERSION=bullseye
ARG IMAGE_VARIANT=slim
FROM $DISTRO:$IMAGE_VERSION-$IMAGE_VARIANT AS Ntrip-caster

LABEL maintainer="Julien Ancelin<julien.ancelin@inrae.fr>"

RUN apt-get -qq update --fix-missing && apt-get -qq --yes upgrade

RUN set -eux \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        gcc cmake bzip2 telnet libpq-dev && rm -rf /var/lib/apt/lists/*;
COPY ntripcaster-2.0.37.tar.bz2 /
RUN tar xfvj /ntripcaster-2.0.37.tar.bz2 && rm /ntripcaster-2.0.37.tar.bz2
WORKDIR ./ntripcaster-2.0.37
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN make install
WORKDIR /usr/local/ntripcaster
EXPOSE 443 80 2101

# Cleanup resources
RUN apt-get -y --purge autoremove  \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# start env parameters
COPY docker-entrypoint.sh .
RUN chmod +x /usr/local/ntripcaster/docker-entrypoint.sh

ENTRYPOINT /usr/local/ntripcaster/docker-entrypoint.sh
