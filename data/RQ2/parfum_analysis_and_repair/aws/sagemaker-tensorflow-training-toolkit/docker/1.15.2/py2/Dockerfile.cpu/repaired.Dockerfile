FROM ubuntu:18.04

LABEL maintainer="Amazon AI"

# Prevent docker build get stopped by requesting user interaction
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
# Set environment variables for MKL
# https://www.tensorflow.org/performance/performance_guide#tensorflow_with_intel%C2%AE_mkl_dnn
ENV KMP_AFFINITY=granularity=fine,compact,1,0
ENV KMP_BLOCKTIME=1
ENV KMP_SETTINGS=0
# Python won’t try to write .pyc or .pyo files on the import of source modules
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
# See http://bugs.python.org/issue19846
ENV PYTHONIOENCODING=UTF-8
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
# Specify the location of module that contains the training logic for SageMaker
# https://docs.aws.amazon.com/sagemaker/latest/dg/docker-container-environmental-variables-entrypoint.html
ENV SAGEMAKER_TRAINING_MODULE=sagemaker_tensorflow_container.training:main

# Define framework-related package sources
ARG TF_URL=https://tensorflow-aws.s3-us-west-2.amazonaws.com/1.15.2/AmazonLinux/cpu/final/tensorflow-1.15.2-cp27-cp27mu-manylinux2010_x86_64.whl

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
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

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Create SSH key.
RUN mkdir -p /root/.ssh/ \
 && mkdir -p /var/run/sshd \
 && ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa \
 && cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys \
 && printf "Host *\n  StrictHostKeyChecking no\n" >> /root/.ssh/config

WORKDIR /

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
    python \
    python-pip && rm -rf /var/lib/apt/lists/*;

RUN pip --no-cache-dir install --upgrade \
    pip \
    setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which python) /usr/local/bin/python

RUN pip install --no-cache-dir -U \
    numpy==1.16.5 \
    scipy==1.2.2 \
    scikit-learn==0.20.3 \
    pandas==0.24.2 \
    Pillow==6.2.2 \
    h5py==2.9.0 \
    keras_applications==1.0.8 \
    keras_preprocessing==1.1.0 \
    requests==2.22.0 \
    keras==2.3.1 \
    mpi4py==3.0.2 \
    "cryptography>=2.3" \
    "sagemaker-tensorflow>=1.15,<1.16" \
    "sagemaker-tensorflow-training>=2,<3" \
    # Let's install TensorFlow separately in the end to avoid the library version to be overwritten
 && pip install --force-reinstall --no-cache-dir -U \
    ${TF_URL} \
 && pip install --no-cache-dir -U \
    awscli \
 && pip install --no-cache-dir -U \
    horovod==0.18.2

ADD https://raw.githubusercontent.com/aws/aws-deep-learning-containers-utils/master/deep_learning_container.py /usr/local/bin/deep_learning_container.py

RUN chmod +x /usr/local/bin/deep_learning_container.py

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/tensorflow/license.txt -o /license.txt

CMD ["bin/bash"]
