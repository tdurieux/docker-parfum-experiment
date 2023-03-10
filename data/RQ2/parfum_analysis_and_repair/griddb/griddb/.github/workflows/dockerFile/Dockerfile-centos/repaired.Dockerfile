FROM centos:centos7.8.2003

# Install dependency other
RUN set -eux \
    && yum install -y wget python3 automake make gcc gcc-c++ libpng-devel \
                      java ant zlib-devel tcl.x86_64 zip unzip rpm-build rsync \
    && yum clean all && rm -rf /var/cache/yum

