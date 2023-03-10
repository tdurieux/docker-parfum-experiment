FROM nvidia/cuda:10.0-devel-ubuntu16.04

# Define the software versions
ENV HOROVOD_VERSION=0.16.1 \
    TENSORFLOW_VERSION=1.13.1 \
    CUDNN_VERSION=7.5.0.56-1+cuda10.0 \
    NCCL_VERSION=2.4.2-1+cuda10.0

# Python version
ARG python=3.5
ENV PYTHON_VERSION=${python}

# Install the necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    cmake git curl vim wget ca-certificates \
    libibverbs-dev \
    libcudnn7=${CUDNN_VERSION} \
    libnccl2=${NCCL_VERSION} \
    libnccl-dev=${NCCL_VERSION} \
    libjpeg-dev \
    libpng-dev \
    python${PYTHON_VERSION} python${PYTHON_VERSION}-dev && rm -rf /var/lib/apt/lists/*;

# Create symbolic link in order to make the installed python default
RUN ln -s /usr/bin/python${PYTHON_VERSION} /usr/bin/python

# Download pip bootstrap script and install pip
RUN curl -f -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
r   m get-pip.py

# Install Tensorflow, Keras and h5py
RUN pip install --no-cache-dir tensorflow-gpu==${TENSORFLOW_VERSION} keras h5py

# Install MPICH 3.1.4
RUN cd /tmp \
    && wget -q https://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz \
    && tar xf mpich-3.1.4.tar.gz \
    && cd mpich-3.1.4 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-fortran --enable-fast=all,O3 --prefix=/usr \
    && make -j$(nproc) \
    && make install \
    && ldconfig \
    && cd .. \
    && rm -rf mpich-3.1.4 mpich-3.1.4.tar.gz \
    && cd /

# Install Horovod
RUN ldconfig /usr/local/cuda-10.0/targets/x86_64-linux/lib/stubs && \
    HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_TENSORFLOW=1 pip install --no-cache-dir horovod==${HOROVOD_VERSION} && \
l   dconfig

# NCCL configuration
RUN echo NCCL_DEBUG=INFO >> /etc/nccl.conf && \
    echo NCCL_IB_HCA=ipogif0 >> /etc/nccl.conf && \
    echo NCCL_IB_CUDA_SUPPORT=1 >> /etc/nccl.conf
