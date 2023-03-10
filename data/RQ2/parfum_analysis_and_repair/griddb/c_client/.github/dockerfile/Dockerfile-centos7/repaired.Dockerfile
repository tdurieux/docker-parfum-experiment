FROM centos:centos7.8.2003

ENV GRIDDB_VERSION=4.5.2
ENV GRIDDB_DOWNLOAD_SHA512=2639cc7549f4fc151987c686c76e4deeb4b27f07b8a35dbf50b2f08954e1ee4dc39bd4a47d4407a63bb6fe7d9441508cd89009827d937d1045e25f685553cceb

# Install dependency other
RUN set -eux \
    && yum install -y wget python27 automake make gcc gcc-c++ rpm-build rsync libtool \
    && yum clean all && rm -rf /var/cache/yum

# Install griddb server
RUN set -eux \
# Download package griddb server
    && wget -q https://github.com/griddb/griddb/releases/download/v${GRIDDB_VERSION}/griddb-${GRIDDB_VERSION}-linux.x86_64.rpm \
# Check sha512sum package
    && echo "$GRIDDB_DOWNLOAD_SHA512 griddb-${GRIDDB_VERSION}-linux.x86_64.rpm" | sha512sum --strict --check \
# Install package griddb server
    && rpm -ivh griddb-${GRIDDB_VERSION}-linux.x86_64.rpm \
# Remove package
    && rm griddb-${GRIDDB_VERSION}-linux.x86_64.rpm
