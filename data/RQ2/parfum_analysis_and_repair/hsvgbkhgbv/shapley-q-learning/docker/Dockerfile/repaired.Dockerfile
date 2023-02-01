FROM nvidia/cuda:8.0-cudnn7-devel-ubuntu16.04
MAINTAINER Tabish Rashid

# CUDA includes
ENV CUDA_PATH /usr/local/cuda
ENV CUDA_INCLUDE_PATH /usr/local/cuda/include
ENV CUDA_LIBRARY_PATH /usr/local/cuda/lib64

# Ubuntu Packages
RUN apt-get update -y && apt-get install --no-install-recommends software-properties-common -y && \
    add-apt-repository -y multiverse && apt-get update -y && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y apt-utils nano vim man build-essential wget sudo && \
    rm -rf /var/lib/apt/lists/*

# Install curl and other dependencies
RUN apt-get update -y && apt-get install --no-install-recommends -y curl libssl-dev openssl libopenblas-dev \
    libhdf5-dev hdf5-helpers hdf5-tools libhdf5-serial-dev libprotobuf-dev protobuf-compiler && \
    curl -f -sk https://raw.githubusercontent.com/torch/distro/master/install-deps | bash && \
    rm -rf /var/lib/apt/lists/*


#Install python3 pip3
RUN apt-get update
RUN apt-get -y --no-install-recommends install python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir numpy scipy pyyaml matplotlib
RUN pip3 install --no-cache-dir imageio pygame
RUN pip3 install --no-cache-dir tensorboard-logger
RUN pip3 install --no-cache-dir ruamel.base ryd

RUN mkdir /install
WORKDIR /install

RUN pip3 install --no-cache-dir jsonpickle==0.9.6
# install Sacred (from OxWhirl fork)
RUN pip3 install --no-cache-dir setuptools
RUN git clone https://github.com/oxwhirl/sacred.git /install/sacred && cd /install/sacred && python3 setup.py install

# Install pymongo
RUN pip3 install --no-cache-dir pymongo

#### -------------------------------------------------------------------
#### install pytorch
#### -------------------------------------------------------------------
RUN pip3 install --no-cache-dir torch==1.3.1

## -- SMAC --
# Change the smac_ver to make sure the newest smac is installed when rebuilding the docker image
ENV smac_ver 1
RUN pip3 install --no-cache-dir git+https://github.com/oxwhirl/smac.git
ENV SC2PATH /pymarl/3rdparty/StarCraftII

WORKDIR /pymarl
