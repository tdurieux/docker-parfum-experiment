FROM ubuntu:18.04
MAINTAINER Brandon Haynes "bhaynes@cs.washington.edu"

ARG CUDA_URL=https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run
ARG GPAC_URL=https://github.com/gpac/gpac/archive/v0.7.1.tar.gz
ARG INTEL_REPOSITORY_URL=https://apt.repos.intel.com/setup/intelproducts.list
ARG INTEL_KEY_URL=https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
ARG CMAKE_KEY_URL=https://apt.kitware.com/keys/kitware-archive-latest.asc
ARG CMAKE_REPOSITORY_URL=https://apt.kitware.com/ubuntu/

ENV DEBIAN_FRONTEND noninteractive

# Update timezone
RUN apt-get update && apt-get install --no-install-recommends -y gnupg tzdata wget && rm -rf /var/lib/apt/lists/*;
RUN dpkg-reconfigure -f noninteractive tzdata

# Install Intel IPP
RUN wget $INTEL_REPOSITORY_URL -O intelproducts.list
RUN wget $INTEL_KEY_URL -O intel-key.pub
RUN grep -v intelpython intelproducts.list > /etc/apt/sources.list.d/intelproducts.list # intelpython repo is broken
RUN apt-key add intel-key.pub
RUN apt-get update
RUN apt install --no-install-recommends -y intel-ipp-2019.3-062 && rm -rf /var/lib/apt/lists/*;

# Install cmake repository
RUN wget $CMAKE_KEY_URL -O cmake-key.pub
RUN apt-key add cmake-key.pub
RUN echo deb $CMAKE_REPOSITORY_URL bionic main > /etc/apt/sources.list.d/cmake.list
RUN apt-get update
RUN apt search cmake
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;

# Install apt dependencies
RUN apt-get install \
        -y \
        --no-install-recommends \
      ca-certificates \
      g++-8 \
      libmodule-install-perl \
      libprotobuf-dev \
      protobuf-compiler \
      libgoogle-glog-dev \
      libgtest-dev \
      libopencv-dev \
      libavcodec-dev \
      libavformat-dev \
      libavdevice-dev \
      libboost1.65-all-dev \
      nvidia-384 \
      git \
      python3-dev && rm -rf /var/lib/apt/lists/*;

# Install GPAC
RUN wget $GPAC_URL -q -O gpac.tar.gz && \
    mkdir /opt/gpac && \
    tar xzf gpac.tar.gz -C /opt/gpac --strip-components 1 && \
    rm gpac.tar.gz && \
    cd /opt/gpac && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make lib && \
    make install-lib

# Install CUDA
RUN wget $CUDA_URL -q -O cuda.run && \
    chmod +x cuda.run && \
    PERL5LIB=. sh cuda.run --override --silent --toolkit \
    rm cuda.run

# Set gcc-8 to be default compiler
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 100 --slave /usr/bin/g++ g++ /usr/bin/g++-8

WORKDIR /lightdb
