FROM nvidia/cuda:11.2.1-base-ubuntu18.04

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"

ARG PYTHON=python3.7
ARG PYTHON_PIP=python3-pip
ARG PIP=pip3
ARG PYTHON_VERSION=3.7.10

ARG TFS_SHORT_VERSION=2.5
ARG TFS_URL=https://aws-ei-tensorflow-binaries.s3-us-west-2.amazonaws.com/serving/r2.5_aws/20210517-110027/gpu/py37/tensorflow_model_server

ENV NCCL_VERSION=2.8.4-1+cuda11.2
ENV CUDNN_VERSION=8.1.0.77-1+cuda11.2
ENV TF_TENSORRT_VERSION=7.2.2

# See http://bugs.python.org/issue19846
ENV LANG=C.UTF-8
ENV PYTHONDONTWRITEBYTECODE=1
# Python won’t try to write .pyc or .pyo files on the import of source modules
ENV PYTHONUNBUFFERED=1
ENV MODEL_BASE_PATH=/models
# The only required piece is the model name in order to differentiate endpoints
ENV MODEL_NAME=model
# Fix for the interactive mode during an install in step 21
ENV DEBIAN_FRONTEND=noninteractive

# allow unauthenticated and allow downgrades for special libcublas library
RUN apt-get update \
 # TODO: Remove systemd upgrade once it is updated in base image
 && apt-get -y upgrade --only-upgrade systemd \
 && apt-get install -y --no-install-recommends --allow-unauthenticated --allow-downgrades\
    ca-certificates \
    cuda-command-line-tools-11-2 \
    cuda-nvrtc-11-2 \
    cuda-nvrtc-dev-11-2 \
    cuda-cudart-dev-11-2 \
    libcufft-dev-11-2 \
    libcurand-dev-11-2 \
    libcusolver-dev-11-2 \
    libcusparse-dev-11-2 \
    libbz2-dev \
    liblzma-dev \
    #cuda-cublas-dev not available with 10-1, install libcublas instead
    libcublas-11-2 \
    libcublas-dev-11-2 \
    libcudnn8=${CUDNN_VERSION} \
    libcudnn8-dev=${CUDNN_VERSION} \
    libnccl2=${NCCL_VERSION} \
    libnccl-dev=${NCCL_VERSION}  \
    libgomp1 \
    libffi-dev \
    curl \
    emacs \
    git \
    wget \
    unzip \
    vim \
    build-essential \
    zlib1g-dev \
    openssl \
    libssl1.1 \
    libreadline-gplv2-dev \
    libncursesw5-dev \
    libssl-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install python3.7
RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
 && tar -xvf Python-$PYTHON_VERSION.tgz \
 && cd Python-$PYTHON_VERSION \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install \
 && rm -rf ../Python-$PYTHON_VERSION* && rm Python-$PYTHON_VERSION.tgz

RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools


# We don't install libnvinfer-dev since we don't need to build against TensorRT
# cuda-x.x is CUDA version 10.2, 11.0, or 11.1 (for 11.2)
# https://docs.nvidia.com/deeplearning/tensorrt/archives/tensorrt-722/install-guide/index.html
RUN apt-get update \
 && apt-get install -y --no-install-recommends --allow-unauthenticated  \
    libnvinfer7=${TF_TENSORRT_VERSION}-1+cuda11.1 \
    libnvinfer-plugin7=${TF_TENSORRT_VERSION}-1+cuda11.1 \
 && rm -rf /var/lib/apt/lists/*

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python \
 && ln -s $(which ${PIP}) /usr/bin/pip

# nginx + njs
RUN apt-get update \
 && apt-get -y install --no-install-recommends \
    curl \
    gnupg2 \
 && curl -f -s https://nginx.org/keys/nginx_signing.key | apt-key add - \
 && echo 'deb http://nginx.org/packages/ubuntu/ bionic nginx' >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get -y install --no-install-recommends \
    nginx \
    nginx-module-njs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# cython, falcon, gunicorn, grpc
RUN ${PIP} install -U --no-cache-dir \
    "awscli<2" \
    boto3 \
    cython==0.29.21 \
    falcon==2.0.0 \
    gunicorn==20.0.4 \
    gevent==21.1.1 \
    requests==2.25.1 \
    grpcio==1.34.1 \
    protobuf==3.14.0 \
# using --no-dependencies to avoid installing tensorflow binary
 && ${PIP} install --no-dependencies --no-cache-dir \
    tensorflow-serving-api-gpu==2.5.1

RUN curl -f $TFS_URL -o /usr/bin/tensorflow_model_server \
 && chmod 555 /usr/bin/tensorflow_model_server

# Expose gRPC and REST port
EXPOSE 8500 8501

# Set where models should be stored in the container
RUN mkdir -p ${MODEL_BASE_PATH}

# Create a script that runs the model server so we can use environment variables
# while also passing in arguments from the docker command line
RUN echo '#!/bin/bash \n\n' > /usr/bin/tf_serving_entrypoint.sh \
 && echo '/usr/bin/tensorflow_model_server --port=8500 --rest_api_port=8501 --model_name=${MODEL_NAME} --model_base_path=${MODEL_BASE_PATH}/${MODEL_NAME} "$@"' >> /usr/bin/tf_serving_entrypoint.sh \
 && chmod +x /usr/bin/tf_serving_entrypoint.sh

COPY deep_learning_container.py /usr/local/bin/deep_learning_container.py

RUN chmod +x /usr/local/bin/deep_learning_container.py

RUN HOME_DIR=/root \
 && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
 && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
 && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
 && chmod +x /usr/local/bin/testOSSCompliance \
 && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
 && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} ${PYTHON} \
 && rm -rf ${HOME_DIR}/oss_compliance*

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/tensorflow-2.5/license.txt -o /license.txt

CMD ["/usr/bin/tf_serving_entrypoint.sh"]
