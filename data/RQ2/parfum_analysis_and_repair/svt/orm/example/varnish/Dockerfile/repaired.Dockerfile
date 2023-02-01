FROM debian:stretch-slim

# Install Varnish
RUN apt-get update && apt-get -y --no-install-recommends install debian-archive-keyring curl gnupg apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN curl -f -L https://packagecloud.io/varnishcache/varnish60lts/gpgkey | apt-key add
RUN echo "deb https://packagecloud.io/varnishcache/varnish60lts/debian/ stretch main" > /etc/apt/sources.list.d/varnishcache_varnish60lts.list
RUN echo "deb-src https://packagecloud.io/varnishcache/varnish60lts/debian/ stretch main" >> /etc/apt/sources.list.d/varnishcache_varnish60lts.list
RUN apt-get update && apt-get -y --no-install-recommends install varnish && rm -rf /var/lib/apt/lists/*;

# Build and install Varnish VMOD vmod_var
RUN apt-get -y --no-install-recommends install build-essential automake libtool python-docutils libpcre3-dev varnish-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /root
RUN curl -f -LO https://download.gnu.org.ua/release/vmod-variable/vmod-variable-1.3.tar.gz
RUN tar zxvf vmod-variable-1.3.tar.gz && rm vmod-variable-1.3.tar.gz
WORKDIR /root/vmod-variable-1.3
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make all && make install

COPY varnish-entrypoint.sh /varnish-entrypoint.sh

WORKDIR /
ENTRYPOINT ["/varnish-entrypoint.sh"]
