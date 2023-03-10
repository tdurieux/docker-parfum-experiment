FROM registry.access.redhat.com/ubi8/ubi:latest
RUN yum --disablerepo=\*ubi\* install -y --enablerepo=openstack-15-for-rhel-8-x86_64-rpms \
  --enablerepo=fast-datapath-for-rhel-8-x86_64-rpms libstdc++ libuv \
  boost-program-options boost-system boost-date-time boost-filesystem \
  boost-iostreams libnetfilter_conntrack openssl net-tools procps-ng ca-certificates \
  && yum clean all && rm -rf /var/cache/yum
CMD ["/usr/bin/sh"]
