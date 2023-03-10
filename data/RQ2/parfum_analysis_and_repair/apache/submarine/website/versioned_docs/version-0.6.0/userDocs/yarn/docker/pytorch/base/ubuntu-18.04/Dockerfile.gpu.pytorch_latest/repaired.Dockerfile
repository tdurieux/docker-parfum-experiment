# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
ARG PYTHON_VERSION=3.6
RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         curl \
         vim \
         ca-certificates \
         libjpeg-dev \
         libpng-dev \
         wget &&\
     rm -rf /var/lib/apt/lists/*


RUN curl -f -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh && \
     /opt/conda/bin/conda install -y python=$PYTHON_VERSION numpy pyyaml scipy ipython mkl mkl-include cython typing && \
     /opt/conda/bin/conda install -y -c pytorch magma-cuda100 && \
     /opt/conda/bin/conda clean -ya
ENV PATH /opt/conda/bin:$PATH
RUN pip install --no-cache-dir ninja
# This must be done before pip so that requirements.txt is available
WORKDIR /opt/pytorch
RUN git clone https://github.com/pytorch/pytorch.git
WORKDIR pytorch
RUN git submodule update --init
RUN TORCH_CUDA_ARCH_LIST="3.5 5.2 6.0 6.1 7.0+PTX" TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
    CMAKE_PREFIX_PATH="$(dirname $(which conda))/../" \
    pip --no-cache-dir \

    install -v .

WORKDIR /opt/pytorch
RUN git clone https://github.com/pytorch/vision.git && cd vision && pip install --no-cache-dir -v .

WORKDIR /
# Install Hadoop
ENV HADOOP_VERSION="3.1.2"
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
RUN tar zxf hadoop-${HADOOP_VERSION}.tar.gz && rm hadoop-${HADOOP_VERSION}.tar.gz
RUN ln -s hadoop-${HADOOP_VERSION} hadoop-current
RUN rm hadoop-${HADOOP_VERSION}.tar.gz

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
RUN echo "$LOG_TAG Install java8" && \
    apt-get update && \
    apt-get install -y --no-install-recommends openjdk-8-jdk && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "Install python related packages" && \
    pip --no-cache-dir install Pillow h5py ipykernel jupyter matplotlib numpy pandas scipy sklearn && \
    python -m ipykernel.kernelspec

# Set the locale to fix bash warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
RUN apt-get update && apt-get install -y --no-install-recommends locales && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN locale-gen en_US.UTF-8


WORKDIR /workspace
RUN chmod -R a+w /workspace