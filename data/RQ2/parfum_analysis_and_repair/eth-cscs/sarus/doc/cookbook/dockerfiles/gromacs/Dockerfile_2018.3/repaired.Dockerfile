#!/bin/sh
FROM ethcscs/mpich:ub1804_cuda92_mpi314

## Uncomment the following lines if you want to build mpi yourself:
## RUN apt-get update \
## && apt-get install -y --no-install-recommends \
##         wget \
##         gfortran \
##         zlib1g-dev \
##         libopenblas-dev \
## && rm -rf /var/lib/apt/lists/*
##
## # Install MPICH
## RUN wget -q http://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz \
## && tar xf mpich-3.1.4.tar.gz \
## && cd mpich-3.1.4 \
## && ./configure --disable-fortran --enable-fast=all,O3 --prefix=/usr \
## && make -j$(nproc) \
## && make install \
## && ldconfig

# Install CMake (apt installs cmake/3.10.2, we want a more recent version)
RUN mkdir /usr/local/cmake \
&& cd /usr/local/cmake \
&& wget -q https://cmake.org/files/v3.12/cmake-3.12.4-Linux-x86_64.tar.gz \
&& tar -xzf cmake-3.12.4-Linux-x86_64.tar.gz \
&& mv cmake-3.12.4-Linux-x86_64 3.12.4 \
&& rm cmake-3.12.4-Linux-x86_64.tar.gz \
&& cd /

ENV PATH=/usr/local/cmake/3.12.4/bin/:${PATH}

# Install GROMACS (apt install gromacs/2018.1, we want a more recent version)
RUN wget -q https://ftp.gromacs.org/pub/gromacs/gromacs-2018.3.tar.gz \
&& tar xf gromacs-2018.3.tar.gz \
&& cd gromacs-2018.3 \
&& mkdir build && cd build \
&& cmake -DCMAKE_BUILD_TYPE=Release  \
         -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON \
         -DGMX_MPI=on -DGMX_GPU=on -DGMX_SIMD=AVX2_256 \
         -DGMX_BUILD_MDRUN_ONLY=on \
         .. \
&& make -j6 \
&& make check \
&& make install \
&& cd ../.. \
&& rm -fr gromacs-2018.3* && rm gromacs-2018.3.tar.gz
