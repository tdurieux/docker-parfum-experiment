FROM zeromqorg/gsl

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y -q && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y -q --force-yes build-essential autoconf automake libtool pkg-config && rm -rf /var/lib/apt/lists/*;

COPY packaging/docker/run_zproto.sh /usr/local/bin/run_zproto.sh

COPY . /tmp/zproto
WORKDIR /tmp/zproto
RUN ( ./autogen.sh; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; make check; make install)
RUN rm -rf /tmp/zproto
ENTRYPOINT ["run_zproto.sh"]
