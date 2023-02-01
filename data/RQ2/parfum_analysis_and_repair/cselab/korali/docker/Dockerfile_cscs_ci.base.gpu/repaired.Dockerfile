FROM docker.io/nvidia/cuda:11.2.0-cudnn8-devel-ubuntu20.04

ARG MPICH_VERSION=3.1.4

ENV MPICH_VERSION ${MPICH_VERSION}

# update aptitude
ENV TZ=Europe/Zurich
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -y --fix-missing upgrade

# install aptitude essentials
RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install rsync && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install gdb && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install pkg-config && rm -rf /var/lib/apt/lists/*;

# Install MPI
RUN cd /tmp \
    && wget -q https://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz \
    && tar xf mpich-${MPICH_VERSION}.tar.gz \
    && cd mpich-${MPICH_VERSION} \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-fortran --enable-fast=all,O3 --prefix=/usr \
    && make -j3 \
    && make install \
    && ldconfig \
    && cd .. \
    && rm -rf mpich-${MPICH_VERSION} \
    && rm -f mpich-${MPICH_VERSION}.tar.gz

# install Python and numerical libraries
RUN apt-get -y --no-install-recommends install libgsl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-numpy && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-matplotlib && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-scipy && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-xlrd && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pandas && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libmkldnn-dev && rm -rf /var/lib/apt/lists/*;


RUN python3 -m pip install meson
RUN python3 -m pip install ninja
RUN python3 -m pip install cmake
RUN python3 -m pip install pybind11

WORKDIR /home/ubuntu
