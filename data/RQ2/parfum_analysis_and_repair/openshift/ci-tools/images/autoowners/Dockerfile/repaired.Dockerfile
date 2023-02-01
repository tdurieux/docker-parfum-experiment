FROM quay.io/centos/centos:stream8

ADD autoowners /usr/bin/autoowners

RUN yum install -y git && rm -rf /var/cache/yum

ENTRYPOINT ["/usr/bin/autoowners"]
