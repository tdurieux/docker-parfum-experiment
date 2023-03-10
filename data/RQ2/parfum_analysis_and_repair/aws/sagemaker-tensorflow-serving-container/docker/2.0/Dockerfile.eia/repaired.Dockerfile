FROM ubuntu:18.04

LABEL maintainer="Amazon AI"
# Specify LABEL for inference pipelines to use SAGEMAKER_BIND_TO_PORT
# https://docs.aws.amazon.com/sagemaker/latest/dg/inference-pipeline-real-time.html
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

# Add arguments to achieve the version, python and url
ARG PYTHON=python3
ARG PIP=pip3
ARG HEALTH_CHECK_VERSION=1.6.3
ARG S3_TF_EI_VERSION=1-5
ARG S3_TF_VERSION=2-0-0


# See http://bugs.python.org/issue19846
ENV LANG=C.UTF-8
# Python won’t try to write .pyc or .pyo files on the import of source modules
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV SAGEMAKER_TFS_VERSION="${S3_TF_VERSION}"
ENV PATH="$PATH:/sagemaker"
ENV LD_LIBRARY_PATH='/usr/local/lib:$LD_LIBRARY_PATH'
ENV MODEL_BASE_PATH=/models
# The only required piece is the model name in order to differentiate endpoints
ENV MODEL_NAME=model
# To prevent user interaction when installing time zone data package
ENV DEBIAN_FRONTEND=noninteractive

# nginx + njs
RUN apt-get update \
 && apt-get -y install --no-install-recommends \
    curl \
    gnupg2 \
    ca-certificates \
    git \
    wget \
    vim \
 && curl -f -s https://nginx.org/keys/nginx_signing.key | apt-key add - \
 && echo 'deb http://nginx.org/packages/ubuntu/ bionic nginx' >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get -y install --no-install-recommends \
    nginx \
    nginx-module-njs \
    python3 \
    python3-pip \
    python3-setuptools \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools

# cython, falcon, gunicorn, grpc
RUN ${PIP} install --no-cache-dir \
    awscli==1.18.32 \
    cython==0.29.16 \
    falcon==2.0.0 \
    gunicorn==20.0.4 \
    gevent==1.4.0 \
    requests==2.23.0 \
    grpcio==1.27.2 \
    protobuf==3.11.3 \
# using --no-dependencies to avoid installing tensorflow binary
 && ${PIP} install --no-dependencies --no-cache-dir \
    tensorflow-serving-api==2.0.0

COPY sagemaker /sagemaker

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python \
 && ln -s /usr/local/bin/pip3 /usr/bin/pip

# Get EI tools
RUN wget https://amazonei-tools.s3.amazonaws.com/v${HEALTH_CHECK_VERSION}/ei_tools_${HEALTH_CHECK_VERSION}.tar.gz -O /opt/ei_tools_${HEALTH_CHECK_VERSION}.tar.gz \
 && tar -xvf /opt/ei_tools_${HEALTH_CHECK_VERSION}.tar.gz -C /opt/ \
 && rm -rf /opt/ei_tools_${HEALTH_CHECK_VERSION}.tar.gz \
 && chmod a+x /opt/ei_tools/bin/health_check \
 && mkdir -p /opt/ei_health_check/bin \
 && ln -s /opt/ei_tools/bin/health_check /opt/ei_health_check/bin/health_check \
 && ln -s /opt/ei_tools/lib /opt/ei_health_check/lib

RUN wget https://amazonei-tensorflow.s3.amazonaws.com/tensorflow-serving/v2.0/archive/tensorflow-serving-${S3_TF_VERSION}-ei-${S3_TF_EI_VERSION}.tar.gz \
 -O /tmp/tensorflow-serving-${S3_TF_VERSION}-ei-${S3_TF_EI_VERSION}.tar.gz \
 && cd /tmp \
 && tar zxf tensorflow-serving-${S3_TF_VERSION}-ei-${S3_TF_EI_VERSION}.tar.gz \
 && mv tensorflow-serving-${S3_TF_VERSION}-ei-${S3_TF_EI_VERSION}/amazonei_tensorflow_model_server /usr/bin/tensorflow_model_server \
 && chmod +x /usr/bin/tensorflow_model_server \
 && rm -rf tensorflow-serving-${S3_TF_VERSION}* && rm tensorflow-serving-${S3_TF_VERSION}-ei-${S3_TF_EI_VERSION}.tar.gz


# Expose ports
# gRPC and REST
EXPOSE 8500 8501

# Set where models should be stored in the container
RUN mkdir -p ${MODEL_BASE_PATH}

# Create a script that runs the model server so we can use environment variables
# while also passing in arguments from the docker command line
RUN echo '#!/bin/bash \n\n' > /usr/bin/tf_serving_entrypoint.sh \
 && echo '/usr/bin/tensorflow_model_server --port=8500 --rest_api_port=8501 --model_name=${MODEL_NAME} --model_base_path=${MODEL_BASE_PATH}/${MODEL_NAME} "$@"' >> /usr/bin/tf_serving_entrypoint.sh \
 && chmod +x /usr/bin/tf_serving_entrypoint.sh

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/tensorflow-2.0/license.txt -o /license.txt

CMD ["/usr/bin/tf_serving_entrypoint.sh"]
