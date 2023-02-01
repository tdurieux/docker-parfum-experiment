FROM quay.io/centos/centos:stream8
LABEL maintainer="sgoeddel@redhat.com"

RUN yum install -y git diffutils && yum clean all && rm -rf /var/cache/yum
ADD cluster-init /usr/bin/cluster-init
ENTRYPOINT ["/usr/bin/cluster-init"]
