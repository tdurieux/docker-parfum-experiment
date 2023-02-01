# See https://github.com/alexarwine/docker-ubuntu-confd
# and https://github.com/jgoodall/docker-twemproxy

# expected values in etcd
#  - `/services/twemproxy/listen` : the host_ip:port the proxy will listen on
#  - `/services/twemproxy/servers/<num>` : enumeration of the redis servers for 01-N servers, in the format of host_ip:port
# example:
# etcdctl set /services/twemproxy/listen 10.10.100.1:6000
# etcdctl set /services/redis/01 10.10.100.11:6001
# etcdctl set /services/redis/02 10.10.100.12:6002

FROM ubuntu:18.04

ARG TWEMPROXY_VERSION
ENV DEBIAN_FRONTEND noninteractive

# Install basics
RUN apt-get update
RUN apt-get -qy --no-install-recommends install libtool make automake supervisor wget curl git && rm -rf /var/lib/apt/lists/*;

# Better logging of services in supervisor
RUN apt-get -qy --no-install-recommends install python-pip && pip install --no-cache-dir --quiet supervisor-stdout && rm -rf /var/lib/apt/lists/*;

# Install confd
RUN curl -f -qL https://github.com/kelseyhightower/confd/releases/download/v0.5.0/confd-0.5.0-linux-amd64 -o /confd && chmod +x /confd
RUN mkdir -p /etc/confd/conf.d
RUN mkdir -p /etc/confd/templates

# Install twemproxy
RUN curl -f -qL https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/twemproxy/nutcracker-$TWEMPROXY_VERSION.tar.gz | tar xzf -
RUN cd nutcracker-0.3.0 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-debug=log && make && mv src/nutcracker /twemproxy
RUN cd / && rm -rf nutcracker-0.3.0

# Create directory for logs
RUN mkdir -p /var/log/twemproxy

# Set up run script
COPY resources/run.sh /run.sh
RUN chmod 755 /run.sh

# Copy confd files
COPY resources/confd/conf.d/twemproxy.toml /etc/confd/conf.d/twemproxy.toml
COPY resources/confd/templates/twemproxy.tmpl /etc/confd/templates/twemproxy.tmpl

# Copy supervisord files
COPY resources/supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 6000 6222

CMD ["/run.sh"]
