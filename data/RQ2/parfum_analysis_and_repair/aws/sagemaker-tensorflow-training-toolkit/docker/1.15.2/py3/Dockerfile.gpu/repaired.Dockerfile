# Nvidia does not publish a TensorRT Runtime library for Ubuntu 18.04 with Cuda 10.1 support, so we stick with cuda 10.0.
# https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/
FROM nvidia/cuda:10.0-base-ubuntu18.04

LABEL maintainer="Amazon AI"

# Prevent docker build get stopped by requesting user interaction
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
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
ARG TF_URL=https://tensorflow-aws.s3-us-west-2.amazonaws.com/1.15.2/AmazonLinux/gpu/final/tensorflow_gpu-1.15.2-cp36-cp36m-manylinux2010_x86_64.whl

RUN apt-get update \
 && apt-get install -y --no-install-recommends --allow-unauthenticated \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-dev \
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
    libpng-dev \
    libzmq3-dev \
    git \
    wget \
    vim \
    build-essential \
    openssh-client \
    openssh-server \
    zlib1g-dev \
    # The 'apt-get install' of nvinfer-runtime-trt-repo-ubuntu1804-5.0.2-ga-cuda10.0
    # adds a new list which contains libnvinfer library, so it needs another
    # 'apt-get update' to retrieve that list before it can actually install the
    # library.
    # We don't install libnvinfer-dev since we don't need to build against TensorRT,
    # and libnvinfer4 doesn't contain libnvinfer.a static library.
 && apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated  \
    nvinfer-runtime-trt-repo-ubuntu1804-5.0.2-ga-cuda10.0 \
 && apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated  \
    libnvinfer5=5.0.2-1+cuda10.0 \
 && rm /usr/lib/x86_64-linux-gnu/libnvinfer_plugin* \
 && rm /usr/lib/x86_64-linux-gnu/libnvcaffe_parser* \
 && rm /usr/lib/x86_64-linux-gnu/libnvparsers* \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /var/run/sshd

###########################################################################
# Horovod & its dependencies
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

# SSH login fix. Otherwise user is kicked off after login
RUN mkdir -p /var/run/sshd \
 && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Create SSH key.
RUN mkdir -p /root/.ssh/ \
 && ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa \
 && cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys \
 && printf "Host *\n  StrictHostKeyChecking no\n" >> /root/.ssh/config

WORKDIR /

RUN pip3 --no-cache-dir install --upgrade \
    pip \
    setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which python3) /usr/local/bin/python \
 && ln -s $(which pip3) /usr/bin/pip

RUN pip install --no-cache-dir -U \
    numpy==1.17.4 \
    scipy==1.2.2 \
    scikit-learn==0.20.3 \
    pandas==0.24.2 \
    Pillow==7.0.0 \
    h5py==2.9.0 \
    keras_applications==1.0.8 \
    keras_preprocessing==1.1.0 \
    requests==2.22.0 \
    keras==2.3.1 \
    smdebug==0.7.2 \
    sagemaker==1.50.17 \
    sagemaker-experiments==0.1.7 \
    mpi4py==3.0.2 \
    "cryptography>=2.3" \
    "sagemaker-tensorflow>=1.15,<1.16" \
    "sagemaker-tensorflow-training>=2,<3" \
    # Let's install TensorFlow separately in the end to avoid
    # the library version to be overwritten
 && pip install --force-reinstall --no-cache-dir -U \
    ${TF_URL} \
 && pip install --no-cache-dir -U \
    awscli

# Install Horovod, temporarily using CUDA stubs
RUN ldconfig /usr/local/cuda-10.0/targets/x86_64-linux/lib/stubs \
 && HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_TENSORFLOW=1 pip install --no-cache-dir \
    horovod==0.18.2 \
 && ldconfig

# Allow OpenSSH to talk to containers without asking for confirmation
RUN cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new \
 && echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new \
 && mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config

ADD https://raw.githubusercontent.com/aws/aws-deep-learning-containers-utils/master/deep_learning_container.py /usr/local/bin/deep_learning_container.py

RUN chmod +x /usr/local/bin/deep_learning_container.py

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/tensorflow/license.txt -o /license.txt

CMD ["bin/bash"]
