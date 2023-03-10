FROM opensuse/leap:15.1

ENV GRIDDB_VERSION=4.5.2

# Install dependency for build C Client
RUN set -eux \
    && zypper install -y make automake autoconf libtool gcc gcc-c++ \
    && zypper install -y net-tools python2 rpm-build rsync wget \
    && zypper clean all

# Install griddb server
RUN set -eux \
# Download package griddb server
    && wget -q https://github.com/griddb/griddb/releases/download/v${GRIDDB_VERSION}/griddb-${GRIDDB_VERSION}-opensuse.x86_64.rpm \
# Install package griddb server
    && rpm -ivh griddb-${GRIDDB_VERSION}-opensuse.x86_64.rpm \
# Remove package
    && rm griddb-${GRIDDB_VERSION}-opensuse.x86_64.rpm