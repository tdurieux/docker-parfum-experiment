FROM ubuntu:16.04

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="3"

# Specify accept-bind-to-port LABEL for inference pipelines to use SAGEMAKER_BIND_TO_PORT
# https://docs.aws.amazon.com/sagemaker/latest/dg/inference-pipeline-real-time.html
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true
# Specify multi-models LABEL to indicate container is capable of loading and serving multiple models concurrently
# https://docs.aws.amazon.com/sagemaker/latest/dg/build-multi-model-build-container.html
LABEL com.amazonaws.sagemaker.capabilities.multi-models=true

ARG MMS_VERSION=1.1.2
ARG MX_URL=https://aws-mxnet-pypi.s3-us-west-2.amazonaws.com/1.6.0/aws_mxnet_mkl-1.6.0-py2.py3-none-manylinux1_x86_64.whl
ARG PYTHON=python
ARG PYTHON_PIP=python-pip
ARG PIP=pip
ARG OPENSSL_VERSION=1.1.1k

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib" \
    PYTHONIOENCODING=UTF-8 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TEMP=/home/model-server/tmp

RUN apt-get update \
 && apt-get -y install --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    emacs \
    git \
    libopencv-dev \
    openjdk-8-jdk-headless \
    vim \
    wget \
    zlib1g-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN wget -c https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz \
 && apt-get update \
 && apt remove -y --purge openssl \
 && rm -rf /usr/include/openssl \
 && apt-get install --no-install-recommends -y \
    ca-certificates \
 && tar -xzvf openssl-${OPENSSL_VERSION}.tar.gz \
 && cd openssl-${OPENSSL_VERSION} \
 && ./config && make && make test \
 && make install \
 && ldconfig \
 && cd .. && rm -rf openssl-* && rm openssl-${OPENSSL_VERSION}.tar.gz && rm -rf /var/lib/apt/lists/*;

# when we remove previous openssl, the ca-certificates pkgs and its symlinks gets deleted
# causing sslcertverificationerror the below steps are to fix that
RUN ln -s /etc/ssl/certs/*.* /usr/local/ssl/certs/

RUN apt-get update \
 && apt-get -y install --no-install-recommends \
    openjdk-8-jdk \
    openjdk-8-jre \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
    ${PYTHON} \
    ${PYTHON_PIP} && rm -rf /var/lib/apt/lists/*;

RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools==44.1.0

WORKDIR /

RUN ${PIP} install --no-cache-dir \
    ${MX_URL} \
    # setuptools<45.0.0 because support for py2 stops with 45.0.0
    # https://github.com/pypa/setuptools/blob/master/CHANGES.rst#v4500
    "setuptools<45.0.0" \
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

ADD https://raw.githubusercontent.com/aws/deep-learning-containers/master/src/deep_learning_container.py /usr/local/bin/deep_learning_container.py

RUN chmod +x /usr/local/bin/deep_learning_container.py

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/aws-mxnet-1.6.0/license.txt -o /license.txt

EXPOSE 8080 8081
ENTRYPOINT ["python", "/usr/local/bin/dockerd-entrypoint.py"]
CMD ["multi-model-server", "--start", "--mms-config", "/home/model-server/config.properties"]
