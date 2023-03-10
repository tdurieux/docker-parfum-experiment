FROM ubuntu:18.04

ENV GRIDDB_VERSION=4.5.2
ENV GRIDDB_DOWNLOAD_SHA512=92d0e382c8d694c2b37274fa37785e2bdb9d6ad8aee0f559e75a528ad171aea1221091ca24db5e2f90442fd92042a6307198d74d0eb1b5f9a23659a26ca7b609

# Install dependency
RUN set -eux \
    && apt-get update -y \
    && apt-get install --no-install-recommends -y gcc-4.8 \
    && apt-get install --no-install-recommends -y g++-4.8 \
    && apt-get install --no-install-recommends -y debhelper libtool python2.7 wget \
    && apt-get clean all && rm -rf /var/lib/apt/lists/*;

# Create softlink gcc g++ python2
RUn set -eux \
    && ln -sf /usr/bin/g++-4.8 /usr/bin/g++ \
    && ln -sf /usr/bin/gcc-4.8 /usr/bin/gcc \
    && ln -sf /usr/bin/python2.7 /usr/bin/python2

# Install griddb server
RUN set -eux \
# Download package griddb server
    && wget -q https://github.com/griddb/griddb/releases/download/v${GRIDDB_VERSION}/griddb_${GRIDDB_VERSION}_amd64.deb \
# Check sha512sum package
    && echo "$GRIDDB_DOWNLOAD_SHA512 griddb_${GRIDDB_VERSION}_amd64.deb" | sha512sum --strict --check \
# Install package griddb server
    && dpkg -i griddb_${GRIDDB_VERSION}_amd64.deb \
# Remove package
    && rm griddb_${GRIDDB_VERSION}_amd64.deb
