FROM golang:1.9.1
LABEL Salim Alami <celrenheit+github@gmail.com>

ENV ROCKSDB_VERSION v5.8

RUN apt-get update -y && apt-get install --no-install-recommends -y git build-essential checkinstall libgflags-dev libsnappy-dev zlib1g-dev libbz2-dev && rm -rf /var/lib/apt/lists/*; # Install git


# Clone rocksdb
RUN cd /tmp && git clone --depth 1 --branch ${ROCKSDB_VERSION} https://github.com/facebook/rocksdb.git && cd rocksdb && make clean && \
    PORTABLE=1 make install-static INSTALL_PATH=/usr
