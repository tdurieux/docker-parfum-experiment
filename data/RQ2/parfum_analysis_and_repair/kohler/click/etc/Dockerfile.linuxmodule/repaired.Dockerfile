FROM ubuntu:wily

MAINTAINER tom.barbette@uclouvain.be

RUN \
        sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list \
        && apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y build-essential \
            git vim linux-image-generic linux-headers-generic \
        && cp /boot/config-*-generic /usr/src/linux-headers-*/.config \
        && apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /

RUN git clone http://github.com/kohler/click.git

WORKDIR /click

RUN \
        l=$(bash -c 'd=(/usr/src/linux-*-generic)&&echo $d') \
        && cp /boot/config* $l/.config \
        && map=$(bash -c 'd=(/boot/System.map-*)&&echo $d') \
        && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-linuxmodule --disable-userlevel --enable-all-elements --with-linux=$l --with-linux-map=$map \
        && make \
        && ln -s /bin/zcat /bin/gzcat \
        && make install

ENTRYPOINT ["/click/bin/click-install"]
