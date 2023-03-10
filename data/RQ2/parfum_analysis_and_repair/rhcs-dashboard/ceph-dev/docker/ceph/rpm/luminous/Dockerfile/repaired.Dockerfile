FROM centos:7

RUN yum install -y epel-release yum-utils && yum clean all && rm -rf /var/cache/yum

RUN yum install -y curl jq net-tools && yum clean all && rm -rf /var/cache/yum

COPY luminous/luminous.repo /etc/yum.repos.d

RUN yum install -y ceph-mds ceph-mgr ceph-mon ceph-osd ceph-radosgw && yum clean all && rm -rf /var/cache/yum

RUN mkdir -p /ceph/build /ceph/src

RUN curl -f -LsS https://github.com/ceph/ceph/raw/v12.2.8/src/vstart.sh \
    -o /ceph/src/vstart.sh \
    && chmod +x /ceph/src/vstart.sh

WORKDIR /ceph
