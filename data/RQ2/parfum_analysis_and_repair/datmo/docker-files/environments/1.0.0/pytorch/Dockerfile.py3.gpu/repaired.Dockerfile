FROM datmo/opencv:gpu-py35

MAINTAINER Datmo devs <dev@datmo.com>

# Install datmo
RUN pip install --no-cache-dir datmo

ARG PYTORCH_VERSION=0.4.0
ARG PYTORCH_CUDA_VERSION=90

# Install pytorch
RUN pip install --no-cache-dir http://download.pytorch.org/whl/cu${PYTORCH_CUDA_VERSION}/torch-${PYTORCH_VERSION}-cp35-cp35m-linux_x86_64.whl
RUN pip install --no-cache-dir torchvision

# install tensorboardx
RUN pip install --no-cache-dir tensorboardX

# export port for tensorboard
EXPOSE 6006