# Updated from Horovod Dockerfile, updated with latest software and verified on DGX Kubernetes cluster
#
FROM nvidia/cuda:11.2.1-devel-ubuntu20.04

# TensorFlow version is tightly coupled to CUDA and cuDNN so it should be selected carefully
ENV TENSORFLOW_VERSION=2.4.1
ENV PYTORCH_VERSION=1.6.0
ENV TORCHVISION_VERSION=0.7.0
ENV CUDNN_VERSION=8.1.0.77-1+cuda11.2
ENV NCCL_VERSION=2.8.4-1+cuda11.2
ENV MXNET_VERSION=1.6.0.post0

ARG python=3.8
ENV PYTHON_VERSION=${python}

ENV TZ=US/Pacific
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Temporary fix for "libcusolver.so.10 not found" in TF2.4 with cuda > 11.0
ENV CUDA_LIB_PATH=/usr/local/cuda-11.2/targets/x86_64-linux/lib/
RUN ln -s ${CUDA_LIB_PATH}libcusolver.so.11 ${CUDA_LIB_PATH}libcusolver.so.10

# Set default shell to /bin/bash
SHELL ["/bin/bash", "-cu"]

RUN apt-get update && apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
        build-essential \
        cmake \
        g++-7 \
        git \
        curl \
        vim \
        wget \
	apt-utils \
        ca-certificates \
	\
        iproute2 \
        iputils-ping \
        net-tools \
        ethtool \
        pciutils \
        libnl-route-3-200 \
        kmod \
        lsof \
	\
        libcudnn8=${CUDNN_VERSION} \
        libnccl2=${NCCL_VERSION} \
        libnccl-dev=${NCCL_VERSION} \
        libjpeg-dev \
        libpng-dev \
        python${PYTHON_VERSION} \
        python${PYTHON_VERSION}-dev \
        python${PYTHON_VERSION}-distutils \
        librdmacm1 \
        libibverbs1 \
        ibverbs-providers && rm -rf /var/lib/apt/lists/*;

RUN ln -s /usr/bin/python${PYTHON_VERSION} /usr/bin/python
RUN rm /usr/bin/python3 && ln -s python3.8 /usr/bin/python3
RUN curl -f -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

# Install TensorFlow, Keras, PyTorch and MXNet
RUN pip install --no-cache-dir future typing packaging
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir tensorflow==${TENSORFLOW_VERSION} keras h5py

RUN PYTAGS=$(python -c "from packaging import tags; tag = list(tags.sys_tags())[0]; print(f'{tag.interpreter}-{tag.abi}')") && \
    pip install --no-cache-dir https://download.pytorch.org/whl/cu101/torch-${PYTORCH_VERSION}%2Bcu101-${PYTAGS}-linux_x86_64.whl \
        https://download.pytorch.org/whl/cu101/torchvision-${TORCHVISION_VERSION}%2Bcu101-${PYTAGS}-linux_x86_64.whl
RUN pip install --no-cache-dir mxnet-cu101==${MXNET_VERSION}

# Install Open MPI
RUN mkdir /tmp/openmpi && \
    cd /tmp/openmpi && \
    wget https://www.open-mpi.org/software/ompi/v4.1/downloads/openmpi-4.1.0.tar.gz && \
    tar zxf openmpi-4.1.0.tar.gz && \
    cd openmpi-4.1.0 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-orterun-prefix-by-default && \
    make -j $(nproc) all && \
    make install && \
    ldconfig && \
    rm -rf /tmp/openmpi && rm openmpi-4.1.0.tar.gz

# Install Horovod
RUN HOROVOD_GPU_OPERATIONS=NCCL pip --no-cache-dir install horovod

## Install Mellano OFED
ENV MOFED_DIR MLNX_OFED_LINUX-5.2-2.2.0.0-ubuntu20.04-x86_64
ENV MOFED_SITE_PLACE MLNX_OFED-5.2-2.2.0.0
ENV MOFED_IMAGE MLNX_OFED_LINUX-5.2-2.2.0.0-ubuntu20.04-x86_64.tgz

RUN apt-get update && apt-get install --no-install-recommends -y lsb-core && rm -rf /var/lib/apt/lists/*;
RUN wget https://content.mellanox.com/ofed/${MOFED_SITE_PLACE}/${MOFED_IMAGE} && \
    tar -xzvf ${MOFED_IMAGE} && \
    ${MOFED_DIR}/mlnxofedinstall --user-space-only --without-fw-update -q --force && \
    cd .. && \
    rm -rf ${MOFED_DIR} && \
    rm -rf *.tgz
RUN apt-get install --no-install-recommends dkms -y && rm -rf /var/lib/apt/lists/*;

# Install OpenSSH for MPI to communicate between containers
RUN apt-get install -y --no-install-recommends openssh-client openssh-server && \
    mkdir -p /var/run/sshd && rm -rf /var/lib/apt/lists/*;

RUN cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new && \
    mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config

# Download examples
RUN apt-get install -y --no-install-recommends subversion && \
    svn checkout https://github.com/horovod/horovod/trunk/examples && \
    rm -rf /examples/.svn && rm -rf /var/lib/apt/lists/*;

# Install NCCL-Test step ------------------------------------------------------
WORKDIR /nccl_tests
RUN wget -q -O - https://github.com/NVIDIA/nccl-tests/archive/master.tar.gz | tar --strip-components=1 -xzf - \
    && make MPI=1

# Tensorflow TF examples
WORKDIR "/examples"
RUN git clone https://github.com/tensorflow/benchmarks.git && \
    cd benchmarks/
WORKDIR "/examples/benchmarks"

ENV LD_LIBRARY_PATH /usr/local/lib:/usr/lib:/usr/local/cuda/lib64:$LD_LIBRARY_PATH
CMD ["/bin/bash"]
