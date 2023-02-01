# Docker image for running TPU tensorflow examples.
FROM ubuntu:bionic

RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        wget \
        sudo \
        gnupg \
        lsb-release \
        ca-certificates \
        build-essential \
        git \
        python \
        python-pip \
        python-setuptools && \
    export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && \
    apt-get install --no-install-recommends -y google-cloud-sdk && \
    pip install --no-cache-dir pyyaml && \
    pip install --no-cache-dir wheel && \
    pip install --no-cache-dir tensorflow==1.13.1 && \
    pip install --no-cache-dir google-cloud-storage && \
    pip install --no-cache-dir google-api-python-client && \
    pip install --no-cache-dir oauth2client && rm -rf /var/lib/apt/lists/*;

# Checkout tensorflow/models at the appropriate branch
RUN git clone -b r1.13.0 --depth 1 https://github.com/tensorflow/models.git /tensorflow_models

# Checkout tensorflow/tpu at the appropriate branch
RUN git clone -b r1.13 --depth 1 https://github.com/tensorflow/tpu.git /tensorflow_tpu_models
