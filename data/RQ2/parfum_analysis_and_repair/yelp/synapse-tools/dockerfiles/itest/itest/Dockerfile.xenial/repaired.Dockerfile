FROM docker-dev.yelpcorp.com/xenial_pkgbuild

ARG PIP_INDEX_URL=https://pypi.yelpcorp.com/simple
ENV PIP_INDEX_URL=$PIP_INDEX_URL

# Need Python 3.7
RUN apt-get update > /dev/null && \
    apt-get install -y --no-install-recommends software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get -y --no-install-recommends install \
    libcurl3 \
    iptables \
    python3.7 \
    python-setuptools \
    python-pytest \
    python-pycurl \
    python-kazoo \
    python-zope.interface \
    ruby \
    ruby-dev \
    libxml2 \
    libxml2-dev \
    libxslt-dev \
    build-essential \
    zlib1g-dev \
    nginx \
    liblua5.3-dev \
    libssl-dev \
    wget \
    rsyslog && rm -rf /var/lib/apt/lists/*;

# HAProxy configured with Lua scripting
WORKDIR /
RUN wget https://www.haproxy.org/download/1.7/src/haproxy-1.7.8.tar.gz -O /haproxy.tar.gz
RUN tar -axvf /haproxy.tar.gz && rm /haproxy.tar.gz
WORKDIR /haproxy-1.7.8
RUN make TARGET=linux26 \
    USE_LUA=1 \
    LUA_LIB=/usr/lib/x86_64-linux-gnu \
    LUA_INC=/usr/include/lua5.3 \
    && mv haproxy /usr/bin/haproxy-synapse

# Pin for test reproducibility
RUN gem install --no-ri --no-rdoc nokogiri -v 1.6.7.2
RUN gem install --no-ri --no-rdoc synapse -v 0.14.1
RUN gem install --no-ri --no-rdoc synapse-nginx -v 0.2.2

ADD synapse.conf /etc/init/synapse.conf
ADD synapse.conf.json /etc/synapse/synapse.conf.json
ADD synapse-tools.conf.json /etc/synapse/synapse-tools.conf.json
ADD synapse-tools-both.conf.json /etc/synapse/synapse-tools-both.conf.json
ADD synapse-tools-nginx.conf.json /etc/synapse/synapse-tools-nginx.conf.json

# Zookeeper discovery
RUN mkdir -p /nail/etc/zookeeper_discovery/infrastructure
ADD zookeeper_discovery/infrastructure/local.yaml.xenial /nail/etc/zookeeper_discovery/infrastructure/local.yaml

ADD yelpsoa-configs /nail/etc/services
ADD srv-configs /nail/srv/configs
ADD habitat /nail/etc/habitat
ADD ecosystem /nail/etc/ecosystem
ADD region /nail/etc/region
ADD itest.py /itest.py
ADD run_itest.sh /run_itest.sh
ADD rsyslog-configs/49-haproxy.conf /etc/rsyslog.d/49-haproxy.conf
ADD maps/ip_to_service.map /var/run/synapse/maps/ip_to_service.map

# configure_synapse tries to restart synapse.
# make it think it succeeded.
RUN ln -sf /bin/true /usr/sbin/service

CMD /bin/bash /run_itest.sh
