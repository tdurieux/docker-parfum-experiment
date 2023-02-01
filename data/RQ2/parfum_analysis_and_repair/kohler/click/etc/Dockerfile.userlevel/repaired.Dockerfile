FROM ubuntu:jammy

MAINTAINER tom.barbette@uclouvain.be

RUN apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y build-essential meson \
        pkg-config libnuma-dev python3-pyelftools libpcap-dev libclang-dev python3-pip git vim dpdk \
        && apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /

RUN git clone http://github.com/kohler/click.git

WORKDIR /click

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-all-elements \
        && make \
        && ln -s /bin/zcat /bin/gzcat \
        && make install

ENTRYPOINT ["/click/userlevel/click"]
