FROM ubuntu:16.04

ARG py_version
ARG framework_support_installable

# Validate that arguments are specified
RUN test $framework_support_installable || exit 1 && \
    test $py_version || exit 1

LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        libopencv-dev \
        curl && \
    if [ $py_version -eq 3 ]; then PYTHON_VERSION=python3.6; else PYTHON_VERSION=python2.7; fi && \
        apt-get update && apt-get install -y --no-install-recommends $PYTHON_VERSION-dev --allow-unauthenticated  && \
        ln -s -f /usr/bin/$PYTHON_VERSION /usr/bin/python && \
    rm -rf /var/lib/apt/lists/*

# Install pip
RUN cd /tmp && \
    curl -f -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py 'pip==19.1' && rm get-pip.py

WORKDIR /

COPY $framework_support_installable /sagemaker_mxnet_container.tar.gz

RUN pip install --no-cache-dir --no-cache mxnet-mkl==1.4.0 \
                           keras-mxnet==2.2.4.1 \
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
