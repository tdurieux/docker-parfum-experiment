#FROM ubuntu:latest
#FROM ubuntu:artful
#FROM ubuntu:bionic
FROM ubuntu:focal

LABEL Description="This image contains all of the third-party libraries needed by Amanzi (based on the specified branch, default branch is master)."

# MPI flavor (mpich|openmpi)
ARG mpi_flavor=mpich

# Set timezone:
RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

# Install dependencies:
#  python3-h5py
#  python3-numpy
RUN apt-get -q update -y && apt-get install --no-install-recommends -y tzdata && apt-get -q --no-install-recommends install -y \
  apt-utils \
  cmake \
  curl \
  libcurl4-openssl-dev \
  emacs \
  g++ \
  gfortran \
  git \
  groff \
  libblas-dev \
  liblapacke-dev \
  liblapack-dev \
  lib${mpi_flavor}-dev \
  libssl-dev \
  m4 \
  make \
  openssl \
  python3 \
  python3-distutils \
  python3-pip \
  python-is-python3 \
  rsync \
  wget \
  zlib1g-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Install LANL's root certificate
# Source of this file: https://int.lanl.gov/computing/computer-security/encryption/files-email/lanlwinolt-ca-certs.pem
# ADD lanlwinolt-ca-certs.pem /usr/share/ca-certificates/lanl/lanlwinolt-ca-certs.pem
# RUN apt-get update -y \
#    && apt-get install -y ca-certificates \
#    && rm -rf /var/lib/apt/lists/* \
#    && openssl x509 -in /usr/share/ca-certificates/lanl/lanlwinolt-ca-certs.pem -inform PEM -out /usr/share/ca-certificates/lanl/lanlwinolt-ca-certs.crt \
#    && echo "lanl/lanlwinolt-ca-certs.crt" >> /etc/ca-certificates.conf \
#    && update-ca-certificates


# Note this installs numpy as well
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir install h5py

# Versions change and we cannot set environment variables from command output.
ARG petsc_ver
ARG trilinos_ver
ARG amanzi_branch=master

# Installation paths
ENV AMANZI_PREFIX=/home/amanzi_user/install \
    AMANZI_INSTALL_DIR=/home/amanzi_user/install/amanzi \
    AMANZI_TPLS_DIR=/home/amanzi_user/install/tpls

# TPL versions needed for LD_LIBRARY_PATH
ENV AMANZI_PETSC_LIBS=$AMANZI_TPLS_DIR/petsc-${petsc_ver}/lib \ 
    AMANZI_TRILINOS_LIBS=$AMANZI_TPLS_DIR/trilinos-${trilinos_ver}/lib \
    AMANZI_SEACAS_LIBS=$AMANZI_TPLS_DIR/SEACAS/lib

# Add an unprivileged user and group: amanzi_user, amanzi_user
RUN groupadd -r amanzi_user \
  && useradd -r -m -g amanzi_user amanzi_user
USER amanzi_user

# Set the current working directory as the users home directory
# (creates teh directory if it doesn't exist)
WORKDIR /home/amanzi_user

# ENV https_proxy=proxyout.lanl.gov:8080 \
#     http_proxy=proxyout.lanl.gov:8080


# Clone the amanzi git repo.
RUN git clone https://github.com/amanzi/amanzi.git

# Set the current working directory to the git repo
# and switch branches if requested.
WORKDIR /home/amanzi_user/amanzi
RUN if [ "$amanzi_branch" != "master" ]; then \
       git checkout $amanzi_branch; \
    fi; \
    echo "Amanzi branch = $amanzi_branch"; \
    git branch --list

