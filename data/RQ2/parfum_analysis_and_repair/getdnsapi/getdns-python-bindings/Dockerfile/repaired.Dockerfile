FROM  ubuntu:16.04
MAINTAINER Melinda Shore <melinda.shore@nomountain.net>

RUN set -ex \
    && apt-get update \
    && apt-get install --no-install-recommends -y curl \
    && apt-get install --no-install-recommends -y git \
    && apt-get install --no-install-recommends -y wget \
    && apt-get install --no-install-recommends -y libssl-dev \
    && curl -fOSL "https://unbound.net/downloads/unbound-1.6.3.tar.gz" \
    && mkdir -p /usr/src/unbound \
    && tar -xzC /usr/src/unbound --strip-components=1 -f unbound-1.6.3.tar.gz \
    && rm unbound-1.6.3.tar.gz \
    && apt-get -y --no-install-recommends install libidn11-dev \
    && apt-get -y --no-install-recommends install python-dev \
    && apt-get -y --no-install-recommends install make \
    && apt-get install --no-install-recommends -y automake autoconf libtool \
    && apt-get install --no-install-recommends -y shtool \
    && cd /usr/src/unbound \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install \
    && ldconfig \
    && cd /usr/src \
    && git clone https://github.com/getdnsapi/getdns.git \
    && cd /usr/src/getdns \
    && git checkout release/1.1.1 \
    && git submodule update --init \
    && libtoolize -ci \
    && autoreconf -fi \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install \
    && ldconfig \
    && mkdir -p /etc/unbound \
    && cd /etc/unbound \
    && wget https://www.nomountain.net/getdns-root.key \
    && cd /usr/src \
    && git clone https://github.com/getdnsapi/getdns-python-bindings.git \
    && cd /usr/src/getdns-python-bindings \
    && git checkout develop \
    && python setup.py build \
    && python setup.py install && rm -rf /usr/src/unbound && rm -rf /var/lib/apt/lists/*;


CMD ["/usr/bin/python"]
