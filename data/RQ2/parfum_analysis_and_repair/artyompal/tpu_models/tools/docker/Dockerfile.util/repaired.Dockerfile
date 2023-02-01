# Docker image of TensorBoard and TPU Profiler.
FROM ubuntu:bionic
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        build-essential \
        git \
        python \
        python-pip \
        python-setuptools && \
    pip install --no-cache-dir tensorflow==1.11 && \
    pip install --no-cache-dir google-cloud-storage && \
    pip install --no-cache-dir google-api-python-client && \
    pip install --no-cache-dir oauth2client && \
    pip install --no-cache-dir cloud-tpu-profiler==1.11 && rm -rf /var/lib/apt/lists/*;