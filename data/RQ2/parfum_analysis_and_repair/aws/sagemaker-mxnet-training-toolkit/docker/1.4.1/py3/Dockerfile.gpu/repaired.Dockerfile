# Note: We do not need install nccl or cudnn, which were already installed in runtime container.
FROM nvidia/cuda:10.0-cudnn7-runtime-ubuntu16.04

LABEL maintainer="Amazon AI"

LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

ENV MX_VERSION=1.4.1
ARG PYTHON=python3
ARG PYTHON_PIP=python3-pip
ARG PIP=pip3
ARG PYTHON_VERSION=3.6.6

RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cuda-command-line-tools-10-0 \
        cuda-cublas-10-0 \
        cuda-cufft-10-0 \
        cuda-curand-10-0 \
        cuda-cusolver-10-0 \
        cuda-cusparse-10-0 \
        curl \
        git \
        libatlas-base-dev \
        libcurl4-openssl-dev \
        libgomp1 \
        libopencv-dev \
        openssh-client \
        openssh-server \
        wget \
        vim \
        zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz && \
        tar -xvf Python-$PYTHON_VERSION.tgz && cd Python-$PYTHON_VERSION && \
        ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && \
        apt-get update && apt-get install -y --no-install-recommends libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev && \
        make && make install && rm -rf ../Python-$PYTHON_VERSION* && \
        ln -s /usr/local/bin/pip3 /usr/bin/pip && rm Python-$PYTHON_VERSION.tgz && rm -rf /var/lib/apt/lists/*;

RUN ${PIP} --no-cache-dir install --upgrade pip setuptools
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python

WORKDIR /

# Docker container build should happen in a fresh environment with context for this build.
# All the needed artifacts should be setup before docker build command.
COPY sagemaker_mxnet_container.tar.gz /sagemaker_mxnet_container-3.0.0.tar.gz

RUN pip install --no-cache-dir --no-cache --upgrade \
        mxnet-cu100mkl==$MX_VERSION \
        keras-mxnet==2.2.4.1 \
        h5py==2.9.0 \
        numpy==1.14.5 \
        onnx==1.4.1 \
        pandas==0.24.1 \
        Pillow==5.4.1 \
        requests==2.21.0 \
        scikit-learn==0.20.3 \
        scipy==1.2.1 \
        /sagemaker_mxnet_container-3.0.0.tar.gz && \
    rm /sagemaker_mxnet_container-3.0.0.tar.gz

# "channels first" is recommended for keras-mxnet
# https://github.com/awslabs/keras-apache-mxnet/blob/master/docs/mxnet_backend/performance_guide.md#channels-first-image-data-format-for-cnn
RUN mkdir /root/.keras && \
    echo '{"image_data_format": "channels_first"}' > /root/.keras/keras.json

# This is here to make our installed version of OpenCV work.
# https://stackoverflow.com/questions/29274638/opencv-libdc1394-error-failed-to-initialize-libdc1394
# TODO: Should we be installing OpenCV in our image like this? Is there another way we can fix this?
RUN ln -s /dev/null /dev/raw1394

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib" \
    PYTHONIOENCODING=UTF-8 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

ENV SAGEMAKER_TRAINING_MODULE sagemaker_mxnet_container.training:main

CMD ["/bin/bash"]
