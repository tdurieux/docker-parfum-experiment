FROM quay.io/centos/centos:stream8

LABEL maintainer="nmoraiti@redhat.com"

RUN yum install -y git && rm -rf /var/cache/yum
ADD publicize /usr/bin/publicize

ENTRYPOINT ["/usr/bin/publicize"]
