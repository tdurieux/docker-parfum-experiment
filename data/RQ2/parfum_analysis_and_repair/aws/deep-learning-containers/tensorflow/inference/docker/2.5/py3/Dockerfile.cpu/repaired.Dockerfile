FROM ubuntu:18.04

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"
# Specify accept-bind-to-port LABEL for inference pipelines to use SAGEMAKER_BIND_TO_PORT
# https://docs.aws.amazon.com/sagemaker/latest/dg/inference-pipeline-real-time.html
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true
LABEL com.amazonaws.sagemaker.capabilities.multi-models=true

ARG PYTHON=python3.7
ARG PYTHON_PIP=python3-pip
ARG PIP=pip3
ARG PYTHON_VERSION=3.7.10
ARG TFS_SHORT_VERSION=2.5
ARG TFS_URL=https://aws-ei-tensorflow-binaries.s3-us-west-2.amazonaws.com/serving/r2.5_aws/20210514-062547/cpu/py37/tensorflow_model_server

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
ENV DEBIAN_FRONTEND=noninteractive

# nginx + njs
RUN apt-get update \
 # TODO: Remove systemd upgrade once it is updated in base image
 && apt-get -y upgrade --only-upgrade systemd \
 && apt-get -y install --no-install-recommends \
    curl \
    gnupg2 \
    ca-certificates \
    emacs \
    git \
    unzip \
    wget \
    vim \
    libbz2-dev \
    liblzma-dev \
    libffi-dev \
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
 && curl -f -s https://nginx.org/keys/nginx_signing.key | apt-key add - \
 && echo 'deb http://nginx.org/packages/ubuntu/ bionic nginx' >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get -y install --no-install-recommends \
    nginx \
    nginx-module-njs \
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

# cython, falcon, gunicorn, grpc
RUN ${PIP} install --no-cache-dir \
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
    tensorflow-serving-api==2.5.1

COPY ./sagemaker /sagemaker

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python \
 && ln -s $(which ${PIP}) /usr/bin/pip

RUN curl -f https://tensorflow-aws.s3-us-west-2.amazonaws.com/MKL-Libraries/libiomp5.so -o /usr/local/lib/libiomp5.so
RUN curl -f https://tensorflow-aws.s3-us-west-2.amazonaws.com/MKL-Libraries/libmklml_intel.so -o /usr/local/lib/libmklml_intel.so

RUN curl -f $TFS_URL -o /usr/bin/tensorflow_model_server \
 && chmod 555 /usr/bin/tensorflow_model_server

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
