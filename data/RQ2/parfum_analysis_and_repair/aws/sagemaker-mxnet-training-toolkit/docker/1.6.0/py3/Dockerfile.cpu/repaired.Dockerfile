FROM ubuntu:16.04

LABEL maintainer="Amazon AI"

ARG PYTHON=python3
ARG PIP=pip3
ARG PYTHON_VERSION=3.6.8
ARG MX_URL=https://aws-mxnet-pypi.s3-us-west-2.amazonaws.com/1.6.0/aws_mxnet_mkl-1.6.0-py2.py3-none-manylinux1_x86_64.whl

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib" \
    PYTHONIOENCODING=UTF-8 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    SAGEMAKER_TRAINING_MODULE=sagemaker_mxnet_container.training:main \
    DGLBACKEND=mxnet

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    software-properties-common \
    build-essential \
    ca-certificates \
    curl \
    git \
    libopencv-dev \
    openssh-client \
    openssh-server \
    vim \
    wget \
    zlib1g-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

###########################################################################
# Horovod dependencies
###########################################################################

# Install Open MPI
RUN mkdir /tmp/openmpi \
 && cd /tmp/openmpi \
 && curl -fSsL -O https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.1.tar.gz \
 && tar zxf openmpi-4.0.1.tar.gz \
 && cd openmpi-4.0.1 \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-orterun-prefix-by-default \
 && make -j $(nproc) all \
 && make install \
 && ldconfig \
 && rm -rf /tmp/openmpi && rm openmpi-4.0.1.tar.gz

# Create a wrapper for OpenMPI to allow running as root by default
RUN mv /usr/local/bin/mpirun /usr/local/bin/mpirun.real \
 && echo '#!/bin/bash' > /usr/local/bin/mpirun \
 && echo 'mpirun.real --allow-run-as-root "$@"' >> /usr/local/bin/mpirun \
 && chmod a+x /usr/local/bin/mpirun

RUN echo "hwloc_base_binding_policy = none" >> /usr/local/etc/openmpi-mca-params.conf \
 && echo "rmaps_base_mapping_policy = slot" >> /usr/local/etc/openmpi-mca-params.conf

ENV LD_LIBRARY_PATH=/usr/local/openmpi/lib:$LD_LIBRARY_PATH
ENV PATH=/usr/local/openmpi/bin/:$PATH

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
    libgdbm-dev \
    libc6-dev \
    libbz2-dev \
    tk-dev \
 && make \
 && make install \
 && rm -rf ../Python-$PYTHON_VERSION* \
 && ln -s /usr/local/bin/pip3 /usr/bin/pip \
 && ln -s $(which ${PYTHON}) /usr/local/bin/python \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* && rm Python-$PYTHON_VERSION.tgz


# MXNet requires pip 19.3.1 due to being backwards compatible
# with python2
RUN ${PIP} --no-cache-dir install --upgrade \
    pip==19.3.1 \
    setuptools

WORKDIR /

# python-dateutil==2.8.0 to satisfy botocore associated with latest awscli
RUN ${PIP} install --no-cache --upgrade \
    keras-mxnet==2.2.4.2 \
    h5py==2.10.0 \
    onnx==1.6.0 \
    numpy==1.17.2 \
    pandas==0.25.1 \
    Pillow==7.1.0 \
    requests==2.22.0 \
    scikit-learn==0.20.4 \
    dgl==0.4.1 \
    scipy==1.2.2 \
    gluonnlp==0.9.1 \
    gluoncv==0.6.0 \
    urllib3==1.25.8 \
    python-dateutil==2.8.0 \
    tqdm==4.39.0 \
    smdebug==0.7.2 \
    sagemaker-experiments==0.1.7 \
    PyYAML==5.3.1 \
    mpi4py==3.0.2 \
    "sagemaker-mxnet-training<4" \
    ${MX_URL} \
    sagemaker==1.50.17 \
    awscli

# Install Horovod
RUN ${PIP} install --no-cache-dir horovod==0.19.0

# Allow OpenSSH to talk to containers without asking for confirmation
RUN cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new \
 && echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new \
 && mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config

# "channels first" is recommended for keras-mxnet
# https://github.com/awslabs/keras-apache-mxnet/blob/master/docs/mxnet_backend/performance_guide.md#channels-first-image-data-format-for-cnn
RUN mkdir /root/.keras \
 && echo '{"image_data_format": "channels_first"}' > /root/.keras/keras.json

# This is here to make our installed version of OpenCV work.
# https://stackoverflow.com/questions/29274638/opencv-libdc1394-error-failed-to-initialize-libdc1394
# TODO: Should we be installing OpenCV in our image like this? Is there another way we can fix this?
RUN ln -s /dev/null /dev/raw1394

COPY dockerd-entrypoint.py /usr/local/bin/dockerd-entrypoint.py

RUN chmod +x /usr/local/bin/dockerd-entrypoint.py

RUN curl -f -o /license.txt https://aws-dlc-licenses.s3.amazonaws.com/aws-mxnet-1.6.0/license.txt

ENTRYPOINT ["python", "/usr/local/bin/dockerd-entrypoint.py"]
CMD ["/bin/bash"]
