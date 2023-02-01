FROM nvidia/cuda:9.1-cudnn7-devel-ubuntu16.04

#FROM nvidia/cuda:10.0-cudnn7-runtime-ubuntu18.04
#FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04
ARG ARCH=gpu

ARG py_version=3

# Validate that arguments are specified
RUN test $py_version || exit 1

# Install python and nginx
RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        jq \
        git \
        libsm6 \
        libxext6 \
        libxrender-dev \
        nginx && \
    if [ $py_version -eq 3 ]; \
       then apt-get install -y --no-install-recommends python3.7-dev \
           && ln -s -f /usr/bin/python3.7 /usr/bin/python; \
       else apt-get install -y --no-install-recommends python-dev; fi && \
    rm -rf /var/lib/apt/lists/*

#ENV CUDNN_VERSION 7.5.0.56
#LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"


# Install pip
RUN cd /tmp && \
    curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py 'pip<=18.1' && rm get-pip.py

RUN apt-get update && apt-get install -y --no-install-recommends nginx curl wget

RUN python --version

RUN pip install --upgrade pip

RUN pip install --upgrade torch torchvision

# Python won’t try to write .pyc or .pyo files on the import of source modules
# Force stdin, stdout and stderr to be totally unbuffered. Good for logging
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 PYTHONIOENCODING=UTF-8 LANG=C.UTF-8 LC_ALL=C.UTF-8

#ENV CUDA_HOME="/usr/local/cuda-10.1"

RUN pip --no-cache-dir install \
        flask \
        pathlib \
        gunicorn \
        gevent \
        scipy \
        sklearn \
        pandas \
        Pillow \
        h5py \
        fastprogress


RUN git clone https://github.com/NVIDIA/apex.git && cd apex && python setup.py install --cuda_ext --cpp_ext

RUN pip install pytorch-pretrained-bert
RUN pip --no-cache-dir install fast-bert --upgrade



ENV PATH="/opt/ml/code:${PATH}"
COPY /bert /opt/ml/code
WORKDIR /opt/ml/code


