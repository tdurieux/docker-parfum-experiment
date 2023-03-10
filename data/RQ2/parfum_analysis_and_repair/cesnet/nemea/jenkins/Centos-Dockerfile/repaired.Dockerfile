FROM centos:7

RUN rpm -ih http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; \
   yum install -y autoconf automake gcc gcc-c++ libtool libxml2-devel m4 make \
      openssl openssl-devel pkg-config libxslt-devel graphviz \
      xsltproc git bc libxml2-python libxslt-python doxygen \
      libpcap-devel bison flex python python-devel python-pip \
      python-setuptools python34 python34-devel python34-pip python34-setuptools python-yaml python34-ply python34-yaml \
      rpm-build epel-rpm-macros; rm -rf /var/cache/yum \
   curl -f -s 'https://copr.fedorainfracloud.org/coprs/g/CESNET/NEMEA/repo/epel-7/group_CESNET-NEMEA-epel-7.repo' > /etc/yum.repos.d/group_CESNET-NEMEA-epel-7.repo; \
   yum install -y python-pynspect python34-pynspect

RUN chmod  u+s,o+rx /usr/sbin/useradd /usr/sbin/groupadd; yum install -y sudo; rm -rf /var/cache/yum sed -i "\$aALL ALL=(ALL) NOPASSWD:ALL" /etc/sudoers

CMD ["/usr/bin/cat"]

