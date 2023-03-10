FROM vault.habana.ai/gaudi-docker/0.15.4/ubuntu18.04/habanalabs/tensorflow-installer-tf-cpu-2.5.0:0.15.4-75

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"

# prevent stopping by user interaction
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

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
ARG PIP=pip3.7

ARG TF_URL=https://aws-tensorflow-binaries.s3.us-west-2.amazonaws.com/tensorflow/r2.5_aws/20210715_063140/nomkl/cpu/py37/tensorflow_cpu-2.5.0-cp37-cp37m-manylinux2010_x86_64.whl


RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential \
    openssh-client \
    openssh-server \
    ca-certificates \
    curl \
    jq \
    emacs \
    git \
    libtemplate-perl \
    libssl1.1 \
    openssl \
    unzip \
    wget \
    vim \
    zlib1g-dev \
    # Install dependent library for OpenCV
    libgtk2.0-dev \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean

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


RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python \
 && ln -s $(which ${PIP}) /usr/bin/pip

RUN apt-get update && apt-get -y --no-install-recommends install cmake protobuf-compiler && rm -rf /var/lib/apt/lists/*;

RUN ${PIP} uninstall -y tensorflow-cpu \
 && ${PIP} install --no-cache-dir -U \
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
    opencv-python==4.3.0.36 \
 && ${PIP} uninstall -y keras \
 && ${PIP} install --no-cache-dir -U boto3 --upgrade \
    # Let's install TensorFlow separately in the end to avoid
    # the library version to be overwritten
 && ${PIP} install --no-cache-dir -U \
    ${TF_URL} \
    h5py==3.1.0 \
    "absl-py>=0.9,<0.11" \
    werkzeug \
    psutil==5.7.2 \
 && rm -rf ${TF_URL}

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

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/tensorflow-2.5/license.txt -o /license.txt

CMD ["/bin/bash"]
