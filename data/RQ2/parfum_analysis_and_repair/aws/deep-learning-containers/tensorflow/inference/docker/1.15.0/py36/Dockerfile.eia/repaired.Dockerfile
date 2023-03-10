FROM ubuntu:18.04

LABEL maintainer="Amazon AI"
# Specify LABEL for inference pipelines to use SAGEMAKER_BIND_TO_PORT
# https://docs.aws.amazon.com/sagemaker/latest/dg/inference-pipeline-real-time.html
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true
LABEL dlc_major_version="2"

# Add arguments to achieve the version, python and url
ARG PYTHON=python3
ARG PYTHON_PIP=python3-pip
ARG PIP=pip3
ARG PYTHON_VERSION=3.6.13
ARG HEALTH_CHECK_VERSION=1.7.0
ARG S3_TF_EI_VERSION=1-5
ARG S3_TF_VERSION=1-15-2
#This is the serving version not TF version
ARG TFS_SHORT_VERSION=1-15-0


# See http://bugs.python.org/issue19846
ENV LANG=C.UTF-8
# Python won’t try to write .pyc or .pyo files on the import of source modules
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV SAGEMAKER_TFS_VERSION="${TFS_SHORT_VERSION}"
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
    emacs \
    git \
    wget \
    unzip \
    build-essential \
    vim \
 && curl -f -s https://nginx.org/keys/nginx_signing.key | apt-key add - \
 && echo 'deb http://nginx.org/packages/ubuntu/ bionic nginx' >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get -y install --no-install-recommends \
    nginx \
    nginx-module-njs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    libbz2-dev \
    libc6-dev \
    libffi-dev \
    libgdbm-dev \
    libncursesw5-dev \
    libreadline-gplv2-dev \
    libsqlite3-dev \
    libssl-dev \
    tk-dev \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean

RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
 && tar -xvf Python-$PYTHON_VERSION.tgz \
 && cd Python-$PYTHON_VERSION \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install \
 && rm -rf ../Python-$PYTHON_VERSION* && rm Python-$PYTHON_VERSION.tgz

RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python \
 && ln -s $(which ${PIP}) /usr/bin/pip

# cython, falcon, gunicorn, grpc
RUN ${PIP} install --no-cache-dir \
    "awscli<2" \
    boto3 \
    cython==0.29.21 \
    falcon==2.0.0 \
    gunicorn==20.0.4 \
    gevent==1.5.0 \
    requests==2.24.0 \
    grpcio==1.31.0 \
    protobuf==3.12.4 \
# using --no-dependencies to avoid installing tensorflow binary
 && ${PIP} install --no-dependencies --no-cache-dir \
    tensorflow-serving-api==1.15.0

COPY sagemaker /sagemaker

# Get EI tools
RUN wget https://amazonei-tools.s3.amazonaws.com/v${HEALTH_CHECK_VERSION}/ei_tools_${HEALTH_CHECK_VERSION}.tar.gz -O /opt/ei_tools_${HEALTH_CHECK_VERSION}.tar.gz \
 && tar -xvf /opt/ei_tools_${HEALTH_CHECK_VERSION}.tar.gz -C /opt/ \
 && rm -rf /opt/ei_tools_${HEALTH_CHECK_VERSION}.tar.gz \
 && chmod a+x /opt/ei_tools/bin/health_check \
 && mkdir -p /opt/ei_health_check/bin \
 && ln -s /opt/ei_tools/bin/health_check /opt/ei_health_check/bin/health_check \
 && ln -s /opt/ei_tools/lib /opt/ei_health_check/lib

RUN wget https://amazonei-tensorflow.s3.amazonaws.com/tensorflow-serving/v1.15/ubuntu/archive/tensorflow-serving-${S3_TF_VERSION}-ubuntu-ei-${S3_TF_EI_VERSION}.tar.gz \
 -O /tmp/tensorflow-serving-${S3_TF_VERSION}-ubuntu-ei-${S3_TF_EI_VERSION}.tar.gz \
 && cd /tmp \
 && tar zxf tensorflow-serving-${S3_TF_VERSION}-ubuntu-ei-${S3_TF_EI_VERSION}.tar.gz \
 && mv tensorflow-serving-${S3_TF_VERSION}-ubuntu-ei-${S3_TF_EI_VERSION}/amazonei_tensorflow_model_server /usr/bin/tensorflow_model_server \
 && chmod +x /usr/bin/tensorflow_model_server \
 && rm -rf tensorflow-serving-${S3_TF_VERSION}* && rm tensorflow-serving-${S3_TF_VERSION}-ubuntu-ei-${S3_TF_EI_VERSION}.tar.gz


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

RUN HOME_DIR=/root \
 && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
 && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
 && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
 && chmod +x /usr/local/bin/testOSSCompliance \
 && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
 && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} ${PYTHON} \
 && rm -rf ${HOME_DIR}/oss_compliance*

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/tensorflow/license.txt -o /license.txt

CMD ["/usr/bin/tf_serving_entrypoint.sh"]
