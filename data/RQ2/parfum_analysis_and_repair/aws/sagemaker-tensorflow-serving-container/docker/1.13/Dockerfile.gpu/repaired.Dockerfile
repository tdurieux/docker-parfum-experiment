FROM nvidia/cuda:10.0-base-ubuntu16.04

LABEL maintainer="Amazon AI"
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

# Add arguments to achieve the version, python and url
# PYTHON=python for 2.7, PYTHON=python3 for 3.5, 3.6 is not available directly on 16.04
ARG PYTHON=python3
#  PIP=pip for 2.7, PIP=pip3 for 3.5, 3.6 is not available directly on 16.04
ARG PIP=pip3
ARG PYTHON_VERSION=3.6.6
ARG TFS_SHORT_VERSION=1.13

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8
ENV NCCL_VERSION=2.4.7-1+cuda10.0
ENV CUDNN_VERSION=7.5.1.10-1+cuda10.0
ENV TF_TENSORRT_VERSION=5.0.2
# Python won’t try to write .pyc or .pyo files on the import of source modules
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV SAGEMAKER_TFS_VERSION="${TFS_SHORT_VERSION}"
ENV PATH="$PATH:/sagemaker"
ENV MODEL_BASE_PATH=/models
# The only required piece is the model name in order to differentiate endpoints
ENV MODEL_NAME=model

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates \
    cuda-command-line-tools-10-0 \
    cuda-cublas-10-0 \
    cuda-cufft-10-0 \
    cuda-curand-10-0 \
    cuda-cusolver-10-0 \
    cuda-cusparse-10-0 \
    libcudnn7=${CUDNN_VERSION} \
    libnccl2=${NCCL_VERSION} \
    libgomp1 \
    curl \
    git \
    wget \
    vim \
    #next two lines are needed to add python-3.6 should be removed from ubuntu-16.10
    build-essential \
    zlib1g-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# The 'apt-get install' of nvinfer-runtime-trt-repo-ubuntu1604-4.0.1-ga-cuda10.0
# adds a new list which contains libnvinfer library, so it needs another
# 'apt-get update' to retrieve that list before it can actually install the
# library.
# We don't install libnvinfer-dev since we don't need to build against TensorRT,
# and libnvinfer4 doesn't contain libnvinfer.a static library.
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    nvinfer-runtime-trt-repo-ubuntu1604-${TF_TENSORRT_VERSION}-ga-cuda10.0 \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    libnvinfer5=${TF_TENSORRT_VERSION}-1+cuda10.0 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm /usr/lib/x86_64-linux-gnu/libnvinfer_plugin* \
 && rm /usr/lib/x86_64-linux-gnu/libnvcaffe_parser* \
 && rm /usr/lib/x86_64-linux-gnu/libnvparsers* \
 && rm -rf /var/lib/apt/lists/*

RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
 && tar -xvf Python-$PYTHON_VERSION.tgz && cd Python-$PYTHON_VERSION \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install \
 && apt-get update && apt-get install -y --no-install-recommends \
    libreadline-gplv2-dev \
    libncursesw5-dev \
    libssl-dev \
    libsqlite3-dev \
    tk-dev libgdbm-dev \
    libc6-dev libbz2-dev \
 && rm -rf /var/lib/apt/lists/* \
 && make && make install \
 && rm -rf ../Python-$PYTHON_VERSION* \
 && ln -s /usr/local/bin/pip3 /usr/bin/pip && rm Python-$PYTHON_VERSION.tgz

RUN ${PIP} --no-cache-dir install --upgrade pip setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python

RUN curl -f https://s3-us-west-2.amazonaws.com/tensorflow-aws/1.13/Serving/GPU/tensorflow_model_server --output tensorflow_model_server && \
chmod 555 tensorflow_model_server && cp tensorflow_model_server /usr/bin/tensorflow_model_server && \
rm -f tensorflow_model_server

# nginx + njs
RUN apt-get update \
 && apt-get -y install --no-install-recommends curl gnupg2 \
 && curl -f -s https://nginx.org/keys/nginx_signing.key | apt-key add - \
 && echo 'deb http://nginx.org/packages/ubuntu/ xenial nginx' >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get -y install --no-install-recommends nginx nginx-module-njs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# cython, falcon, gunicorn, grpc
RUN ${PIP} install -U --no-cache-dir \
    boto3 \
    awscli==1.16.130 \
    cython==0.29.10 \
    falcon==2.0.0 \
    gunicorn==19.9.0 \
    gevent==1.4.0 \
    requests==2.21.0 \
    grpcio==1.24.1 \
    protobuf==3.10.0 \
# using --no-dependencies to avoid installing tensorflow binary
 && ${PIP} install --no-dependencies --no-cache-dir \
    tensorflow-serving-api-gpu==1.13.0

COPY ./ /

# Expose gRPC and REST port
EXPOSE 8500 8501

# Set where models should be stored in the container
RUN mkdir -p ${MODEL_BASE_PATH}

# Create a script that runs the model server so we can use environment variables
# while also passing in arguments from the docker command line
RUN echo '#!/bin/bash \n\n' > /usr/bin/tf_serving_entrypoint.sh \
 && echo '/usr/bin/tensorflow_model_server --port=8500 --rest_api_port=8501 --model_name=${MODEL_NAME} --model_base_path=${MODEL_BASE_PATH}/${MODEL_NAME} "$@"' >> /usr/bin/tf_serving_entrypoint.sh \
 && chmod +x /usr/bin/tf_serving_entrypoint.sh

CMD ["/usr/bin/tf_serving_entrypoint.sh"]
