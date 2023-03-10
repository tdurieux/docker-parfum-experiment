FROM nvidia/cuda:10.0-base-ubuntu18.04

LABEL maintainer="Amazon AI"
# Specify LABEL for inference pipelines to use SAGEMAKER_BIND_TO_PORT
# https://docs.aws.amazon.com/sagemaker/latest/dg/inference-pipeline-real-time.html
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

# Add arguments to achieve the version, python and url
ARG PYTHON=python3
ARG PIP=pip3
ARG TFS_SHORT_VERSION=1.15.2
ARG TF_MODEL_SERVER_SOURCE=https://tensorflow-aws.s3-us-west-2.amazonaws.com/${TFS_SHORT_VERSION}/Serving/GPU/tensorflow_model_server

# See http://bugs.python.org/issue19846
ENV LANG=C.UTF-8
ENV NCCL_VERSION=2.4.7-1+cuda10.0
ENV CUDNN_VERSION=7.5.1.10-1+cuda10.0
ENV TF_TENSORRT_VERSION=5.0.2
ENV TF_TENSORRT_LIB_VERSION=5.1.2
ENV PYTHONDONTWRITEBYTECODE=1
# Python won’t try to write .pyc or .pyo files on the import of source modules
ENV PYTHONUNBUFFERED=1
ENV SAGEMAKER_TFS_VERSION="${TFS_SHORT_VERSION}"
ENV PATH="$PATH:/sagemaker"
ENV MODEL_BASE_PATH=/models
# The only required piece is the model name in order to differentiate endpoints
ENV MODEL_NAME=model
# Prevent docker build from getting stopped by request for user interaction
ENV DEBIAN_FRONTEND=noninteractive

# https://forums.developer.nvidia.com/t/notice-cuda-linux-repository-key-rotation/212771
# Fix cuda repo's GPG key. Nvidia is no longer updating the machine-learning repo.
# Need to manually pull and install necessary debs to continue using these versions.
RUN rm /etc/apt/sources.list.d/cuda.list \
&& apt-key del 7fa2af80 \
&& apt-get update && apt-get install -y --no-install-recommends wget \
&& wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.0-1_all.deb \
&& dpkg -i cuda-keyring_1.0-1_all.deb \
&& wget https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/libcudnn7_${CUDNN_VERSION}_amd64.deb \
&& dpkg -i libcudnn7_${CUDNN_VERSION}_amd64.deb \
&& wget https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/libnccl2_${NCCL_VERSION}_amd64.deb \
&& dpkg -i libnccl2_${NCCL_VERSION}_amd64.deb \
&& rm *.deb && rm -rf /var/lib/apt/lists/*;

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates \
    cuda-command-line-tools-10-0 \
    cuda-cublas-10-0 \
    cuda-cufft-10-0 \
    cuda-curand-10-0 \
    cuda-cusolver-10-0 \
    cuda-cusparse-10-0 \
    libgomp1 \
    curl \
    git \
    wget \
    vim \
    python3 \
    python3-pip \
    python3-setuptools \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python \
 && ln -s /usr/local/bin/pip3 /usr/bin/pip

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
    boto3 \
    awscli==1.18.34 \
    pyYAML==5.3.1 \
    cython==0.29.12 \
    falcon==2.0.0 \
    gunicorn==19.9.0 \
    gevent==1.4.0 \
    requests==2.22.0 \
    grpcio==1.24.1 \
    protobuf==3.10.0 \
# using --no-dependencies to avoid installing tensorflow binary
 && ${PIP} install --no-dependencies --no-cache-dir \
    tensorflow-serving-api-gpu==1.15.0

# https://forums.developer.nvidia.com/t/notice-cuda-linux-repository-key-rotation/212771
# Fix cuda repo's GPG key. Nvidia is no longer updating the machine-learning repo.
# Need to manually pull and install necessary debs to continue using these versions.
RUN wget https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvinfer-runtime-trt-repo-ubuntu1804-${TF_TENSORRT_VERSION}-ga-cuda10.0_1-1_amd64.deb \
&& dpkg -i nvinfer-runtime-trt-repo-ubuntu1804-${TF_TENSORRT_VERSION}-ga-cuda10.0_1-1_amd64.deb \
&& wget https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/libnvinfer5_${TF_TENSORRT_LIB_VERSION}-1+cuda10.0_amd64.deb \
&& dpkg -i libnvinfer5_${TF_TENSORRT_LIB_VERSION}-1+cuda10.0_amd64.deb \
&& rm *.deb \
&& rm -rf /var/lib/apt/lists/* \
&& rm /usr/lib/x86_64-linux-gnu/libnvinfer_plugin* \
&& rm /usr/lib/x86_64-linux-gnu/libnvcaffe_parser* \
&& rm /usr/lib/x86_64-linux-gnu/libnvparsers*

COPY sagemaker /sagemaker

RUN curl -f ${TF_MODEL_SERVER_SOURCE} -o /usr/bin/tensorflow_model_server \
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

ADD https://raw.githubusercontent.com/aws/aws-deep-learning-containers-utils/master/deep_learning_container.py /usr/local/bin/deep_learning_container.py

RUN chmod +x /usr/local/bin/deep_learning_container.py

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/tensorflow/license.txt -o /license.txt

CMD ["/usr/bin/tf_serving_entrypoint.sh"]
