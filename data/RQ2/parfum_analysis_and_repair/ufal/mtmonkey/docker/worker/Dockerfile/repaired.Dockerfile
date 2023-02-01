FROM ubuntu:16.04

ARG CPU_CORES=4

RUN \
  apt-get update \
  && apt-get install --no-install-recommends -y \
    git \
    libxmlrpc-c++8-dev \
    python-pip \
    build-essential \
    pkg-config \
    libboost-all-dev \
    automake \
    libtool \
    wget \
    zlib1g-dev \
    python-dev \
    libbz2-dev \
    libcmph-dev && rm -rf /var/lib/apt/lists/*;

RUN \
  git clone https://github.com/moses-smt/mosesdecoder.git \
  && cd mosesdecoder \
  && git checkout 7df9726788cc03a90 \
  && ./bjam -j $CPU_CORES \
  && cd ..

RUN \
  pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir flask validictory regex configobj requests

RUN \
  git clone https://github.com/ufal/mtmonkey

VOLUME /mt-model

EXPOSE 8080

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
