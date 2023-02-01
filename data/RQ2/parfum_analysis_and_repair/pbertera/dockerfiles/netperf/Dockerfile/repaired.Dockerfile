FROM ubuntu:14.04
MAINTAINER pietro@bertera.it

RUN apt-get update && \
    apt-get install --no-install-recommends -y gcc make curl && \
    apt-get clean && \
    rm -rf /tmp/* /var/tmp/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /etc/dpkg/dpkg.cfg.d/02apt-speedup

RUN curl -f -LO ftp://ftp.netperf.org/netperf/netperf-2.7.0.tar.gz && tar -xzf netperf-2.7.0.tar.gz && rm netperf-2.7.0.tar.gz
RUN cd netperf-2.7.0 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-demo=yes && make && make install

COPY entrypoint.sh /opt/

ENTRYPOINT ["/opt/entrypoint.sh"]
