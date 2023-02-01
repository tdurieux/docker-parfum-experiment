FROM quay.io/centos/centos:stream8
LABEL maintainer="nmoraiti@redhat.com"

RUN yum install -y git && yum clean all && rm -rf /var/cache/yum
ADD pj-rehearse /usr/bin/pj-rehearse
ENTRYPOINT ["/usr/bin/pj-rehearse"]
