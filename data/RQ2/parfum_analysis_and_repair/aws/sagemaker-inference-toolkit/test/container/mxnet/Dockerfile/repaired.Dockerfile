FROM public.ecr.aws/e2s1w5p1/ubuntu:16.04

LABEL maintainer="Amazon AI"

# Specify accept-bind-to-port LABEL for inference pipelines to use SAGEMAKER_BIND_TO_PORT
# https://docs.aws.amazon.com/sagemaker/latest/dg/inference-pipeline-real-time.html
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true
# Specify multi-models LABEL to indicate container is capable of loading and serving multiple models concurrently
# https://docs.aws.amazon.com/sagemaker/latest/dg/build-multi-model-build-container.html
LABEL com.amazonaws.sagemaker.capabilities.multi-models=true

ARG MMS_VERSION=1.1.2
ARG MX_URL=https://aws-mxnet-pypi.s3-us-west-2.amazonaws.com/1.6.0/aws_mxnet_mkl-1.6.0-py2.py3-none-manylinux1_x86_64.whl
ARG PYTHON=python3
ARG PYTHON_PIP=python3-pip
ARG PIP=pip3
ARG PYTHON_VERSION=3.6.8

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
    git \
    libopencv-dev \
    openjdk-8-jdk-headless \
    vim \
    wget \
    zlib1g-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
 && tar -xvf Python-$PYTHON_VERSION.tgz \
 && cd Python-$PYTHON_VERSION \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
 && make \
 && make install \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    libreadline-gplv2-dev \
    libncursesw5-dev \
    libssl-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev \
 && make \
 && make install \
 && rm -rf ../Python-$PYTHON_VERSION* \
 && ln -s /usr/local/bin/pip3 /usr/bin/pip && rm Python-$PYTHON_VERSION.tgz && rm -rf /var/lib/apt/lists/*;

RUN ln -s $(which ${PYTHON}) /usr/local/bin/python

RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools

WORKDIR /

COPY mxnet/sagemaker_mxnet_inference.tar.gz /sagemaker_mxnet_inference.tar.gz
COPY mxnet/sagemaker_inference.tar.gz /sagemaker_inference.tar.gz

RUN ${PIP} install --no-cache-dir \
    ${MX_URL} \
    git+https://github.com/dmlc/gluon-nlp.git@v0.9.0 \
    multi-model-server==$MMS_VERSION \
    keras-mxnet==2.2.4.1 \
    numpy==1.17.4 \
    onnx==1.4.1 \
    /sagemaker_mxnet_inference.tar.gz \
    /sagemaker_inference.tar.gz \
 && rm /sagemaker_mxnet_inference.tar.gz /sagemaker_inference.tar.gz

# This is here to make our installed version of OpenCV work.
# https://stackoverflow.com/questions/29274638/opencv-libdc1394-error-failed-to-initialize-libdc1394
# TODO: Should we be installing OpenCV in our image like this? Is there another way we can fix this?
RUN ln -s /dev/null /dev/raw1394

##################################
# download models to model_store
##################################
WORKDIR /opt/ml/models/resnet_152/model
RUN wget -O model-0000.params https://data.mxnet.io/models/imagenet/resnet/152-layers/resnet-152-0000.params \
 && wget -O model-symbol.json https://data.mxnet.io/models/imagenet/resnet/152-layers/resnet-152-symbol.json \
 && wget -O synset.txt https://data.mxnet.io/models/imagenet/synset.txt \
 && echo '[{"shape": [1, 3, 224, 224], "name": "data"}]' > model-shapes.json \
 && cd /

WORKDIR /opt/ml/models/resnet_18/model
RUN wget -O model-0000.params https://data.mxnet.io/models/imagenet/resnet/18-layers/resnet-18-0000.params \
 && wget -O model-symbol.json https://data.mxnet.io/models/imagenet/resnet/18-layers/resnet-18-symbol.json \
 && wget -O synset.txt https://data.mxnet.io/models/imagenet/synset.txt \
 && echo '[{"shape": [1, 3, 224, 224], "name": "data"}]' > model-shapes.json \
 && cd /

WORKDIR /

RUN useradd -m model-server \
 && mkdir -p /home/model-server/tmp \
 && chown -R model-server /home/model-server

COPY mxnet/mms_entrypoint.py /usr/local/bin/dockerd_entrypoint.py
COPY mxnet/config.properties /home/model-server

# TEST: model_dir -> /opt/ml/models/<model_name>/inference.py
COPY mxnet/inference.py /opt/ml/models/resnet_18/code/inference.py
COPY mxnet/inference.py /opt/ml/models/resnet_152/code/inference.py

RUN chmod +x /usr/local/bin/dockerd_entrypoint.py

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/aws-mxnet-1.6.0/license.txt -o /license.txt

EXPOSE 8080 8081
ENTRYPOINT ["python", "/usr/local/bin/dockerd_entrypoint.py"]
CMD ["multi-model-server", "--start", "--mms-config", "/home/model-server/config.properties"]
