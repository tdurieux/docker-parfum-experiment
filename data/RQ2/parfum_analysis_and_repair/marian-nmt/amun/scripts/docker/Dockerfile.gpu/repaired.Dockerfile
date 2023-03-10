FROM nvidia/cuda:8.0-devel-ubuntu16.04

MAINTAINER Mama <ma@ma.com>
LABEL description="Basic Marian nvidia-docker container for Ubuntu"

# Install some necessary tools.
RUN apt-get update && apt-get install --no-install-recommends -y \
                build-essential \
                git-core \
                pkg-config \
                libtool \
                zlib1g-dev \
                libbz2-dev \
                cmake \
                automake \
                python-dev \
                perl \
                libsparsehash-dev \
                libboost-all-dev \
            && rm -rf /var/lib/apt/lists/*


RUN git clone https://github.com/marian-nmt/marian

ENV MARIANPATH /marian

WORKDIR $MARIANPATH
RUN mkdir -p build
WORKDIR $MARIANPATH/build
RUN cmake $MARIANPATH && make -j
