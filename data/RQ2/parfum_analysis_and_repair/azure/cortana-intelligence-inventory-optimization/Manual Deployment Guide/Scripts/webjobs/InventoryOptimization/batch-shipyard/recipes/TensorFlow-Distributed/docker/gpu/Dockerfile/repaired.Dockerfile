# Dockerfile for TensorFlow-GPU-Distributed for use with Batch Shipyard on Azure Batch

FROM alfpark/tensorflow:1.0.0-gpu-base
MAINTAINER Fred Park <https://github.com/Azure/batch-shipyard>

COPY ssh_config /root/.ssh/config
RUN apt-get update && apt-get install -y --no-install-recommends \
        openssh-client \
        openssh-server \
        iproute2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    # configure ssh server and keys