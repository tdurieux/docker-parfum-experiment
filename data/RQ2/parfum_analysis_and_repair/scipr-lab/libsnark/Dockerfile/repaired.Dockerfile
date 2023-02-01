FROM ubuntu:16.04

WORKDIR /root

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    wget unzip curl \
    build-essential cmake git libgmp3-dev libprocps4-dev python-markdown libboost-all-dev libssl-dev pkg-config && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/scipr-lab/libsnark/ \
  && cd libsnark \
  && git submodule init && git submodule update \
  && mkdir build && cd build && cmake .. \
  && make \
  && DESTDIR=/usr/local make install \
    NO_PROCPS=1 NO_GTEST=1 NO_DOCS=1 CURVE=ALT_BN128 FEATUREFLAGS="-DBINARY_OUTPUT=1 -DMONTGOMERY_OUTPUT=1 -DNO_PT_COMPRESSION=1"

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/lib
