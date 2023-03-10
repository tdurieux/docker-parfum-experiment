FROM ubuntu:16.04

LABEL maintainer="Amazon AI"

RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    build-essential \
    openssh-client \
    openssh-server \
    ca-certificates \
    curl \
    git \
    wget \
    vim \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Open MPI
RUN mkdir /tmp/openmpi && \
    cd /tmp/openmpi && \
    curl -fSsL -O https://www.open-mpi.org/software/ompi/v3.1/downloads/openmpi-3.1.2.tar.gz && \
    tar zxf openmpi-3.1.2.tar.gz && \
    cd openmpi-3.1.2 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-orterun-prefix-by-default && \
    make -j $(nproc) all && \
    make install && \
    ldconfig && \
    rm -rf /tmp/openmpi && rm openmpi-3.1.2.tar.gz

# Create a wrapper for OpenMPI to allow running as root by default
RUN mv /usr/local/bin/mpirun /usr/local/bin/mpirun.real && \
    echo '#!/bin/bash' > /usr/local/bin/mpirun && \
    echo 'mpirun.real --allow-run-as-root "$@"' >> /usr/local/bin/mpirun && \
    chmod a+x /usr/local/bin/mpirun

RUN echo "hwloc_base_binding_policy = none" >> /usr/local/etc/openmpi-mca-params.conf && \
    echo "rmaps_base_mapping_policy = slot" >> /usr/local/etc/openmpi-mca-params.conf

ENV LD_LIBRARY_PATH=/usr/local/openmpi/lib:$LD_LIBRARY_PATH

ENV PATH /usr/local/openmpi/bin/:$PATH

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Create SSH key.
RUN mkdir -p /root/.ssh/ && \
    mkdir -p /var/run/sshd && \
    ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa && \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
    printf "Host *\n  StrictHostKeyChecking no\n" >> /root/.ssh/config

# Set environment variables for MKL
# For more about MKL with TensorFlow see:
# https://www.tensorflow.org/performance/performance_guide#tensorflow_with_intel%C2%AE_mkl_dnn
ENV KMP_AFFINITY=granularity=fine,compact,1,0 KMP_BLOCKTIME=1 KMP_SETTINGS=0

WORKDIR /

ARG PYTHON=python3
ARG PYTHON_PIP=python3-pip
ARG PIP=pip3
ARG PYTHON_VERSION=3.6.6

RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz && \
    tar -xvf Python-$PYTHON_VERSION.tgz && cd Python-$PYTHON_VERSION && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && \
    apt-get update && apt-get install -y --no-install-recommends libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev && \
    make && make install && rm -rf ../Python-$PYTHON_VERSION* && \
    ln -s /usr/local/bin/pip3 /usr/bin/pip && rm Python-$PYTHON_VERSION.tgz && rm -rf /var/lib/apt/lists/*;

ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 PYTHONIOENCODING=UTF-8 LANG=C.UTF-8 LC_ALL=C.UTF-8

ARG framework_support_installable=sagemaker_tensorflow_container-2.0.0.tar.gz
COPY $framework_support_installable .
ARG TF_URL="https://tensorflow-aws.s3-us-west-2.amazonaws.com/1.13/AmazonLinux/cpu/latest-patch-latest-patch/tensorflow-1.13.1-cp36-cp36m-linux_x86_64.whl"

RUN ${PIP} --no-cache-dir install --upgrade pip setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python

RUN ${PIP} install --no-cache-dir -U \
           numpy==1.16.2 \
           scipy==1.2.1 \
           scikit-learn==0.20.3 \
           pandas==0.24.2 \
           Pillow==5.4.1 \
           h5py==2.9.0 \
           keras_applications==1.0.7 \
           keras_preprocessing==1.0.9 \
           keras==2.2.4 \
           requests==2.21.0 \
           awscli==1.16.130 \
           mpi4py==3.0.1 \
           "sagemaker-tensorflow>=1.13,<1.14" && \
    # Let's install TensorFlow separately in the end to avoid
    # the library version to be overwritten
    ${PIP} install --force-reinstall --no-cache-dir -U \
           ${TF_URL} \
           horovod==0.16.4 && \
    ${PIP} install --no-cache-dir -U $framework_support_installable && \
           rm -f $framework_support_installable && \
    ${PIP} uninstall -y --no-cache-dir \
           markdown \
           tensorboard

ENV SAGEMAKER_TRAINING_MODULE sagemaker_tensorflow_container.training:main

CMD ["bin/bash"]
