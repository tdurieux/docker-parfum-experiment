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
# install std packages
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
             openssh-server \
             vim && rm -rf /var/lib/apt/lists/*;

