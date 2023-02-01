FROM ubuntu:16.04
WORKDIR /
RUN apt-get update && apt-get install --no-install-recommends libhdf5-dev zlib1g-dev libzstd1-dev git wget tar gcc g++ make autoconf bash bzip2 -y && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/hasindu2008/f5c.git
WORKDIR /f5c
RUN autoreconf && ./scripts/install-hts.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make zstd=1 && make test
CMD ./f5c
