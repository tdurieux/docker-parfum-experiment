FROM ubuntu:xenial

RUN apt update && \
  DEBIAN_FRONTEND='noninteractive' \
  DEBCONF_NONINTERACTIVE_SEEN='true' \
  apt --no-install-recommends \
  install --yes \
  build-essential \
  cmake \
  doxygen \
  git \
  libgeographic-dev \
  libgomp1 \
  libhdf5-mpich-dev \
  libmpich-dev \
  libpython2.7-dev \
  ninja-build \
  python2.7 \
  python-h5py \
  python-matplotlib \
  python-mpltoolkits.basemap \
  swig && rm -rf /var/lib/apt/lists/*;
