FROM datmo/opencv:gpu-py35

MAINTAINER Datmo devs <dev@datmo.com>

# Install datmo
RUN pip install --no-cache-dir datmo

ARG MXNET_VERSION=1.1.0
ARG MXNET_CUDA_VERSION=90

# install mxnet
RUN pip --no-cache-dir install numpy==1.14.5 mxnet-cu${MXNET_CUDA_VERSION}==${MXNET_VERSION}

# install tensorboardx and graphviz
RUN pip install --no-cache-dir tensorboardX graphviz

# export port for tensorboard
EXPOSE 6006