FROM nvidia/cuda:9.0-base-ubuntu16.04

MAINTAINER Amazon AI

ARG framework_installable
ARG framework_support_installable=sagemaker_tensorflow_container-2.0.0.tar.gz
ARG py_version

# Validate that arguments are specified
RUN test $framework_installable || exit 1 \
    && test $py_version || exit 1

RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa -y && rm -rf /var/lib/apt/lists/*;

RUN buildDeps=" \
        build-essential \
        cuda-command-line-tools-9-0 \
        cuda-cublas-dev-9-0 \
        cuda-cudart-dev-9-0 \
        cuda-cufft-dev-9-0 \
        cuda-curand-dev-9-0 \
        cuda-cusolver-dev-9-0 \
        cuda-cusparse-dev-9-0 \
        curl \
        git \
        libcudnn7=7.1.4.18-1+cuda9.0 \
        libcudnn7-dev=7.1.4.18-1+cuda9.0 \
        libcurl3-dev \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        rsync \
        unzip \
        zip \
        zlib1g-dev \
        wget \
        vim \
        nginx \
        iputils-ping \
    " \
    && apt-get update && apt-get install -y --no-install-recommends $buildDeps \
    && rm -rf /var/lib/apt/lists/* \
    && find /usr/local/cuda-9.0/lib64/ -type f -name 'lib*_static.a' -not -name 'libcudart_static.a' -delete \
    && rm /usr/lib/x86_64-linux-gnu/libcudnn_static_v7.a

RUN if [ $py_version -eq 3 ]; \
        then \
        apt-get update && apt-get install -y --no-install-recommends python3.6-dev \
             && ln -s -f /usr/bin/python3.6 /usr/bin/python; rm -rf /var/lib/apt/lists/*; \
        else apt-get update && apt-get install -y --no-install-recommends python-dev; rm -rf /var/lib/apt/lists/*; fi

RUN curl -fSsL -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

WORKDIR /root

COPY $framework_installable .
COPY $framework_support_installable .

RUN framework_installable_local=$(basename $framework_installable) && \
    framework_support_installable_local=$(basename $framework_support_installable) && \

    pip install --no-cache-dir --no-cache --upgrade $framework_installable_local \
    $framework_support_installable_local \
    "sagemaker-tensorflow>=1.10,<1.11" && \

    rm $framework_installable_local && \
    rm $framework_support_installable_local

ENV SAGEMAKER_TRAINING_MODULE sagemaker_tensorflow_container.training:main
