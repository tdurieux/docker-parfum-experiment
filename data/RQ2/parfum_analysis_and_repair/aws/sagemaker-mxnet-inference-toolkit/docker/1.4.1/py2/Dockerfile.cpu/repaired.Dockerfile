FROM awsdeeplearningteam/mxnet-model-server:base-cpu-py2.7

LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    libopencv-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /

COPY sagemaker_mxnet_serving_container.tar.gz /sagemaker_mxnet_serving_container.tar.gz

RUN pip install --no-cache-dir --no-cache mxnet-mkl==1.4.1 \
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

ENTRYPOINT []
