FROM nvidia/cuda:10.0-base-ubuntu18.04

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="4"

ENV NCCL_VERSION=2.4.7-1+cuda10.0
ENV CUDNN_VERSION=7.5.1.10-1+cuda10.0
ENV TF_TENSORRT_VERSION=5.0.2

RUN apt-get update && apt-get install -y --no-install-recommends \
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
    emacs \
    git \
    wget \
    build-essential \
    vim \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# The 'apt-get install' of nvinfer-runtime-trt-repo-ubuntu1604-4.0.1-ga-cuda10.0
# adds a new list which contains libnvinfer library, so it needs another
# 'apt-get update' to retrieve that list before it can actually install the
# library.
# We don't install libnvinfer-dev since we don't need to build against TensorRT,
# and libnvinfer4 doesn't contain libnvinfer.a static library.
RUN apt-get update \
 && apt-get install -y --no-install-recommends nvinfer-runtime-trt-repo-ubuntu1804-${TF_TENSORRT_VERSION}-ga-cuda10.0 \
 && apt-get update \
 && apt-get install -y --no-install-recommends libnvinfer5=${TF_TENSORRT_VERSION}-1+cuda10.0 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm /usr/lib/x86_64-linux-gnu/libnvinfer_plugin* \
 && rm /usr/lib/x86_64-linux-gnu/libnvcaffe_parser* \
 && rm /usr/lib/x86_64-linux-gnu/libnvparsers*

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

# Add arguments to achieve the version, python and url
#  PYTHON=python for 2.7
#  PYTHON=python3 for 3.5, 3.6 is not available directly on 16.04
ARG PYTHON=python

# user python-pip or python3-pip
ARG PYTHON_PIP=python-pip

#  PIP=pip for 2.7
#  PIP=pip3 for 3.5, 3.6 is not available directly on 16.04
ARG PIP=pip

# Python won’t try to write .pyc or .pyo files on the import of source modules
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

ARG OPENSSL_VERSION=1.1.1k

RUN wget -c https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz \
 && apt-get update \
 && apt remove -y --purge openssl \
 && rm -rf /usr/include/openssl \
 && apt-get install --no-install-recommends -y \
    ca-certificates \
 && tar -xzvf openssl-${OPENSSL_VERSION}.tar.gz \
 && cd openssl-${OPENSSL_VERSION} \
 && ./config && make && make test \
 && make install \
 && ldconfig \
 && cd .. && rm -rf openssl-* && rm openssl-${OPENSSL_VERSION}.tar.gz && rm -rf /var/lib/apt/lists/*;

 # when we remove previous openssl, the ca-certificates pkgs and its symlinks gets deleted
# causing sslcertverificationerror the below steps are to fix that
RUN ln -s /etc/ssl/certs/*.* /usr/local/ssl/certs/

RUN apt-get update && apt-get install -y --no-install-recommends \
    ${PYTHON} \
    ${PYTHON_PIP} && rm -rf /var/lib/apt/lists/*;

RUN ${PIP} --no-cache-dir install --upgrade pip setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python

RUN curl -f https://tensorflow-aws.s3-us-west-2.amazonaws.com/1.15.3/Serving/GPU/tensorflow_model_server -o /usr/bin/tensorflow_model_server \
 && chmod 555 /usr/bin/tensorflow_model_server

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/tensorflow/license.txt -o /license.txt

RUN pip install -U --no-cache-dir \
    docutils==0.14 \
    "awscli<2" \
    requests==2.22.0

#CMD ["/bin/bash"]
# Expose ports
# gRPC
EXPOSE 8500

# REST
EXPOSE 8501

# Set where models should be stored in the container
ENV MODEL_BASE_PATH=/models
RUN mkdir -p ${MODEL_BASE_PATH}

# The only required piece is the model name in order to differentiate endpoints
ENV MODEL_NAME=model

# Create a script that runs the model server so we can use environment variables
# while also passing in arguments from the docker command line
RUN echo '#!/bin/bash \n\n\
tensorflow_model_server --port=8500 --rest_api_port=8501 \
--model_name=${MODEL_NAME} --model_base_path=${MODEL_BASE_PATH}/${MODEL_NAME} \
"$@"' > /usr/bin/tf_serving_entrypoint.sh \
&& chmod +x /usr/bin/tf_serving_entrypoint.sh

CMD ["/usr/bin/tf_serving_entrypoint.sh"]
