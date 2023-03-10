FROM nvidia/cuda:10.0-base-ubuntu16.04

LABEL maintainer="Amazon AI"

RUN apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated \
        ca-certificates \
        cuda-command-line-tools-10-0 \
        cuda-cublas-dev-10-0 \
        cuda-cudart-dev-10-0 \
        cuda-cufft-dev-10-0 \
        cuda-curand-dev-10-0 \
        cuda-cusolver-dev-10-0 \
        cuda-cusparse-dev-10-0 \
        curl \
        libcudnn7=7.5.1.10-1+cuda10.0 \
        # TensorFlow doesn't require libnccl anymore but Open MPI still depends on it
        libnccl2=2.4.7-1+cuda10.0 \
        libgomp1 \
        libnccl-dev=2.4.7-1+cuda10.0 \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libpng12-dev \
        libzmq3-dev \
        git \
        wget \
        vim \
        build-essential \
        openssh-client \
        openssh-server \
        zlib1g-dev && \
    # The 'apt-get install' of nvinfer-runtime-trt-repo-ubuntu1604-4.0.1-ga-cuda9.0
    # adds a new list which contains libnvinfer library, so it needs another
    # 'apt-get update' to retrieve that list before it can actually install the
    # library.
    # We don't install libnvinfer-dev since we don't need to build against TensorRT,
    # and libnvinfer4 doesn't contain libnvinfer.a static library.
    apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated  \
        nvinfer-runtime-trt-repo-ubuntu1604-5.0.2-ga-cuda10.0 && \
    apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated  \
        libnvinfer5=5.0.2-1+cuda10.0 && \
    rm /usr/lib/x86_64-linux-gnu/libnvinfer_plugin* && \
    rm /usr/lib/x86_64-linux-gnu/libnvcaffe_parser* && \
    rm /usr/lib/x86_64-linux-gnu/libnvparsers* && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd

###########################################################################
# Horovod & its dependencies
###########################################################################

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

# Create a wrapper for OpenMPI to allow running as root by default
RUN mv /usr/local/bin/mpirun /usr/local/bin/mpirun.real && \
    echo '#!/bin/bash' > /usr/local/bin/mpirun && \
    echo 'mpirun.real --allow-run-as-root "$@"' >> /usr/local/bin/mpirun && \
    chmod a+x /usr/local/bin/mpirun

# Configure OpenMPI to run good defaults:
#   --bind-to none --map-by slot --mca btl_tcp_if_exclude lo,docker0
RUN echo "hwloc_base_binding_policy = none" >> /usr/local/etc/openmpi-mca-params.conf && \
    echo "rmaps_base_mapping_policy = slot" >> /usr/local/etc/openmpi-mca-params.conf

# Set default NCCL parameters
RUN echo NCCL_DEBUG=INFO >> /etc/nccl.conf

ENV LD_LIBRARY_PATH=/usr/local/openmpi/lib:$LD_LIBRARY_PATH
ENV PATH /usr/local/openmpi/bin/:$PATH
ENV PATH=/usr/local/nvidia/bin:$PATH

# SSH login fix. Otherwise user is kicked off after login
RUN mkdir -p /var/run/sshd && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Create SSH key.
RUN mkdir -p /root/.ssh/ && \
  ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa && \
  cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
  printf "Host *\n  StrictHostKeyChecking no\n" >> /root/.ssh/config

###########################################################################
# Python won???t try to write .pyc or .pyo files on the import of source modules
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 PYTHONIOENCODING=UTF-8 LANG=C.UTF-8 LC_ALL=C.UTF-8

WORKDIR /

ARG TF_URL="https://tensorflow-aws.s3-us-west-2.amazonaws.com/1.13/AmazonLinux/gpu/latest-patch-latest-patch/tensorflow-1.13.1-cp36-cp36m-linux_x86_64.whl"

RUN ${PIP} --no-cache-dir install --upgrade pip setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python

ARG framework_support_installable=sagemaker_tensorflow_container-2.0.0.tar.gz
COPY $framework_support_installable .

RUN ${PIP} install --no-cache-dir -U \
    numpy==1.16.2 \
    scipy==1.2.1 \
    scikit-learn==0.20.3 \
    pandas==0.24.2 \
    Pillow==5.4.1 \
    h5py==2.9.0 \
    keras_applications==1.0.7 \
    keras_preprocessing==1.0.9 \
    requests==2.21.0 \
    keras==2.2.4 \
    awscli==1.16.130 \
    mpi4py==3.0.1 \
    "sagemaker-tensorflow>=1.13,<1.14" \
    # Let's install TensorFlow separately in the end to avoid
    # the library version to be overwritten
    && ${PIP} install --force-reinstall --no-cache-dir -U ${TF_URL} \
    && ${PIP} install --no-cache-dir -U $framework_support_installable && \
           rm -f $framework_support_installable \
    && ${PIP} uninstall -y --no-cache-dir \
    markdown \
    tensorboard

# Install Horovod, temporarily using CUDA stubs
RUN ldconfig /usr/local/cuda-10.0/targets/x86_64-linux/lib/stubs && \
    HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_TENSORFLOW=1 ${PIP} install --no-cache-dir horovod==0.16.4 && \
    ldconfig

# Allow OpenSSH to talk to containers without asking for confirmation
RUN cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new && \
    mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config

ENV SAGEMAKER_TRAINING_MODULE sagemaker_tensorflow_container.training:main

CMD ["bin/bash"]
