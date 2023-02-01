FROM registry.access.redhat.com/ubi7/ubi
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; rm -rf /var/cache/yum \
    yum install -y openvpn; \
    yum clean all
CMD ["/usr/sbin/openvpn"]
