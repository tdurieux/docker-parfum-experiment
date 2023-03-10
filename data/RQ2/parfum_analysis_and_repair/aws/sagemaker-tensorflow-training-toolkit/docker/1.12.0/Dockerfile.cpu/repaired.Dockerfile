FROM ubuntu:16.04

LABEL maintainer="Amazon AI"

RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    build-essential \
    openssh-client \
    openssh-server \
    ca-certificates \
    curl \
    && add-apt-repository ppa:deadsnakes/ppa -y \
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

ARG py_version

RUN if [ $py_version -eq 3 ]; then PYTHON_VERSION=python3.6; else PYTHON_VERSION=python2.7; fi && \
        apt-get update && apt-get install -y --no-install-recommends $PYTHON_VERSION-dev --allow-unauthenticated  && \
        ln -s -f /usr/bin/$PYTHON_VERSION /usr/bin/python && \
    rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 PYTHONIOENCODING=UTF-8 LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN curl -fSsL -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py --disable-pip-version-check --no-cache-dir "pip==18.1" && \
    rm get-pip.py

ARG framework_installable
ARG framework_support_installable=sagemaker_tensorflow_container-2.0.0.tar.gz

COPY $framework_installable tensorflow-1.12.0-py2.py3-none-any.whl
COPY $framework_support_installable .

RUN pip install --no-cache-dir -U \
        keras==2.2.4 \
        mpi4py==3.0.1 \
        "sagemaker-tensorflow>=1.12,<1.13" && \
    # Let's install TensorFlow separately in the end to avoid
    # the library version to be overwritten
    pip install --force-reinstall --no-cache-dir -U \
        tensorflow-1.12.0-py2.py3-none-any.whl \
        horovod && \
    pip install --no-cache-dir -U $framework_support_installable && \
    rm -f tensorflow-1.12.0-py2.py3-none-any.whl && \
    rm -f $framework_support_installable && \
    pip uninstall -y --no-cache-dir \
        markdown \
        tensorboard

ENV SAGEMAKER_TRAINING_MODULE sagemaker_tensorflow_container.training:main
