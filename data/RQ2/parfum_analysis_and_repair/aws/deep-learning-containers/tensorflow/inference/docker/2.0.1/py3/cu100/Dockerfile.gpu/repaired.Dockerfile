FROM nvidia/cuda:10.0-base-ubuntu18.04

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="5"
# Specify accept-bind-to-port LABEL for inference pipelines to use SAGEMAKER_BIND_TO_PORT
# https://docs.aws.amazon.com/sagemaker/latest/dg/inference-pipeline-real-time.html
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

ARG PYTHON=python3
ARG PIP=pip3
ARG TFS_SHORT_VERSION=2.0.1
ARG TFS_URL=https://tensorflow-aws.s3-us-west-2.amazonaws.com/${TFS_SHORT_VERSION}/Serving/GPU/tensorflow_model_server

ENV NCCL_VERSION=2.4.7-1+cuda10.0
ENV CUDNN_VERSION=7.5.1.10-1+cuda10.0
ENV TF_TENSORRT_VERSION=5.0.2

# See http://bugs.python.org/issue19846
ENV LANG=C.UTF-8
ENV PYTHONDONTWRITEBYTECODE=1
# Python won’t try to write .pyc or .pyo files on the import of source modules
ENV PYTHONUNBUFFERED=1
ENV SAGEMAKER_TFS_VERSION="${TFS_SHORT_VERSION}"
ENV PATH="$PATH:/sagemaker"
ENV MODEL_BASE_PATH=/models
# The only required piece is the model name in order to differentiate endpoints
ENV MODEL_NAME=model
# Fix for the interactive mode during an install in step 21
ENV DEBIAN_FRONTEND=noninteractive

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
    emacs \
    git \
    wget \
    unzip \
    vim \
    build-essential \
    zlib1g-dev \
    python3 \
    python3-pip \
    python3-setuptools \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# The 'apt-get install' of nvinfer-runtime-trt-repo-ubuntu1804-4.0.1-ga-cuda10.0
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

RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python

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
    cython==0.29.14 \
    falcon==2.0.0 \
    gunicorn==20.0.4 \
    gevent==1.4.0 \
    requests==2.22.0 \
    grpcio==1.26.0 \
    protobuf==3.11.1 \
# using --no-dependencies to avoid installing tensorflow binary
 && ${PIP} install --no-dependencies --no-cache-dir \
    tensorflow-serving-api-gpu==2.0

COPY ./sagemaker /sagemaker

RUN curl -f $TFS_URL -o /usr/bin/tensorflow_model_server \
 && chmod 555 /usr/bin/tensorflow_model_server

# put tensorflow library (with only error_codes) to python dist-packages
WORKDIR /
RUN mv /sagemaker/tensorflow/ /usr/local/lib/python3.*/dist-packages/

# Expose gRPC and REST port
EXPOSE 8500 8501

# Set where models should be stored in the container
RUN mkdir -p ${MODEL_BASE_PATH}

# Create a script that runs the model server so we can use environment variables
# while also passing in arguments from the docker command line
RUN echo '#!/bin/bash \n\n' > /usr/bin/tf_serving_entrypoint.sh \
 && echo '/usr/bin/tensorflow_model_server --port=8500 --rest_api_port=8501 --model_name=${MODEL_NAME} --model_base_path=${MODEL_BASE_PATH}/${MODEL_NAME} "$@"' >> /usr/bin/tf_serving_entrypoint.sh \
 && chmod +x /usr/bin/tf_serving_entrypoint.sh

RUN HOME_DIR=/root \
 && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
 && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
 && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
 && chmod +x /usr/local/bin/testOSSCompliance \
 && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
 && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} ${PYTHON} \
 && rm -rf ${HOME_DIR}/oss_compliance*

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/tensorflow-2.0.1/license.txt -o /license.txt

CMD ["/usr/bin/tf_serving_entrypoint.sh"]
