FROM nvidia/cuda:10.1-base-ubuntu18.04

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="6"

ENV NCCL_VERSION=2.4.7-1+cuda10.1
ENV CUDNN_VERSION=7.6.2.24-1+cuda10.1
ENV TF_TENSORRT_VERSION=6.0.1

# allow unauthenticated and allow downgrades for special libcublas library
RUN apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated --allow-downgrades \
    ca-certificates \
    cuda-command-line-tools-10-1 \
    cuda-cufft-10-1 \
    cuda-curand-10-1 \
    cuda-cusolver-10-1 \
    cuda-cusparse-10-1 \
    #cuda-cublas-dev not available with 10-1, install libcublas instead
    libcublas10=10.1.0.105-1 \
    libcublas-dev=10.1.0.105-1 \
    libcudnn7=${CUDNN_VERSION} \
    libnccl2=${NCCL_VERSION} \
    libgomp1 \
    curl \
    emacs \
    git \
    wget \
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
 && apt-get install -y --no-install-recommends nvinfer-runtime-trt-repo-ubuntu1804-5.0.2-ga-cuda10.0 \
 && apt-get update \
 && apt-get install -y --no-install-recommends libnvinfer6=${TF_TENSORRT_VERSION}-1+cuda10.1 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

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

RUN apt-get update && apt-get install -y --no-install-recommends \
    ${PYTHON} \
    ${PYTHON_PIP} && rm -rf /var/lib/apt/lists/*;

RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python

RUN curl -f https://tensorflow-aws.s3-us-west-2.amazonaws.com/2.1/Serving/GPU/tensorflow_model_server --output /usr/bin/tensorflow_model_server \
 && chmod 555 /usr/bin/tensorflow_model_server

RUN pip install -U --no-cache-dir \
    docutils==0.15.2 \
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

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/tensorflow-2.1.0/license.txt -o /license.txt

CMD ["/usr/bin/tf_serving_entrypoint.sh"]
