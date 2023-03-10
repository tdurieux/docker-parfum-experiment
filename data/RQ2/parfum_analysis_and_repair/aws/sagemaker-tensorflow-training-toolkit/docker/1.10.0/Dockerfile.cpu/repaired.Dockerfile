FROM ubuntu:16.04

MAINTAINER Amazon AI

ARG framework_installable
ARG framework_support_installable=sagemaker_tensorflow_container-2.0.0.tar.gz
ARG py_version

# Validate that arguments are specified
RUN test $framework_installable || exit 1 \
    && test $py_version || exit 1

WORKDIR /root

COPY $framework_installable .
COPY $framework_support_installable .

RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa -y && rm -rf /var/lib/apt/lists/*;

RUN buildDeps=" \
        build-essential \
        curl \
        git \
        libcurl3-dev \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        rsync \
        unzip \
        zip \
        zlib1g-dev \
        openjdk-8-jdk \
        openjdk-8-jre-headless \
        wget \
        vim \
        iputils-ping \
        nginx \
    " \
    && apt-get update && apt-get install -y --no-install-recommends $buildDeps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN if [ $py_version -eq 3 ]; \
        then \
        apt-get update && apt-get install -y --no-install-recommends python3.6-dev \
             && ln -s -f /usr/bin/python3.6 /usr/bin/python; rm -rf /var/lib/apt/lists/*; \
        else apt-get update && apt-get install -y --no-install-recommends python-dev; rm -rf /var/lib/apt/lists/*; fi

RUN curl -fSsL -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip install --no-cache-dir --upgrade \
    pip \
    setuptools

# Set environment variables for MKL
# TODO: investigate the right value for OMP_NUM_THREADS
# For more about MKL with TensorFlow see:
# https://www.tensorflow.org/performance/performance_guide#tensorflow_with_intel%C2%AE_mkl_dnn
ENV KMP_AFFINITY=granularity=fine,compact,1,0 KMP_BLOCKTIME=1 KMP_SETTINGS=0

RUN framework_installable_local=$(basename $framework_installable) \
    && framework_support_installable_local=$(basename $framework_support_installable) \
    && pip install --no-cache-dir --no-cache --upgrade \
    $framework_installable_local \
    $framework_support_installable_local \
    "sagemaker-tensorflow>=1.10,<1.11" \

    && rm $framework_installable_local \
    && rm $framework_support_installable_local

ENV SAGEMAKER_TRAINING_MODULE sagemaker_tensorflow_container.training:main
