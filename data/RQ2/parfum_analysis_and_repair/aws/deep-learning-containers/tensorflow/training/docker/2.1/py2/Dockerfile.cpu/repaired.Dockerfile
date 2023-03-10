FROM ubuntu:18.04

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="6"

# prevent stopping by user interaction
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ENV SAGEMAKER_TRAINING_MODULE sagemaker_tensorflow_container.training:main

# Set environment variables for MKL
# For more about MKL with TensorFlow see:
# https://www.tensorflow.org/performance/performance_guide#tensorflow_with_intel%C2%AE_mkl_dnn
ENV KMP_AFFINITY=granularity=fine,compact,1,0
ENV KMP_BLOCKTIME=1
ENV KMP_SETTINGS=0

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONIOENCODING=UTF-8
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

ARG TF_URL=https://tensorflow-aws.s3-us-west-2.amazonaws.com/2.1.1/AmazonLinux/cpu/final/tensorflow-2.1.1-cp27-cp27mu-manylinux2010_x86_64.whl

ARG PYTHON=python
ARG PYTHON_PIP=python-pip
ARG PIP=pip

ARG OPENSSL_VERSION=1.1.1k

RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    build-essential \
    openssh-client \
    openssh-server \
    ca-certificates \
    curl \
    emacs \
    git \
    wget \
    vim \
    zlib1g-dev \
    # Install dependent library for OpenCV
    libgtk2.0-dev \
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
ENV PATH /usr/local/openmpi/bin/:$PATH

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Create SSH key.
RUN mkdir -p /root/.ssh/ \
 && mkdir -p /var/run/sshd \
 && ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa \
 && cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys \
 && printf "Host *\n  StrictHostKeyChecking no\n" >> /root/.ssh/config

WORKDIR /

RUN apt-get update && apt-get install --no-install-recommends -y \
    ${PYTHON} \
    ${PYTHON_PIP} && rm -rf /var/lib/apt/lists/*;

RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python

# install PyYAML==5.1.2 to avoid conflict with latest awscli
# # python-dateutil==2.8.0 to satisfy botocore associated with latest awscli
RUN ${PIP} install --no-cache-dir -U \
    numpy==1.16.6 \
    scipy==1.2.2 \
    scikit-learn==0.20.4 \
    pandas==0.24.2 \
    Pillow==6.2.2 \
    keras_applications==1.0.8 \
    keras_preprocessing==1.1.0 \
    keras==2.3.1 \
    python-dateutil==2.8.1 \
    pyYAML==5.3.1 \
    requests==2.22.0 \
    "awscli<2" \
    mpi4py==3.0.3 \
    opencv-python==4.2.0.32 \
    "cryptography>=2.3" \
    "sagemaker-tensorflow>=2.1,<2.2" \
    "sagemaker-tensorflow-training>=20" \
    # Let's install TensorFlow separately in the end to avoid
    # the library version to be overwritten
 && ${PIP} install --no-cache-dir -U \
    ${TF_URL} \
    h5py==2.10.0 \
    "absl-py>=0.9,<0.11" \
 && ${PIP} install --no-cache-dir -U \
    horovod==0.19.4

ADD https://raw.githubusercontent.com/aws/deep-learning-containers/master/src/deep_learning_container.py /usr/local/bin/deep_learning_container.py

RUN chmod +x /usr/local/bin/deep_learning_container.py

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/tensorflow-2.1/license.txt -o /license.txt

CMD ["/bin/bash"]
