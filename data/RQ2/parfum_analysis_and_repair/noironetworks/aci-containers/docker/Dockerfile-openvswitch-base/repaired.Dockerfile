ARG basetag=latest
ARG baserepo=quay.io/noirolabs
FROM ${baserepo}/aci-containers-base:${basetag}
RUN yum install -y --enablerepo=openstack-15-for-rhel-8-x86_64-rpms \
  --enablerepo=fast-datapath-for-rhel-8-x86_64-rpms openvswitch2.13 logrotate conntrack-tools \
  tcpdump curl strace ltrace iptables net-tools && yum clean all && rm -rf /var/cache/yum
CMD ["/usr/bin/sh"]
