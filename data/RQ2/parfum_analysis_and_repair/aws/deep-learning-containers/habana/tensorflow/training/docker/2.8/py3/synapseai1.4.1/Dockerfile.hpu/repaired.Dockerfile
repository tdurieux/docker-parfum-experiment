FROM vault.habana.ai/gaudi-docker/1.4.1/ubuntu20.04/habanalabs/tensorflow-installer-tf-cpu-2.8.0:latest

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
ENV TF_VERSION=2.8

ARG PYTHON=python3.8
ARG PYTHON_PIP=python3-pip
ARG PIP=pip3.8

ARG TF_URL=https://framework-binaries.s3.us-west-2.amazonaws.com/habana/1.4.0/tensorflow_cpu-2.8.0-cp38-cp38-manylinux2010_x86_64.whl


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
    #Setuptools release 60.x (and later) revealed an issue in Habana-TensorFlow package.
    "setuptools<60.0.0"

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python \
 && ln -s $(which ${PIP}) /usr/bin/pip

RUN apt-get update && apt-get -y --no-install-recommends install cmake protobuf-compiler && rm -rf /var/lib/apt/lists/*;

RUN ${PIP} uninstall -y tensorflow-cpu \
 && ${PIP} uninstall -y keras \
 && ${PIP} install --no-cache-dir -U boto3 --upgrade \
    # Let's install TensorFlow separately in the end to avoid
    # the library version to be overwritten
 && ${PIP} install --no-cache-dir -U \
    ${TF_URL} \
    h5py==3.1.0 \
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

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/tensorflow-${TF_VERSION}/license.txt -o /license.txt

CMD ["/bin/bash"]
