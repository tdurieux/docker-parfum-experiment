FROM debian:%%OS_VERSION%%-slim

LABEL maintainer="Nektar++ Development Team <nektar-users@imperial.ac.uk>"

ENV DEBIAN_VERSION %%OS_VERSION%%
COPY docker/nektar-env/${DEBIAN_VERSION}_default_packages.txt packages.txt

RUN echo "deb http://deb.debian.org/debian ${DEBIAN_VERSION} non-free" > \
        /etc/apt/sources.list.d/debian-non-free.list && \
        apt-get update && \
        apt-get install --no-install-recommends -y $(cat packages.txt) \
        && rm -rf /var/lib/apt/lists/*
RUN ln -s /usr/bin/ccache /usr/local/bin/cc && ln -s /usr/bin/ccache /usr/local/bin/c++

RUN groupadd nektar && useradd -m -g nektar nektar
USER nektar:nektar
RUN mkdir /home/nektar/nektar
WORKDIR /home/nektar/nektar
