FROM ubuntu:18.04

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"

# prevent stopping by user interaction
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ENV SAGEMAKER_TRAINING_MODULE sagemaker_tensorflow_container.training:main

# Set environment variables for MKL
# For more about MKL with TensorFlow see:
# https://www.tensorflow.org/performance/performance_guide#tensorflow_with_intel%C2%AE_mkl_dnn

ENV KMP_AFFINITY=granularity=fine,compact,1,0
ENV KMP_BLOCKTIME=1
ENV KMP_SETTINGS=0

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONIOENCODING=UTF-8
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

ARG PYTHON=python3.7
ARG PYTHON_PIP=python3-pip
ARG PIP=pip3
ARG PYTHON_VERSION=3.7.10

ARG TF_URL=https://aws-tensorflow-binaries.s3-us-west-2.amazonaws.com/tensorflow/r2.4_aws/20210813_093733/cpu/py37/tensorflow_cpu-2.4.3-cp37-cp37m-manylinux2010_x86_64.whl

ARG ESTIMATOR_URL=https://aws-tensorflow-binaries.s3-us-west-2.amazonaws.com/estimator/r2.4_aws/20210813_093733/tensorflow_estimator-2.4.0-py2.py3-none-any.whl

# The smdebug pipeline relies for following format to perform string replace and trigger DLC pipeline for validating
# the nightly builds. Therefore, while updating the smdebug version, please ensure that the format is not disturbed.
ARG SMDEBUG_VERSION=1.0.9

RUN apt-get update \
 && apt-get -y upgrade --only-upgrade systemd \
 && apt-get install -y --no-install-recommends \
    build-essential \
    openssh-client \
    openssh-server \
    ca-certificates \
    curl \
    emacs \
    git \
    libtemplate-perl \
    libssl1.1 \
    openssl \
    unzip \
    wget \
    vim \
    zlib1g-dev \
    # Needed for open-cv to resolve error: ImportError: libGL.so.1: cannot open shared object file: No such file or directory
    libgl1-mesa-glx \
    # Install dependent library for OpenCV
    libgtk2.0-dev \
 && rm -rf /var/lib/apt/lists/*

# Install Open MPI
RUN mkdir /tmp/openmpi \
 && cd /tmp/openmpi \
 && curl -fSsL -O https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.4.tar.gz \
 && tar zxf openmpi-4.0.4.tar.gz \
 && cd openmpi-4.0.4 \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-orterun-prefix-by-default \
 && make -j $(nproc) all \
 && make install \
 && ldconfig \
 && rm -rf /tmp/openmpi && rm openmpi-4.0.4.tar.gz

# Create a wrapper for OpenMPI to allow running as root by default
RUN mv /usr/local/bin/mpirun /usr/local/bin/mpirun.real \
 && echo '#!/bin/bash' > /usr/local/bin/mpirun \
 && echo 'mpirun.real --allow-run-as-root "$@"' >> /usr/local/bin/mpirun \
 && chmod a+x /usr/local/bin/mpirun

RUN echo "hwloc_base_binding_policy = none" >> /usr/local/etc/openmpi-mca-params.conf \
 && echo "rmaps_base_mapping_policy = slot" >> /usr/local/etc/openmpi-mca-params.conf

ENV LD_LIBRARY_PATH=/usr/local/openmpi/lib:$LD_LIBRARY_PATH
ENV PATH /usr/local/openmpi/bin/:$PATH

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
 && apt-get install -y --no-install-recommends \
    libbz2-dev \
    libc6-dev \
    libffi-dev \
    libgdbm-dev \
    liblzma-dev \
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
 && rm -rf ../Python-$PYTHON_VERSION* && rm Python-$PYTHON_VERSION.tgz

RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python \
 && ln -s $(which ${PIP}) /usr/bin/pip

RUN apt-get update && apt-get -y --no-install-recommends install cmake protobuf-compiler && rm -rf /var/lib/apt/lists/*;

RUN ${PIP} install --no-cache-dir -U \
    numpy==1.19.1 \
    scipy==1.5.2 \
    scikit-learn==0.23 \
    pandas==1.1 \
    "Pillow>=8.3,<8.4" \
    # python-dateutil==2.8.1 to satisfy botocore associated with latest awscli
    python-dateutil==2.8.1 \
    # install PyYAML>=5.4 to avoid conflict with latest awscli
    "pyYAML>=5.4,<5.5" \
    requests==2.24.0 \
    "awscli<2" \
    mpi4py==3.0.3 \
    "sagemaker>=2,<3" \
    sagemaker-experiments==0.* \
    "sagemaker-tensorflow>=2.4,<2.5" \
    "sagemaker-tensorflow-training>=20" \

    # Let's install TensorFlow separately in the end to avoid
    # the library version to be overwritten
 && ${PIP} install --no-cache-dir -U \
    ${TF_URL} \
    ${ESTIMATOR_URL} \
    h5py==2.10.0 \
    "absl-py>=0.9,<0.11" \
    horovod==0.21.0 \
    werkzeug==2.0.2 \
    psutil==5.7.2 \
    smdebug==${SMDEBUG_VERSION} \
    smclarify

# Install extra packages
# numba 0.54 only works with numpy>=1.20. See https://github.com/numba/numba/issues/7339
# Pinning bokeh to 2.3.3 due to typing-extension package version conflict with tensorlfow-cpu. See https://github.com/aws/deep-learning-containers/issues/1393
RUN ${PIP} install --no-cache-dir -U \
   "bokeh==2.3.3" \
   "imageio>=2.9,<3" \
   "opencv-python>=4.3,<5" \
   "plotly>=5.1,<6" \
   "seaborn>=0.11,<1" \
   "numba<0.54" \
   "shap>=0.39,<1"

COPY deep_learning_container.py /usr/local/bin/deep_learning_container.py

RUN chmod +x /usr/local/bin/deep_learning_container.py

RUN HOME_DIR=/root \
 && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
 && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
 && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
 && chmod +x /usr/local/bin/testOSSCompliance \
 && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
 && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} ${PYTHON} \
 && rm -rf ${HOME_DIR}/oss_compliance*

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/tensorflow-2.4/license.txt -o /license.txt

CMD ["/bin/bash"]
