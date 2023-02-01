FROM ubuntu:14.04

MAINTAINER dasha.filippova@gmail.com

RUN apt-get update && apt-get install --no-install-recommends -y wget \
  build-essential \
  zlib1g-dev \
  cmake \
  libboost-all-dev && rm -rf /var/lib/apt/lists/*;

# install tclap
RUN wget https://sourceforge.net/projects/tclap/files/tclap-1.2.1.tar.gz && \
  tar -xvzf tclap-1.2.1.tar.gz && \
  cd tclap-1.2.1 && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && rm tclap-1.2.1.tar.gz

# install libbf
RUN wget https://github.com/mavam/libbf/archive/v0.1-beta.tar.gz && \
  tar -xvzf v0.1-beta.tar.gz && \
  cd libbf-0.1-beta && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && rm v0.1-beta.tar.gz


ENV LD_LIBRARY_PATH /usr/local/lib/

# WORKDIR /nimbliner
