FROM ubuntu:16.04
WORKDIR /root
RUN apt-get update && apt-get install --no-install-recommends -y \
  bison \
  cmake \
  doxygen \
  flex \
  g++ \
  gcc \
  git \
  libboost-dev \
  libboost-filesystem-dev \
  libboost-iostreams-dev \
  libboost-program-options-dev \
  libboost-system-dev \
  libbz2-dev \
  libcrypto++-dev \
  libgmp-dev \
  libgnutls28-dev \
  libhdf5-dev \
  libhiredis-dev \
  libmpfr-dev \
  libssl-dev \
  m4 \
  make \
  nettle-dev \
  patch \
  pkg-config \
  vim \
  wget \
  xz-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends doxygen && rm -rf /var/lib/apt/lists/*;
ADD source/ /root/source
ENV LD_LIBRARY_PATH /root/build-sdk/prefix/lib
#ADD README.md .
ADD install.sh .
RUN ["bash", "install.sh"]
CMD ["/bin/bash"]

