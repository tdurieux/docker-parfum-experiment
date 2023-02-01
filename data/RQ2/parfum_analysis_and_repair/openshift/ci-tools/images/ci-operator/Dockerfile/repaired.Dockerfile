FROM quay.io/centos/centos:stream8
LABEL maintainer="skuznets@redhat.com"

RUN yum install -y git python2 && rm -rf /var/cache/yum
RUN alternatives --set python /usr/bin/python2
ADD ci-operator /usr/bin/ci-operator
ENTRYPOINT ["/usr/bin/ci-operator"]
