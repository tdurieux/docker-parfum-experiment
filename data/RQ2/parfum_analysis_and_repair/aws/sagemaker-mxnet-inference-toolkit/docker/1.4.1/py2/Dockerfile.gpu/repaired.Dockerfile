FROM nvidia/cuda:10.0-cudnn7-runtime-ubuntu16.04

LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    fakeroot \
    ca-certificates \
    dpkg-dev \
    g++ \
    python-dev \
    openjdk-8-jdk-headless \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/* \
    && cd /tmp \
    && curl -f -O https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py

RUN update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    libopencv-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /

COPY sagemaker_mxnet_serving_container.tar.gz /sagemaker_mxnet_serving_container.tar.gz

RUN pip install --no-cache-dir --no-cache mxnet-cu100mkl==1.4.1 \
                           mxnet-model-server==1.0.5 \
                           keras-mxnet==2.2.4.1 \
                           numpy==1.14.5 \
                           onnx==1.4.1 \
                           /sagemaker_mxnet_serving_container.tar.gz && \
    rm /sagemaker_mxnet_serving_container.tar.gz

# This is here to make our installed version of OpenCV work.
# https://stackoverflow.com/questions/29274638/opencv-libdc1394-error-failed-to-initialize-libdc1394
# TODO: Should we be installing OpenCV in our image like this? Is there another way we can fix this?
RUN ln -s /dev/null /dev/raw1394

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib" \
    PYTHONIOENCODING=UTF-8 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN mkdir -p /home/model-server/tmp

COPY dockerd-entrypoint.sh /usr/local/bin/dockerd-entrypoint.sh
COPY config.properties /home/model-server

RUN chmod +x /usr/local/bin/dockerd-entrypoint.sh

EXPOSE 8080 8081

WORKDIR /home/model-server
ENV TEMP=/home/model-server/tmp
CMD ["serve"]
ENTRYPOINT []
