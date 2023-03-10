FROM tensorflow/tensorflow:2.4.0rc3-gpu

ARG CONDA_VERSION=4.7.12
ARG PYTHON_VERSION=3.7
ARG AZUREML_SDK_VERSION=1.13.0
ARG INFERENCE_SCHEMA_VERSION=1.1.0

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/miniconda/bin:$PATH
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update --fix-missing && \
    apt-get install --no-install-recommends -y wget bzip2 && \
    apt-get install --no-install-recommends -y fuse && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

RUN useradd --create-home dockeruser
WORKDIR /home/dockeruser
USER dockeruser

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p ~/miniconda && \
    rm ~/miniconda.sh && \
    ~/miniconda/bin/conda clean -tipsy
ENV PATH="/home/dockeruser/miniconda/bin/:${PATH}"
