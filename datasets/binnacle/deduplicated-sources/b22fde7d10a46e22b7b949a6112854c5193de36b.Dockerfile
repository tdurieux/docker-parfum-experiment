FROM appscode/base:8.6

RUN set -x \
  && apt-get update \
  && apt-get install -y libssl1.0.0 libpcre3 socat --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man /tmp/*

ENV HAPROXY_MAJOR 1.6
ENV HAPROXY_VERSION 1.6.10
ENV HAPROXY_MD5 6d47461c008b823a0088d19ec30dbe4e

# see http://sources.debian.net/src/haproxy/1.5.8-1/debian/rules/ for some helpful navigation of the possible "make" arguments
RUN buildDeps='ca-certificates curl gcc libc6-dev libpcre3-dev libssl-dev make' \
  && set -x \
  && apt-get update \
  && apt-get install -y $buildDeps --no-install-recommends \
  && curl -SL "http://www.haproxy.org/download/${HAPROXY_MAJOR}/src/haproxy-${HAPROXY_VERSION}.tar.gz" -o haproxy.tar.gz \
  && echo "${HAPROXY_MD5}  haproxy.tar.gz" | md5sum -c \
  && mkdir -p /usr/src/haproxy \
  && tar -xzf haproxy.tar.gz -C /usr/src/haproxy --strip-components=1 \
  && rm haproxy.tar.gz \
  && make -C /usr/src/haproxy \
    TARGET=linux2628 \
    USE_PCRE=1 PCREDIR= \
    USE_OPENSSL=1 \
    USE_ZLIB=1 \
    all \
    install-bin \
  && mkdir -p /usr/local/etc/haproxy \
  && cp -R /usr/src/haproxy/examples/errorfiles /usr/local/etc/haproxy/errors \
  && rm -rf /usr/src/haproxy \
  && mkdir -p /var/state/haproxy \
  && apt-get purge -y --auto-remove $buildDeps \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man /tmp/*

COPY reloader /reloader

# COPY haproxy.cfg /etc/haproxy/haproxy.cfg
RUN touch /var/run/haproxy.pid

# Setup runit scripts
COPY sv /etc/sv/
RUN ln -s /etc/sv /etc/service

COPY runit.sh /runit.sh
ENTRYPOINT ["/runit.sh"]
