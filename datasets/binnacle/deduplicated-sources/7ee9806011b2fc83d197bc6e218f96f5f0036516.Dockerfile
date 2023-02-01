# Copyright (c) Microsoft Corporation
# All rights reserved.
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
# to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
# BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.'


FROM pai.build.mpi:openmpi1.10.4-hadoop2.7.2-cuda8.0-cudnn6-devel-ubuntu16.04

ENV CNTK_VERSION=2.0.beta11.0

RUN apt-get -y update && \
    apt-get -y install git \
        fuse \
        golang \
        libjasper1 \
        libjpeg8 \
        libpng12-0 \
        libgfortran3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /

# Install hdfs-mount
RUN git clone --recursive https://github.com/Microsoft/hdfs-mount.git && \
    cd hdfs-mount && \
    make -j $(nproc) && \
    make test && \
    cp hdfs-mount /bin && \
    cd .. && \
    rm -rf hdfs-mount

# Install Anaconda
RUN ANACONDA_PREFIX="/root/anaconda3" && \
    ANACONDA_VERSION="3-4.1.1" && \
    ANACONDA_SHA256="4f5c95feb0e7efeadd3d348dcef117d7787c799f24b0429e45017008f3534e55" && \
    wget -q https://repo.continuum.io/archive/Anaconda${ANACONDA_VERSION}-Linux-x86_64.sh && \
    echo "$ANACONDA_SHA256 Anaconda${ANACONDA_VERSION}-Linux-x86_64.sh" | sha256sum --check --strict - && \
    chmod a+x Anaconda${ANACONDA_VERSION}-Linux-x86_64.sh && \
    ./Anaconda${ANACONDA_VERSION}-Linux-x86_64.sh -b -p ${ANACONDA_PREFIX} && \
    rm -rf Anaconda${ANACONDA_VERSION}-Linux-x86_64.sh && \
    $ANACONDA_PREFIX/bin/conda clean --all --yes

ENV PATH=/root/anaconda3/bin:/usr/local/mpi/bin:$PATH \
    LD_LIBRARY_PATH=/root/anaconda3/lib:/usr/local/mpi/lib:$LD_LIBRARY_PATH

# Get CNTK Binary Distribution
RUN CNTK_VERSION_DASHED=$(echo $CNTK_VERSION | tr . -) && \
    CNTK_SHA256="2e60909020a0f553431dc7f7818401cc1bb2c99eef307d65bb552c497993593a" && \
    wget -q https://cntk.ai/BinaryDrop/CNTK-${CNTK_VERSION_DASHED}-Linux-64bit-GPU.tar.gz && \
    echo "$CNTK_SHA256 CNTK-${CNTK_VERSION_DASHED}-Linux-64bit-GPU.tar.gz" | sha256sum --check --strict - && \
    tar -xzf CNTK-${CNTK_VERSION_DASHED}-Linux-64bit-GPU.tar.gz && \
    rm -f CNTK-${CNTK_VERSION_DASHED}-Linux-64bit-GPU.tar.gz && \
    wget -q https://raw.githubusercontent.com/Microsoft/CNTK-docker/master/ubuntu-14.04/version_2/${CNTK_VERSION}/gpu/runtime/install-cntk-docker.sh \
         -O /cntk/Scripts/install/linux/install-cntk-docker.sh && \
    /bin/bash /cntk/Scripts/install/linux/install-cntk-docker.sh && \
    /root/anaconda3/bin/conda clean --all --yes && \
    rm -rf /cntk/cntk/python

ENV PATH=/cntk/cntk/bin:$PATH \
    LD_LIBRARY_PATH=/cntk/cntk/lib:/cntk/cntk/dependencies/lib:$LD_LIBRARY_PATH

WORKDIR /root
