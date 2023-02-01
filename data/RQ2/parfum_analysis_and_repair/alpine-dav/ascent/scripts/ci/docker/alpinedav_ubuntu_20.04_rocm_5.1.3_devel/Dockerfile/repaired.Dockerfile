# Copyright (c) Lawrence Livermore National Security, LLC and other Ascent
# Project developers. See top-level LICENSE AND COPYRIGHT files for dates and
# other details. No copyright assignment is required to contribute to Ascent.

FROM ubuntu:20.04
# add sudo to base ubuntu container
# so we can install additional packages as
# non-root, but admin default user on azure pipelines
RUN apt-get update && apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get -y --no-install-recommends install wget gnupg && rm -rf /var/lib/apt/lists/*;
# tzdata install wants to ask questions, so handled as sep case
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
#
# install rocm (recipe from warpx)
# https://github.com/ECP-WarpX/WarpX/blob/development/.github/workflows/dependencies/hip.sh
#
# Ref.: https://rocmdocs.amd.com/en/latest/Installation_Guide/Installation-Guide.html#ubuntu
RUN wget -q -O - https://repo.radeon.com/rocm/rocm.gpg.key \
  | sudo apt-key add -

RUN echo 'deb [arch=amd64] http://repo.radeon.com/rocm/apt/5.1.3/ ubuntu main' \
  | sudo tee /etc/apt/sources.list.d/rocm.list

RUN echo 'export PATH=/opt/rocm/llvm/bin:/opt/rocm/bin:/opt/rocm/profiler/bin:/opt/rocm/opencl/bin:$PATH' \
  | sudo tee -a /etc/profile.d/rocm.sh

# install std packages
# Notes:
# kmod -- hip requires lsmod
# liblocale-codes-perl  -- hip uses perl, if locale bad, life isn't good
RUN apt-get update && apt-get -y --no-install-recommends install \
             binutils \
             gcc \
             g++ \
             gfortran \
             python \
             perl \
             git \
             git-lfs \
             curl \
             wget \
             tar \
             unzip \
             build-essential \
             libncurses-dev \
             libssl-dev \
             libblas-dev \
             liblapack-dev \
             liblapacke-dev \
             zlib1g-dev \
             libgdbm-dev \
             libreadline-dev \
             libsqlite3-dev \
             libbz2-dev \
             mpich \
             libmpich-dev \
             libnuma-dev \
             openssh-server \
             rocm-dev \
             rocfft-dev \
             rocprim-dev \
             rocrand-dev \
             kmod \
             liblocale-codes-perl \
             vim && rm -rf /var/lib/apt/lists/*;

