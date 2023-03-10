FROM ubuntu:latest

MAINTAINER Sah Lee <contact@leesah.name>

ENV DEPENDENCIES git-core build-essential autoconf libtool libssl-dev
ENV BASEDIR /tmp/shadowsocks-libev
ENV PORT 8338

# Set up building environment
RUN apt-get update \
 && apt-get install --no-install-recommends -y $DEPENDENCIES && rm -rf /var/lib/apt/lists/*;

# Get the latest code, build and install
RUN git clone https://github.com/shadowsocks/shadowsocks-libev.git $BASEDIR
WORKDIR $BASEDIR
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
 && make \
 && make install

# Tear down building environment and delete git repository
WORKDIR /
RUN rm -rf $BASEDIR/shadowsocks-libev\
 && apt-get --purge autoremove -y $DEPENDENCIES

# Port in the config file won't take affect. Instead we'll use 8388.
EXPOSE $PORT

# Override the host and port in the config file.
ADD entrypoint /
ENTRYPOINT ["/entrypoint"]
CMD ["-h"]
