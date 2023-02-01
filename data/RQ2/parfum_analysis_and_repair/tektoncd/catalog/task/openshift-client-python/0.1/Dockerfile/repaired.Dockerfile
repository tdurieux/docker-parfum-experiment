FROM quay.io/openshift/origin-cli:4.6 AS oc


FROM centos:7 as builder

RUN yum --enablerepo=extras install -y epel-release && \
    yum install -y python2 python-pip && \
    pip install --no-cache-dir openshift-client && rm -rf /var/cache/yum
COPY --from=oc . .


FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
COPY --from=builder . .

ENTRYPOINT /bin/sh
