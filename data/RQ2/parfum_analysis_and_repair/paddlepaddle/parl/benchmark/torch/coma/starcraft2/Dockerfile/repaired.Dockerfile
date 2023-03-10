FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu16.04
MAINTAINER Tabish Rashid

# CUDA includes
ENV CUDA_PATH /usr/local/cuda
ENV CUDA_INCLUDE_PATH /usr/local/cuda/include
ENV CUDA_LIBRARY_PATH /usr/local/cuda/lib64

# Ubuntu Packages
RUN apt-get update -y && apt-get install --no-install-recommends software-properties-common -y && \
    add-apt-repository -y multiverse && apt-get update -y && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y apt-utils nano vim git man build-essential wget sudo && \
    rm -rf /var/lib/apt/lists/*

# Install python3 pip3
RUN apt-get update
RUN apt-get -y --no-install-recommends install python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip

#### -------------------------------------------------------------------
#### install parl
#### -------------------------------------------------------------------
RUN pip3 install --no-cache-dir parl

#### -------------------------------------------------------------------
#### install SMAC
#### -------------------------------------------------------------------
RUN pip3 install --no-cache-dir git+https://github.com/oxwhirl/smac.git

#### -------------------------------------------------------------------
#### install pytorch
#### -------------------------------------------------------------------
RUN pip3 install --no-cache-dir torch


ENV SC2PATH /parl/starcraft2/StarCraftII
WORKDIR /parl
