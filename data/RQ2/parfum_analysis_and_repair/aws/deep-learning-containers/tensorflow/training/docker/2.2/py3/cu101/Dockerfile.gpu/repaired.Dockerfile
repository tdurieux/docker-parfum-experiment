FROM nvidia/cuda:10.1-base-ubuntu18.04

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"

# prevent stopping by user interaction
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ENV SAGEMAKER_TRAINING_MODULE sagemaker_tensorflow_container.training:main

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONIOENCODING=UTF-8
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Set environment variables for MKL
# For more about MKL with TensorFlow see:
# https://www.tensorflow.org/performance/performance_guide#tensorflow_with_intel%C2%AE_mkl_dnn
ENV KMP_AFFINITY=granularity=fine,compact,1,0
ENV KMP_BLOCKTIME=1
ENV KMP_SETTINGS=0

ARG PYTHON=python3.7
ARG PYTHON_PIP=python3-pip
ARG PIP=pip3
ARG PYTHON_VERSION=3.7.10

ARG TF_URL=https://aws-tensorflow-binaries.s3-us-west-2.amazonaws.com/tensorflow/r2.2_aws/20210224-235426/gpu/cu101/py37/tensorflow_gpu-2.2.2-cp37-cp37m-manylinux2010_x86_64.whl

ARG ESTIMATOR_URL=https://aws-tensorflow-binaries.s3-us-west-2.amazonaws.com/estimator/r2.2_aws/20210224-235426/tensorflow_estimator-2.2.0-py2.py3-none-any.whl

# The smdebug pipeline relies for following format to perform string replace and trigger DLC pipeline for validating
# the nightly builds. Therefore, while updating the smdebug version, please ensure that the format is not disturbed.
ARG SMDEBUG_VERSION=0.9.3

RUN apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated \
    ca-certificates \
    cuda-command-line-tools-10-1 \
    cuda-cudart-dev-10-1 \
    cuda-cufft-dev-10-1 \
    cuda-curand-dev-10-1 \
    cuda-cusolver-dev-10-1 \
    cuda-cusparse-dev-10-1 \
    curl \
    emacs \
    libcudnn7=7.6.5.32-1+cuda10.1 \
    # TensorFlow doesn't require libnccl anymore but Open MPI still depends on it
    libnccl2=2.6.4-1+cuda10.1 \
    libgomp1 \
    libnccl-dev=2.6.4-1+cuda10.1 \
    libfreetype6-dev \
    libhdf5-serial-dev \
    liblzma-dev \
    libpng-dev \
    libtemplate-perl \
    libzmq3-dev \
    git \
    wget \
    unzip \
    vim \
    build-essential \
    openssh-client \
    openssh-server \
    libssl1.1 \
    openssl \
    zlib1g-dev \
    # Install dependent library for OpenCV
    libgtk2.0-dev \
    #cuda-cublas-dev not available with 10-1, install libcublas instead
    #it will downgrade the cublas from 10-2 to 10-1
    #adding an extra flag --allow-downgrades for it
    && apt-get update \
    && apt-get install -y --no-install-recommends --allow-unauthenticated --allow-downgrades \
    libcublas10=10.1.0.105-1 \
    libcublas-dev=10.1.0.105-1 \
    # The 'apt-get install' of nvinfer-runtime-trt-repo-ubuntu1804-5.0.2-ga-cuda10.0
    # adds a new list which contains libnvinfer library, so it needs another
    # 'apt-get update' to retrieve that list before it can actually install the
    # library.
    # We don't install libnvinfer-dev since we don't need to build against TensorRT,
    # and libnvinfer4 doesn't contain libnvinfer.a static library.
    # nvinfer-runtime-trt-repo doesn't have a 1804-cuda10.1 version yet. see:
    # https://developer.download.nvidia.cn/compute/machine-learning/repos/ubuntu1804/x86_64/
 && apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated  \
    nvinfer-runtime-trt-repo-ubuntu1804-5.0.2-ga-cuda10.0 \
 && apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated  \
    libnvinfer6=6.0.1-1+cuda10.1 \
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
# Resolve missing libcuda.so issue
RUN cp /usr/local/cuda-10.1/extras/CUPTI/lib64/libcupti* /usr/local/cuda/lib64/
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64/:$LD_LIBRARY_PATH

ENV PATH /usr/local/openmpi/bin/:$PATH
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

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    libbz2-dev \
    libc6-dev \
    libffi-dev \
    libgdbm-dev \
    libncursesw5-dev \
    libreadline-gplv2-dev \
    libsqlite3-dev \
    libssl-dev \
    tk-dev \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean

RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
 && tar -xvf Python-$PYTHON_VERSION.tgz \
 && cd Python-$PYTHON_VERSION \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install \
 && make && make install && rm -rf ../Python-$PYTHON_VERSION* && rm Python-$PYTHON_VERSION.tgz

RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python \
 && ln -s $(which ${PIP}) /usr/bin/pip

# # python-dateutil==2.8.0 to satisfy botocore associated with latest awscli
RUN ${PIP} install --no-cache-dir -U \
    numpy==1.19.1 \
    scipy==1.4.1 \
    scikit-learn==0.23 \
    pandas==1.0.3 \
    Pillow==7.1.2 \
    python-dateutil==2.8.1 \
    # install PyYAML>=5.4,<5.5 to avoid conflict with latest awscli
    "pyYAML>=5.4,<5.5" \
    requests==2.23.0 \
    "awscli<2" \
    mpi4py==3.0.3 \
    opencv-python==4.2.0.32 \
    "sagemaker>=2,<3" \
    sagemaker-experiments==0.* \
    "sagemaker-tensorflow>=2.2,<2.3" \
    "sagemaker-tensorflow-training>=20" \
    # Let's install TensorFlow separately in the end to avoid
    # the library version to be overwritten
 && ${PIP} install --no-cache-dir -U \
    ${TF_URL} \
    ${ESTIMATOR_URL} \
    h5py==2.10.0 \
    werkzeug==1.0.1 \
    smdebug==${SMDEBUG_VERSION}

# Install Horovod, temporarily using CUDA stubs
RUN ldconfig /usr/local/cuda-10.1/targets/x86_64-linux/lib/stubs \
 && HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_TENSORFLOW=1 ${PIP} install --no-cache-dir horovod==0.19.5 \
 && ldconfig

# Allow OpenSSH to talk to containers without asking for confirmation
RUN cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new \
 && echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new \
 && mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config

ADD https://raw.githubusercontent.com/aws/deep-learning-containers/master/src/deep_learning_container.py /usr/local/bin/deep_learning_container.py

RUN chmod +x /usr/local/bin/deep_learning_container.py

RUN HOME_DIR=/root \
 && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
 && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
 && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
 && chmod +x /usr/local/bin/testOSSCompliance \
 && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
 && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} ${PYTHON} \
 && rm -rf ${HOME_DIR}/oss_compliance*

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/tensorflow-2.2/license.txt -o /license.txt

CMD ["/bin/bash"]
