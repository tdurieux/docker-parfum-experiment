# Note: We need to install NCCL, cuDNN, and CUDA libraries since we are using base container.
FROM nvidia/cuda:10.1-base-ubuntu16.04

LABEL maintainer="Amazon AI"

ARG MX_URL=https://aws-mxnet-pypi.s3-us-west-2.amazonaws.com/1.6.0/aws_mxnet_cu101mkl-1.6.0-py2.py3-none-manylinux1_x86_64.whl

# See http://bugs.python.org/issue19846
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib" \
    PYTHONIOENCODING=UTF-8 \
    SAGEMAKER_TRAINING_MODULE=sagemaker_mxnet_container.training:main \
    CUDNN_VERSION=7.6.0.64-1+cuda10.1 \
    NCCL_VERSION=2.4.8-1+cuda10.1

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    # build-essential needed to pip install user's dependencies (e.g. requirements.txt)
    build-essential \
    ca-certificates \
    libcudnn7=${CUDNN_VERSION} \
    cuda-command-line-tools-10-1 \
    cuda-cufft-10-1 \
    cuda-curand-10-1 \
    cuda-cusolver-10-1 \
    cuda-cusparse-10-1 \
    curl \
    git \
    libnccl2=${NCCL_VERSION} \
    libgomp1 \
    libnccl-dev=${NCCL_VERSION} \
    libopencv-dev \
    python \
    # python-dev needed to pip install mxnet and user's dependencies (e.g. requirements.txt)
    python-dev \
    python-pip \
    openssh-client \
    openssh-server \
    vim \
    wget \
    # zlib1g-dev needed to pip install sagemaker_mxnet_training
    zlib1g-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && ln -s $(which python) /usr/local/bin/python

# Install cuda-dev libraries as a dependency for Horovod with MXNet backend
ENV CUDA_LIB_URL=https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64
RUN wget ${CUDA_LIB_URL}/libcublas10_10.2.1.243-1_amd64.deb \
    ${CUDA_LIB_URL}/libcublas-dev_10.2.1.243-1_amd64.deb \
    ${CUDA_LIB_URL}/cuda-curand-dev-10-1_10.1.243-1_amd64.deb \
    ${CUDA_LIB_URL}/cuda-cusolver-dev-10-1_10.1.243-1_amd64.deb \
    ${CUDA_LIB_URL}/cuda-nvrtc-10-1_10.1.243-1_amd64.deb \
    ${CUDA_LIB_URL}/cuda-nvrtc-dev-10-1_10.1.243-1_amd64.deb \
 && dpkg -i libcublas10_10.2.1.243-1_amd64.deb \
    libcublas-dev_10.2.1.243-1_amd64.deb \
    cuda-curand-dev-10-1_10.1.243-1_amd64.deb \
    cuda-cusolver-dev-10-1_10.1.243-1_amd64.deb \
    cuda-nvrtc-10-1_10.1.243-1_amd64.deb \
    cuda-nvrtc-dev-10-1_10.1.243-1_amd64.deb \
 && apt-get install -y -f \
 && rm libcublas10_10.2.1.243-1_amd64.deb \
    libcublas-dev_10.2.1.243-1_amd64.deb \
    cuda-curand-dev-10-1_10.1.243-1_amd64.deb \
    cuda-cusolver-dev-10-1_10.1.243-1_amd64.deb \
    cuda-nvrtc-10-1_10.1.243-1_amd64.deb \
    cuda-nvrtc-dev-10-1_10.1.243-1_amd64.deb

###########################################################################
# Horovod dependencies
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

# MXNet requires pip 19.3.1 due to being backwards compatible
# with python2
RUN pip --no-cache-dir install --upgrade \
    pip==19.3.1 \
    setuptools

WORKDIR /

# python-dateutil==2.8.0 to satisfy botocore
RUN pip install --no-cache-dir --upgrade \
    h5py==2.10.0 \
    keras-mxnet==2.2.4.2 \
    numpy==1.16.5 \
    # setuptools<45 because support for py2 stops with 45.0.0
    # https://github.com/pypa/setuptools/blob/master/CHANGES.rst#v4500
    "setuptools<45" \
    onnx==1.6.0 \
    pandas==0.24.2 \
    Pillow==6.2.2 \
    requests==2.22.0 \
    scikit-learn==0.20.4 \
    scipy==1.2.2 \
    urllib3==1.25.8 \
    python-dateutil==2.8.0 \
    mpi4py==3.0.2 \
    ${MX_URL} \
    # inotify-simple updated to 1.3.0 and has an issue that prevents the installation
    # of the enum34 package on py2. inotify-simple is used in sagemaker-mxnet-training
    "inotify-simple<1.3" \
    "sagemaker-mxnet-training<4"

# Install Horovod, temporarily using CUDA stubs
RUN ldconfig /usr/local/cuda/targets/x86_64-linux/lib/stubs \
 && HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITHOUT_TENSORFLOW=1 \
    HOROVOD_WITHOUT_PYTORCH=1 HOROVOD_WITH_MXNET=1 pip install --no-cache-dir \
    horovod==0.19.0 \
 && ldconfig

# Allow OpenSSH to talk to containers without asking for confirmation
RUN cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new \
 && echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new \
 && mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config

# "channels first" is recommended for keras-mxnet
# https://github.com/awslabs/keras-apache-mxnet/blob/master/docs/mxnet_backend/performance_guide.md#channels-first-image-data-format-for-cnn
RUN mkdir /root/.keras \
 && echo '{"image_data_format": "channels_first"}' > /root/.keras/keras.json

# This is here to make our installed version of OpenCV work.
# https://stackoverflow.com/questions/29274638/opencv-libdc1394-error-failed-to-initialize-libdc1394
# TODO: Should we be installing OpenCV in our image like this? Is there another way we can fix this?
RUN ln -s /dev/null /dev/raw1394

COPY dockerd-entrypoint.py /usr/local/bin/dockerd-entrypoint.py

RUN chmod +x /usr/local/bin/dockerd-entrypoint.py

RUN curl -f -o /license.txt https://aws-dlc-licenses.s3.amazonaws.com/aws-mxnet-1.6.0/license.txt

ENTRYPOINT ["python", "/usr/local/bin/dockerd-entrypoint.py"]
CMD ["/bin/bash"]
