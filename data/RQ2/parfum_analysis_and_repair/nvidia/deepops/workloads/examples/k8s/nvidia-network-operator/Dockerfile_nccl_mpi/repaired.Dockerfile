FROM nvidia/cuda:11.6.0-devel-ubuntu20.04

# TensorFlow version is tightly coupled to CUDA and cuDNN so it should be selected carefully
ENV TENSORFLOW_VERSION=2.7.0
ENV PYTORCH_VERSION=1.10.2+cu113
ARG PYTORCH_LIGHTNING_VERSION=1.5.9
ENV TORCHVISION_VERSION=0.11.3+cu113
ENV CUDNN_VERSION=8.3.2.44-1+cuda11.5
ENV NCCL_VERSION=2.11.4-1+cuda11.6
ENV MXNET_VERSION=1.8.0.post0

ARG python=3.8
ENV PYTHON_VERSION=${python}

ENV TZ=US/Pacific
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set default shell to /bin/bash
SHELL ["/bin/bash", "-cu"]

RUN apt-key del 7fa2af80
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64/7fa2af80.pub

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
        iproute2 \
        iputils-ping \
        net-tools \
        ethtool \
        pciutils \
        libnl-route-3-200 \
        kmod \
        lsof \
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

# pinning pip to 21.0.0 as 22.0.0 cannot fetch pytorch packages from html linl
# https://github.com/pytorch/pytorch/issues/72045
RUN curl -f -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py && \
    pip install --no-cache-dir -U --force pip~=21.0.0

# Install recent CMake.
RUN pip install --no-cache-dir -U cmake~=3.13.0

# Install PyTorch, TensorFlow, Keras and MXNet
RUN pip install --no-cache-dir \
    torch==${PYTORCH_VERSION} \
    torchvision==${TORCHVISION_VERSION} \
    -f https://download.pytorch.org/whl/${PYTORCH_VERSION/*+/}/torch_stable.html
RUN pip install --no-cache-dir pytorch_lightning==${PYTORCH_LIGHTNING_VERSION}

RUN pip install --no-cache-dir future typing packaging
RUN pip install --no-cache-dir \
    tensorflow==${TENSORFLOW_VERSION} \
    keras \
    h5py

RUN pip install --no-cache-dir mxnet-cu112==${MXNET_VERSION}

# Install Open MPI
RUN mkdir /tmp/openmpi && \
    cd /tmp/openmpi && \
    wget https://www.open-mpi.org/software/ompi/v4.1/downloads/openmpi-4.1.3.tar.gz && \
    tar zxf openmpi-4.1.3.tar.gz && \
    cd openmpi-4.1.3 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-orterun-prefix-by-default && \
    make -j $(nproc) all && \
    make install && \
    ldconfig && \
    rm -rf /tmp/openmpi && rm openmpi-4.1.3.tar.gz

## Install Horovod
RUN HOROVOD_GPU_OPERATIONS=NCCL HOROVOD_WITH_TENSORFLOW=1 HOROVOD_WITH_PYTORCH=1 HOROVOD_WITH_MXNET=1 pip install horovod --no-cache-dir -v && \
    horovodrun --check-build

# Install OpenSSH for MPI to communicate between containers
RUN apt-get install -y --no-install-recommends openssh-client openssh-server && \
    mkdir -p /var/run/sshd && rm -rf /var/lib/apt/lists/*;
RUN sed -i 's/[ #]\(.*StrictHostKeyChecking \).*/ \1no/g' /etc/ssh/ssh_config && \
    echo "    UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config && \
    sed -i 's/#\(StrictModes \).*/\1no/g' /etc/ssh/sshd_config

## Install Mellano OFED
ENV MOFED_VERSION 5.5-1.0.3.2
ENV MOFED_DIR MLNX_OFED_LINUX-${MOFED_VERSION}-ubuntu20.04-x86_64
ENV MOFED_SITE_PLACE MLNX_OFED-${MOFED_VERSION}
ENV MOFED_IMAGE MLNX_OFED_LINUX-${MOFED_VERSION}-ubuntu20.04-x86_64.tgz

RUN apt-get update && apt-get install --no-install-recommends -y lsb-core && rm -rf /var/lib/apt/lists/*;
RUN wget https://content.mellanox.com/ofed/${MOFED_SITE_PLACE}/${MOFED_IMAGE} && \
    tar -xzvf ${MOFED_IMAGE} && \
    ${MOFED_DIR}/mlnxofedinstall --user-space-only --without-fw-update -q --force && \
    cd .. && \
    rm -rf ${MOFED_DIR} && \
    rm -rf *.tgz
RUN apt-get install --no-install-recommends dkms -y && rm -rf /var/lib/apt/lists/*;

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

