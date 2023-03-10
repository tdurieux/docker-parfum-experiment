FROM registry.access.redhat.com/ubi8/ubi:latest
RUN yum --disablerepo=\*ubi\* install -y libstdc++ libuv \
  boost-program-options boost-system boost-date-time boost-filesystem \
  boost-iostreams libnetfilter_conntrack openssl net-tools procps-ng ca-certificates \
  && yum clean all && rm -rf /var/cache/yum
COPY bin/opflex_server /usr/local/bin/
COPY bin/gbp_inspect /usr/local/bin/
COPY bin/launch-opflexserver.sh /usr/local/bin/
COPY server/lib/ /usr/local/lib/
CMD ["/usr/local/bin/launch-opflexserver.sh"]
