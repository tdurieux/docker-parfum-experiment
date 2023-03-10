ARG CEPH_RELEASE
FROM ceph/ceph:${CEPH_RELEASE}

RUN yum update -y && \
    yum install -y https://apache.bintray.com/arrow/centos/7/apache-arrow-release-latest.rpm && \
    yum install -y \
      re2-devel \
      arrow-devel \
      parquet-devel && \
    yum clean all && rm -rf /var/cache/yum

COPY ceph/build/bin/run-query /usr/bin/
COPY ceph/build/bin/ceph_test_skyhook_query /usr/bin/
COPY ceph/build/lib/libcls_tabular.so* /usr/lib64/rados-classes/
