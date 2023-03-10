FROM ubuntu:focal
ARG RELEASE=focal

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
      cmake \
      g++-10 \
      gfortran \
      git \
      vim \
      lldb-10 \
      hdf5-tools \
      libblas-dev \
      libboost-dev \
      libfftw3-dev \
      libgfortran5 \
      libgmp-dev \
      libhdf5-dev \
      liblapack-dev \
      libopenmpi-dev \
      openmpi-bin \
      openmpi-common \
      openmpi-doc \
      python3-dev \
      python3-mako \
      python3-matplotlib \
      python3-mpi4py \
      python3-numpy \
      python3-pip \
      python3-scipy && rm -rf /var/lib/apt/lists/*;

ENV PYTHON_VERSION=3.8 \
    CC=gcc-10 CXX=g++-10
