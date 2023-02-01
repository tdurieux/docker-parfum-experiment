################################################################################
# vim: filetype=dockerfile:
#
# \file      tools/docker/Dockerfile.quinoa-build-debian
# \copyright 2012-2015 J. Bakosi,
#            2016-2018 Los Alamos National Security, LLC.,
#            2019-2021 Triad National Security, LLC.
#            All rights reserved. See the LICENSE file for details.
# \brief     Dockerfile for a simple dynamic build of Quinoa on Debian
# \details   Dockerfile for a simple dynamic build of Quinoa on Debian Linux
# using the native system-wide compiler and MPI wrappers.
#
# We start from the Debian/testing Linux distribution and install all possible
# prerequisites, then build the required but missing third-party libraries,
# build the code, and test.
#
# This docker image is intended to test and demonstrate a simple way of building
# Quinoa. It creates dynamically built executables which require runtime
# libraries.
#
################################################################################

FROM debian:buster

# Install system-wide prerequisites
RUN apt-get update -y && apt-get install --no-install-recommends -y git autoconf cmake gfortran g++ libopenmpi-dev m4 zlib1g-dev libx11-dev libxpm-dev libxft-dev libxext-dev python python-dev flex bison libssl-dev && rm -rf /var/lib/apt/lists/*;

# Setup user
RUN adduser --gecos "" --disabled-password quinoa
WORKDIR /home/quinoa
USER quinoa
WORKDIR /home/quinoa
#CMD ["/bin/bash"]

# Clone quinoa
RUN git clone --recurse-submodules https://github.com/quinoacomputing/quinoa.git
# Checkout commit to be tested
ARG COMMIT
RUN cd quinoa && git checkout $COMMIT && git log -1 HEAD
# Update submodules
RUN cd quinoa && git submodule init && git submodule update --recursive && cd external && git submodule init && git submodule update --recursive && cd .. && git submodule status --recursive
# Build TPLs
RUN cd quinoa && mkdir -p external/build && cd external/build && cmake -DENABLE_ROOT=true -DENABLE_OMEGA_H=true -DCXXFLAGS=-w .. && make -sj$(grep -c processor /proc/cpuinfo)
# Build code
RUN cd quinoa && mkdir -p build && cd build && cmake -DRUNNER=mpirun -DRUNNER_NCPUS_ARG=-n -DRUNNER_ARGS="--bind-to none -oversubscribe" ../src && make -sj$(grep -c processor /proc/cpuinfo)
# Run tests
RUN cd quinoa/build && npe=$(expr $(grep -c processor /proc/cpuinfo) / 2) && mpirun -n $npe Main/unittest -v -q && ctest -j $npe --output-on-failure -LE extreme
