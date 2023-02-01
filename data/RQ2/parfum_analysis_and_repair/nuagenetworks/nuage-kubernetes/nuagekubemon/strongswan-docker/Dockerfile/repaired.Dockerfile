FROM centos:7

ADD strongswan*.rpm /tmp/

RUN yum -y install /tmp/strongswan*.rpm && rm -f /tmp/strongswan*.rpm && rm -rf /var/cache/yum

RUN sed -i "s/load = yes/load = no/g" /etc/strongswan/strongswan.d/charon/dhcp.conf

CMD ["/usr/sbin/strongswan", "start", "--nofork"]
