FROM registry.access.redhat.com/ubi8/ubi:latest
RUN yum --disablerepo=\*ubi\* --enablerepo=openstack-15-for-rhel-8-x86_64-rpms \
  --enablerepo=fast-datapath-for-rhel-8-x86_64-rpms install -y openvswitch2.13 logrotate conntrack-tools \
  tcpdump curl strace ltrace iptables net-tools curl git wget ca-certificates && yum clean all && rm -rf /var/cache/yum
CMD ["/usr/bin/sh"]
