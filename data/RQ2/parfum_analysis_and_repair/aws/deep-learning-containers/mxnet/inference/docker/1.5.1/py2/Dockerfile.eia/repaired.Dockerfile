FROM ubuntu:16.04

LABEL maintainer="Amazon AI"

LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true
LABEL dlc_major_version="1"

ARG MMS_VERSION=1.1.2
ARG PYTHON=python
ARG HEALTH_CHECK_VERSION=1.7.0

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    emacs \
    git \
    libopencv-dev \
    openjdk-8-jdk-headless \
    python-dev \
    python-pip \
    vim \
    wget \
    zlib1g-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# See http://bugs.python.org/issue19846
ENV LANG=C.UTF-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib" \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=C.UTF-8

WORKDIR /

RUN wget https://amazonei-tools.s3.amazonaws.com/v${HEALTH_CHECK_VERSION}/ei_tools_${HEALTH_CHECK_VERSION}.tar.gz -O /opt/ei_tools_${HEALTH_CHECK_VERSION}.tar.gz \
 && tar -xvf /opt/ei_tools_${HEALTH_CHECK_VERSION}.tar.gz -C /opt/ \
 && rm -rf /opt/ei_tools_${HEALTH_CHECK_VERSION}.tar.gz \
 && chmod a+x /opt/ei_tools/bin/health_check

RUN pip install --no-cache-dir --upgrade \
    pip \
    "setuptools<45.0.0"

RUN pip install --no-cache-dir \
    https://s3.amazonaws.com/amazonei-apachemxnet/amazonei_mxnet-1.5.1-py2.py3-none-manylinux1_x86_64.whl \
    multi-model-server==$MMS_VERSION \
    keras-mxnet==2.2.4.1 \
    numpy==1.16.5 \
    onnx==1.4.1 \
    "sagemaker-mxnet-inference<2"

# This is here to make our installed version of OpenCV work.
# https://stackoverflow.com/questions/29274638/opencv-libdc1394-error-failed-to-initialize-libdc1394
# TODO: Should we be installing OpenCV in our image like this? Is there another way we can fix this?
RUN ln -s /dev/null /dev/raw1394

RUN useradd -m model-server \
 && mkdir -p /home/model-server/tmp \
 && chown -R model-server /home/model-server

COPY mms-entrypoint.py /usr/local/bin/dockerd-entrypoint.py
COPY config.properties /home/model-server

RUN chmod +x /usr/local/bin/dockerd-entrypoint.py

EXPOSE 8080 8081
ENV TEMP=/home/model-server/tmp
ENTRYPOINT ["python", "/usr/local/bin/dockerd-entrypoint.py"]
CMD ["multi-model-server", "--start", "--mms-config", "/home/model-server/config.properties"]