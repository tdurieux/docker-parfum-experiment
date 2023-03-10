FROM nvidia/cuda:10.0-cudnn7-runtime-ubuntu16.04

ARG framework_support_installable

# Validate that arguments are specified
RUN test $framework_support_installable || exit 1

LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        libopencv-dev \
        curl && \
    apt-get update && apt-get install -y --no-install-recommends python2.7-dev && \
        ln -s -f /usr/bin/python2.7 /usr/bin/python && \
    rm -rf /var/lib/apt/lists/*

# Install pip
RUN cd /tmp && \
    curl -f -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py 'pip==19.1' && rm get-pip.py

WORKDIR /

COPY $framework_support_installable /sagemaker_mxnet_container.tar.gz

RUN pip install --no-cache-dir --no-cache mxnet-cu100mkl==1.4.1 \
                           keras-mxnet==2.2.4.1 \
                           numpy==1.14.5 \
                           onnx==1.4.1 \
                           /sagemaker_mxnet_container.tar.gz && \
    rm /sagemaker_mxnet_container.tar.gz

# "channels first" is recommended for keras-mxnet
# https://github.com/awslabs/keras-apache-mxnet/blob/master/docs/mxnet_backend/performance_guide.md#channels-first-image-data-format-for-cnn
RUN mkdir /root/.keras && \
    echo '{"image_data_format": "channels_first"}' > /root/.keras/keras.json

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

ENV SAGEMAKER_TRAINING_MODULE sagemaker_mxnet_container.training:main
