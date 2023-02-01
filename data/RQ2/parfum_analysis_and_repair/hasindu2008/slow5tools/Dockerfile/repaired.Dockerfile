FROM ubuntu:16.04
WORKDIR /
RUN apt-get update && apt-get install --no-install-recommends libhdf5-dev zlib1g-dev libzstd1-dev git wget tar gcc g++ make autoconf bash -y && rm -rf /var/lib/apt/lists/*;
RUN git clone --recursive https://github.com/hasindu2008/slow5tools
WORKDIR /slow5tools
RUN autoreconf && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make zstd=1 && zstd=1 make test
CMD ./slow5tools
