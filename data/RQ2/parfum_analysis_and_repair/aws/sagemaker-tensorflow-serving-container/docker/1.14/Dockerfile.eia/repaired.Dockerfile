FROM public.ecr.aws/e2s1w5p1/ubuntu:16.04
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

ARG TFS_SHORT_VERSION=1.14
ARG S3_TF_VERSION=1-14-0
ARG S3_TF_EI_VERSION=1-4
ARG PYTHON=python3
ARG PYTHON_VERSION=3.6.6
ARG HEALTH_CHECK_VERSION=1.5.3

# See http://bugs.python.org/issue19846
ENV LANG=C.UTF-8
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV MODEL_BASE_PATH=/models
ENV MODEL_NAME=model
ENV SAGEMAKER_TFS_VERSION="${TFS_SHORT_VERSION}"
ENV PATH="$PATH:/sagemaker"

# nginx + njs
RUN apt-get update \
 && apt-get -y install --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    gnupg2 \
    vim \
    wget \
    zlib1g-dev \
 && curl -f -s https://nginx.org/keys/nginx_signing.key | apt-key add - \
 && echo 'deb http://nginx.org/packages/ubuntu/ xenial nginx' >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get -y install --no-install-recommends nginx wget nginx-module-njs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
 && tar -xvf Python-$PYTHON_VERSION.tgz \
 && cd Python-$PYTHON_VERSION \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
 && make \
 && make install \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    libbz2-dev \
    libc6-dev \
    libgdbm-dev \
    libncursesw5-dev \
    libreadline-gplv2-dev \
    libsqlite3-dev \
    libssl-dev \
    tk-dev \
 && rm -rf /var/lib/apt/lists/* \
 && make \
 && make install \
 && rm -rf ../Python-$PYTHON_VERSION* \
 && ln -s /usr/local/bin/pip3 /usr/bin/pip \
 && ln -s $(which ${PYTHON}) /usr/local/bin/python && rm Python-$PYTHON_VERSION.tgz

# Some TF tools expect a "python" binary
RUN pip install -U --no-cache-dir --upgrade \
    pip \
    setuptools

# cython, falcon, gunicorn, grpc
RUN pip install --no-cache-dir \
    cython==0.29.13 \
    falcon==2.0.0 \
    gunicorn==19.9.0 \
    gevent==1.4.0 \
    requests==2.22.0 \
    docutils==0.14 \
    awscli==1.16.196 \
    grpcio==1.24.1 \
    protobuf==3.10.0 \
# using --no-dependencies to avoid installing tensorflow binary
 && pip install --no-dependencies --no-cache-dir \
    tensorflow-serving-api==1.14.0

COPY sagemaker /sagemaker

RUN wget https://amazonei-tools.s3.amazonaws.com/v${HEALTH_CHECK_VERSION}/ei_tools_${HEALTH_CHECK_VERSION}.tar.gz -O /opt/ei_tools_${HEALTH_CHECK_VERSION}.tar.gz \
 && tar -xvf /opt/ei_tools_${HEALTH_CHECK_VERSION}.tar.gz -C /opt/ \
 && rm -rf /opt/ei_tools_${HEALTH_CHECK_VERSION}.tar.gz \
 && chmod a+x /opt/ei_tools/bin/health_check \
 && mkdir -p /opt/ei_health_check/bin \
 && ln -s /opt/ei_tools/bin/health_check /opt/ei_health_check/bin/health_check \
 && ln -s /opt/ei_tools/lib /opt/ei_health_check/lib

# Expose ports
EXPOSE 8500 8501

RUN wget https://amazonei-tensorflow.s3.amazonaws.com/tensorflow-serving/v1.14/ubuntu/archive/tensorflow-serving-${S3_TF_VERSION}-ubuntu-ei-${S3_TF_EI_VERSION}.tar.gz \
            -O /tmp/tensorflow-serving-${S3_TF_VERSION}-ubuntu-ei-${S3_TF_EI_VERSION}.tar.gz \
 && cd /tmp \
 && tar zxf tensorflow-serving-${S3_TF_VERSION}-ubuntu-ei-${S3_TF_EI_VERSION}.tar.gz \
 && mv tensorflow-serving-${S3_TF_VERSION}-ubuntu-ei-${S3_TF_EI_VERSION}/amazonei_tensorflow_model_server /usr/bin/tensorflow_model_server \
 && chmod +x /usr/bin/tensorflow_model_server \
 && rm -rf tensorflow-serving-${S3_TF_VERSION}* && rm tensorflow-serving-${S3_TF_VERSION}-ubuntu-ei-${S3_TF_EI_VERSION}.tar.gz

# Set where models should be stored in the container
RUN mkdir -p ${MODEL_BASE_PATH}

RUN echo '#!/bin/bash \n\n' > /usr/bin/tf_serving_entrypoint.sh \
 && echo '/usr/bin/tensorflow_model_server --port=8500 --rest_api_port=8501 --model_name=${MODEL_NAME} --model_base_path=${MODEL_BASE_PATH}/${MODEL_NAME} "$@"' >> /usr/bin/tf_serving_entrypoint.sh \
 && chmod +x /usr/bin/tf_serving_entrypoint.sh

CMD ["/usr/bin/tf_serving_entrypoint.sh"]
