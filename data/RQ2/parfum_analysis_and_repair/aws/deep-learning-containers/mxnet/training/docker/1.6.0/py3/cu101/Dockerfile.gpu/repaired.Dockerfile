# Note: We need to install NCCL, cuDNN, and CUDA libraries since we are using base container.
FROM nvidia/cuda:10.1-base-ubuntu16.04

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="3"

ARG PYTHON=python3
ARG PIP=pip3
ARG PYTHON_VERSION=3.6.13
ARG MX_URL=https://aws-mxnet-pypi.s3-us-west-2.amazonaws.com/1.6.0/aws_mxnet_cu101mkl-1.6.0-py2.py3-none-manylinux1_x86_64.whl

# The smdebug pipeline relies for following format to perform string replace and trigger DLC pipeline for validating
# the nightly builds. Therefore, while updating the smdebug version, please ensure that the format is not disturbed.
ARG SMDEBUG_VERSION=0.9.4
ARG OPENSSL_VERSION=1.1.1k

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib" \
    PYTHONIOENCODING=UTF-8 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    SAGEMAKER_TRAINING_MODULE=sagemaker_mxnet_container.training:main \
    DGLBACKEND=mxnet \
    CUDNN_VERSION=7.6.0.64-1+cuda10.1 \
    NCCL_VERSION=2.4.8-1+cuda10.1

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    software-properties-common \
    build-essential \
    ca-certificates \
    libcudnn7=${CUDNN_VERSION} \
    cuda-command-line-tools-10-1 \
    cuda-cufft-10-1 \
    cuda-curand-10-1 \
    cuda-cusolver-10-1 \
    cuda-cusparse-10-1 \
    curl \
    emacs \
    git \
    libatlas-base-dev \
    libcurl4-openssl-dev \
    libnccl2=${NCCL_VERSION} \
    libgomp1 \
    libnccl-dev=${NCCL_VERSION} \
    libopencv-dev \
    openssh-client \
    openssh-server \
    vim \
    wget \
    unzip \
    zlib1g-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install cuda-dev libraries as a dependency for Horovod with MXNet backend
ENV CUDA_LIB_URL=https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64
RUN wget ${CUDA_LIB_URL}/libcublas10_10.2.1.243-1_amd64.deb \
    ${CUDA_LIB_URL}/libcublas-dev_10.2.1.243-1_amd64.deb \
    ${CUDA_LIB_URL}/cuda-curand-dev-10-1_10.1.243-1_amd64.deb \
    ${CUDA_LIB_URL}/cuda-cusolver-dev-10-1_10.1.243-1_amd64.deb \
    ${CUDA_LIB_URL}/cuda-nvrtc-10-1_10.1.243-1_amd64.deb \
    ${CUDA_LIB_URL}/cuda-nvrtc-dev-10-1_10.1.243-1_amd64.deb \
 && dpkg -i libcublas10_10.2.1.243-1_amd64.deb \
    libcublas-dev_10.2.1.243-1_amd64.deb \
    cuda-curand-dev-10-1_10.1.243-1_amd64.deb \
    cuda-cusolver-dev-10-1_10.1.243-1_amd64.deb \
    cuda-nvrtc-10-1_10.1.243-1_amd64.deb \
    cuda-nvrtc-dev-10-1_10.1.243-1_amd64.deb \
 && apt-get install -y -f \
 && rm libcublas10_10.2.1.243-1_amd64.deb \
    libcublas-dev_10.2.1.243-1_amd64.deb \
    cuda-curand-dev-10-1_10.1.243-1_amd64.deb \
    cuda-cusolver-dev-10-1_10.1.243-1_amd64.deb \
    cuda-nvrtc-10-1_10.1.243-1_amd64.deb \
    cuda-nvrtc-dev-10-1_10.1.243-1_amd64.deb

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

# Configure OpenMPI to run good defaults:
#   --bind-to none --map-by slot --mca btl_tcp_if_exclude lo,docker0
RUN echo "hwloc_base_binding_policy = none" >> /usr/local/etc/openmpi-mca-params.conf \
 && echo "rmaps_base_mapping_policy = slot" >> /usr/local/etc/openmpi-mca-params.conf

# Set default NCCL parameters
RUN echo NCCL_DEBUG=INFO >> /etc/nccl.conf

ENV LD_LIBRARY_PATH=/usr/local/openmpi/lib:$LD_LIBRARY_PATH
ENV PATH=/usr/local/openmpi/bin/:$PATH
ENV PATH=/usr/local/nvidia/bin:$PATH


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
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && make \
 && make install \
 && rm -rf ../Python-$PYTHON_VERSION* \
 && ln -s /usr/local/bin/pip3 /usr/bin/pip \
 && ln -s $(which ${PYTHON}) /usr/local/bin/python && rm Python-$PYTHON_VERSION.tgz

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
    numpy==1.19.1 \
    onnx==1.6.0 \
    pandas==0.25.1 \
    Pillow \
    requests==2.22.0 \
    scikit-learn==0.20.4 \
    scipy==1.2.2 \
    dgl-cu101==0.4.* \
    gluonnlp==0.10.0 \
    gluoncv==0.6.0 \
    # Putting a cap in versions number to avoid potential issues with a new major version
    "urllib3>=1.25.10,<1.26.0" \
    python-dateutil==2.8.0 \
    tqdm==4.39.0 \
    sagemaker-experiments==0.* \
    # install PyYAML>=5.4,<5.5 to avoid conflict with latest awscli
    "PyYAML>=5.4,<5.5" \
    mpi4py==3.0.2 \
    "sagemaker-mxnet-training<5" \
    ${MX_URL} \
    smdebug==${SMDEBUG_VERSION} \
    "sagemaker>=2,<3" \
    awscli

# Install Horovod, temporarily using CUDA stubs
RUN ldconfig /usr/local/cuda-10.1/targets/x86_64-linux/lib/stubs \
 && HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITHOUT_TENSORFLOW=1 \
    HOROVOD_WITHOUT_PYTORCH=1 HOROVOD_WITH_MXNET=1 pip install --no-cache-dir \
    horovod==0.19.5 \
 && ldconfig

# Allow OpenSSH to talk to containers without asking for confirmation
RUN cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new \
 && echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new \
 && mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config

# OpenSHH config for MPI communication
RUN mkdir -p /var/run/sshd && \
  sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN rm -rf /root/.ssh/ && \
  mkdir -p /root/.ssh/ && \
  ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa && \
  cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys \
  && printf "Host *\n StrictHostKeyChecking no\n" >> /root/.ssh/config

# "channels first" is recommended for keras-mxnet
# https://github.com/awslabs/keras-apache-mxnet/blob/master/docs/mxnet_backend/performance_guide.md#channels-first-image-data-format-for-cnn
RUN mkdir /root/.keras \
 && echo '{"image_data_format": "channels_first"}' > /root/.keras/keras.json

# This is here to make our installed version of OpenCV work.
# https://stackoverflow.com/questions/29274638/opencv-libdc1394-error-failed-to-initialize-libdc1394
# TODO: Should we be installing OpenCV in our image like this? Is there another way we can fix this?
RUN ln -s /dev/null /dev/raw1394

ADD https://raw.githubusercontent.com/aws/deep-learning-containers/master/src/deep_learning_container.py /usr/local/bin/deep_learning_container.py

RUN chmod +x /usr/local/bin/deep_learning_container.py

RUN HOME_DIR=/root \
 && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
 && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
 && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
 && chmod +x /usr/local/bin/testOSSCompliance \
 && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
 && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} ${PYTHON} \
 && rm -rf ${HOME_DIR}/oss_compliance*

RUN curl -f -o /license.txt https://aws-dlc-licenses.s3.amazonaws.com/aws-mxnet-1.6.0/license.txt

CMD ["/bin/bash"]
