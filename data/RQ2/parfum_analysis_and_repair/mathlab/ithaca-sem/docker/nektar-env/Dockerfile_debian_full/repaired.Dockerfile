FROM %%REGISTRY%%:env-%%OS_VERSION%%-default

LABEL maintainer="Nektar++ Development Team <nektar-users@imperial.ac.uk>"

USER root
COPY docker/nektar-env/${DEBIAN_VERSION}_full_packages.txt packages.txt

RUN echo "deb http://deb.debian.org/debian ${DEBIAN_VERSION} non-free" > \
        /etc/apt/sources.list.d/debian-non-free.list && \
        apt-get update && \
        apt-get install --no-install-recommends -y $(cat packages.txt) \
        && rm -rf /var/lib/apt/lists/*

USER nektar:nektar
