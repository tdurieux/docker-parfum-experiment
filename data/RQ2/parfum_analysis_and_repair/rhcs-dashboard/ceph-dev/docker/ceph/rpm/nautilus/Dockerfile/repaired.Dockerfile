ARG CENTOS_VERSION=7
FROM centos:$CENTOS_VERSION
ARG CENTOS_VERSION

RUN yum install -y bind-utils centos-release-scl curl epel-release iputils net-tools yum yum-utils \
    && yum clean packages && rm -rf /var/cache/yum
RUN yum install -y jq \
    && yum clean packages && rm -rf /var/cache/yum

# AWS CLI.
RUN yum install -y awscli \
    && yum clean packages && rm -rf /var/cache/yum
COPY aws/aws-cli-configure.sh /root
RUN /root/aws-cli-configure.sh

# For dev. mode: run integration tests.
RUN yum install -y python2-devel python2-pip python3-devel \
    && yum clean packages && rm -rf /var/cache/yum

# For dev. mode: run backend unit tests.
RUN yum install -y libtool-ltdl-devel libxml2-devel xmlsec1-devel xmlsec1-openssl-devel \
    && yum clean packages && rm -rf /var/cache/yum

# For dev mode: compile frontend app into 'dist' directory.
RUN yum install -y devtoolset-8-gcc-c++ git \
    && yum clean packages && rm -rf /var/cache/yum
ENV PATH="/opt/rh/devtoolset-8/root/usr/bin:$PATH"
RUN pip install --no-cache-dir pip==20.3 \
    && pip install --no-cache-dir -U nodeenv tox

# SSO (after installing xmlsec deps).
RUN pip install --no-cache-dir lxml==4.6.3 pkgconfig==1.5.2
RUN pip install --no-cache-dir wheel==0.34.2 xmlsec==1.3.3 python3-saml==1.8.0

ARG USE_REPO_FILES=0
ARG REPO_URL
ARG CEPH_RELEASE=nautilus
COPY rpm/*.* /root/
RUN /root/set-ceph-repo.sh

RUN yum install -y ceph-mds ceph-mgr-dashboard ceph-mgr-diskprediction-local \
    ceph-mon ceph-osd ceph-radosgw rbd-mirror \
    && yum clean all && rm -rf /var/cache/yum

RUN rm -rf /var/cache/yum/*

RUN mkdir -p /ceph/build /ceph/src

WORKDIR /ceph

ARG VCS_BRANCH=nautilus
COPY install-node.sh /root
RUN /root/install-node.sh
