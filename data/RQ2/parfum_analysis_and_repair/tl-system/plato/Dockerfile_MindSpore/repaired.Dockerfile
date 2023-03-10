# Download base image from NVIDIA's Docker Hub
FROM nvidia/cuda:11.1.1-cudnn8-runtime-ubuntu20.04
LABEL maintainer="Baochun Li"

ADD ./.bashrc /root/
COPY ./requirements.txt /root/
WORKDIR /root/plato

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget \
    && apt-get install --no-install-recommends -y vim \
    && apt-get install --no-install-recommends -y net-tools \
    && apt-get install --no-install-recommends -y git \
    && mkdir -p ~/miniconda3 \
    && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh \
    && bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3 \
    && rm -rf ~/miniconda3/miniconda.sh \
    && ~/miniconda3/bin/conda update -n base -c defaults conda \
    && ~/miniconda3/bin/conda init bash \
    && ~/miniconda3/bin/conda create -n plato_gpu -c conda-forge python=3.9.0 \
    && ~/miniconda3/bin/conda install mindspore-gpu=1.6.0 cudatoolkit=11.1 -c mindspore -c conda-forge -n plato_gpu -y \
    && ~/miniconda3/envs/plato_gpu/bin/pip install -r ~/requirements.txt \
    && ~/miniconda3/envs/plato_gpu/bin/pip install plato-learn \
    && ~/miniconda3/bin/conda create -n plato_cpu -c conda-forge python=3.9.0 \
    && ~/miniconda3/bin/conda install mindspore-cpu=1.6.0 -c mindspore -c conda-forge -n plato_cpu -y \
    && ~/miniconda3/envs/plato_cpu/bin/pip install -r ~/requirements.txt \
    && ~/miniconda3/envs/plato_cpu/bin/pip install plato-learn && rm -rf /var/lib/apt/lists/*;

RUN rm /root/requirements.txt
