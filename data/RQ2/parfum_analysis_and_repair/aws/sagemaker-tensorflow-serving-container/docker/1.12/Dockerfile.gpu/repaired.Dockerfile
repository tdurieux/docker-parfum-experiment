ARG TFS_VERSION

FROM tensorflow/serving:${TFS_VERSION}-gpu as tfs
FROM nvidia/cuda:9.0-base-ubuntu16.04
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

COPY --from=tfs /usr/bin/tensorflow_model_server /usr/bin/tensorflow_model_server

# https://github.com/tensorflow/serving/blob/1.12.0/tensorflow_serving/tools/docker/Dockerfile.gpu
ENV NCCL_VERSION=2.2.13
ENV CUDNN_VERSION=7.2.1.38
ENV TF_TENSORRT_VERSION=4.1.2

RUN \
    apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        cuda-command-line-tools-9-0 \
        cuda-command-line-tools-9-0 \
        cuda-cublas-9-0 \
        cuda-cufft-9-0 \
        cuda-curand-9-0 \
        cuda-cusolver-9-0 \
        cuda-cusparse-9-0 \
        libcudnn7=${CUDNN_VERSION}-1+cuda9.0 \
        libnccl2=${NCCL_VERSION}-1+cuda9.0 \
        libgomp1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# The 'apt-get install' of nvinfer-runtime-trt-repo-ubuntu1604-4.0.1-ga-cuda9.0
# adds a new list which contains libnvinfer library, so it needs another
# 'apt-get update' to retrieve that list before it can actually install the
# library.
# We don't install libnvinfer-dev since we don't need to build against TensorRT,
# and libnvinfer4 doesn't contain libnvinfer.a static library.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nvinfer-runtime-trt-repo-ubuntu1604-4.0.1-ga-cuda9.0 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        libnvinfer4=${TF_TENSORRT_VERSION}-1+cuda9.0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm /usr/lib/x86_64-linux-gnu/libnvinfer_plugin* && \
    rm /usr/lib/x86_64-linux-gnu/libnvcaffe_parser* && \
    rm /usr/lib/x86_64-linux-gnu/libnvparsers*

# nginx + njs
RUN \
    apt-get update && \
    apt-get -y install --no-install-recommends curl && \
    curl -f -s https://nginx.org/keys/nginx_signing.key | apt-key add - && \
    echo 'deb http://nginx.org/packages/ubuntu/ xenial nginx' >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y install --no-install-recommends nginx nginx-module-njs python3 python3-pip python3-setuptools && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

# cython, falcon, gunicorn, tensorflow-serving
RUN \
    pip3 install --no-cache-dir cython falcon gunicorn gevent requests grpcio protobuf && \
    pip3 install --no-dependencies --no-cache-dir tensorflow-serving-api==1.12.0

COPY ./ /


ARG TFS_SHORT_VERSION
ENV SAGEMAKER_TFS_VERSION "${TFS_SHORT_VERSION}"
ENV PATH "$PATH:/sagemaker"
