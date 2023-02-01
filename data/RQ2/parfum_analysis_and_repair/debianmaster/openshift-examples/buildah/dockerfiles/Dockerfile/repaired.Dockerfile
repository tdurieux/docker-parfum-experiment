FROM quay.io/workspace7/buildah
RUN yum install skopeo -y && yum clean all && rm -rf /var/cache/yum
