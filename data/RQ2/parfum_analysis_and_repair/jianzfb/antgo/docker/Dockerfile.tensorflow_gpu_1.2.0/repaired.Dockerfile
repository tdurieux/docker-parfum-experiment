# Build as antgo/server

FROM docker.io/nvidia/cuda:8.0-cudnn5-devel-ubuntu14.04
MAINTAINER Project Antgo <jian@mltalker.com>

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y wget \
                       vim \
                       git \
                       curl \
                       libjpeg8-dev \
                       python3 \
                       python3-pip \
                       python3-dev \
                       unzip && rm -rf /var/lib/apt/lists/*;

# install tensorflow-gpu-1.2.0
RUN pip3 install --no-cache-dir --upgrade https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.2.0-cp34-cp34m-linux_x86_64.whl
# install antgo and its dependence
RUN apt-get install --no-install-recommends -y libblas-dev liblapack-dev libatlas-base-dev gfortran && rm -rf /var/lib/apt/lists/*;
ADD install.sh install.sh
RUN bash install.sh

# set enviroment variable
ENV CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH}:/rocksdb/include
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/rocksdb
ENV LIBRARY_PATH=${LIBRARY_PATH}:/rocksdb
