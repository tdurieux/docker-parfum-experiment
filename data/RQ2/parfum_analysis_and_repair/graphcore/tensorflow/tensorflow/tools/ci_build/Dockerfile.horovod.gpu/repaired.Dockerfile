FROM nvidia/cuda:11.0-cudnn8-devel-ubuntu18.04

# Install GCC, Python3.7 and other dependencies.
RUN apt-get update && \
    apt-get install -y --no-install-recommends --assume-yes \
        build-essential \
        git \
        wget \
        cmake \
        curl \
        vim \
        ca-certificates \
        libjpeg-dev \
        libpng-dev \
        librdmacm1 \
        libibverbs1 \
        ibverbs-providers \
        python3.7 \
        python3.7-dev \
        python3-pip \
        python3.7-distutils && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /usr/bin/python && \
    rm -f /usr/bin/python3 && \
    ln -s /usr/bin/python3.7 /usr/bin/python && \
    ln -s /usr/bin/python3.7 /usr/bin/python3 && \
    gcc --version && \
    g++ --version

# Install tf-nightly and verify version.
RUN python3.7 -m pip install --upgrade pip && \
    pip3.7 install --no-cache --no-cache-dir tf-nightly && \
    python3.7 -c "import tensorflow as tf; print(tf.__version__)"

WORKDIR /tmp/openmpi_source

# Download and install open-mpi.
RUN wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.4.tar.gz && \
    tar xvf openmpi-4.0.4.tar.gz && \
    cd openmpi-4.0.4 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-orterun-prefix-by-default && \
    make -j $(nproc) all && \
    make install && rm openmpi-4.0.4.tar.gz

# Set the path for OpenMPI binaries, libs and headers to be discoverable
ENV LD_LIBRARY_PATH=/usr/local/lib/openmpi
RUN ldconfig

ENV HOROVOD_GPU_OPERATIONS=NCCL
ENV HOROVOD_WITH_TENSORFLOW=1
ENV HOROVOD_WITHOUT_PYTORCH=1
ENV HOROVOD_WITHOUT_MXNET=1

RUN pip3.7 install --no-cache --no-cache-dir \
        git+https://github.com/horovod/horovod.git

WORKDIR /workspace

RUN git clone \
        https://github.com/DEKHTIARJonathan/TF_HVD_Stability_Test.git \
        /workspace && \
    pip3.7 install --no-cache --no-cache-dir -r requirements.txt
