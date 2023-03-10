FROM vault.habana.ai/gaudi-docker/1.4.1/ubuntu20.04/habanalabs/pytorch-installer-1.10.2:latest

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"

# Python versions
ARG PYTHON=python3.8
ARG PYTHON_PIP=python3-pip
ARG PIP=pip3.8

ENV PT_VERSION=1.10

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


ARG PT_TRAINING_URL=https://framework-binaries.s3.us-west-2.amazonaws.com/habana/1.4.1/torch-1.10.0a0%2Bgitfe03f8c-cp38-cp38-linux_x86_64.whl

RUN pip --no-cache-dir install --upgrade \
    pip \
    "setuptools==59.5.0"

# The following section uninstalls torch and torchvision before installing the
# custom versions from an S3 bucket.
RUN pip install --no-cache-dir --user -U \
    fastai==1.0.61 \
    "pyyaml>=5.4,<5.5" \
    "awscli<2" \
    psutil \
    Pillow \
    scipy \
    pybind11 \
    mpi4py==3.0.3 \
    cmake==3.18.2.post1 \
    torchnet \
    "cryptography>3.2" \
    werkzeug \
 && pip install --no-cache-dir --user -U boto3 --upgrade \
 && pip uninstall -y torch \
 && pip uninstall -y hb-torch \
 && pip install --no-cache-dir --user -U ${PT_TRAINING_URL} \
 && rm -rf ${PT_TRAINING_URL}

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/.local/lib

RUN ln -s $(which ${PYTHON}) /usr/local/bin/python \
 && ln -s $(which ${PIP}) /usr/bin/pip

# Copy workaround script for incorrect hostname
COPY changehostname.c /
COPY start_with_right_hostname.sh /usr/local/bin/start_with_right_hostname.sh

COPY deep_learning_container.py /usr/local/bin/deep_learning_container.py

RUN chmod +x /usr/local/bin/start_with_right_hostname.sh \
 && chmod +x /usr/local/bin/deep_learning_container.py

RUN HOME_DIR=/root \
 && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
 && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
 && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
 && chmod +x /usr/local/bin/testOSSCompliance \
 && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
 && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} ${PYTHON} \
 && rm -rf ${HOME_DIR}/oss_compliance*

RUN curl -f -o /license.txt https://aws-dlc-licenses.s3.amazonaws.com/pytorch-${PT_VERSION}/license.txt

# Starts framework
ENTRYPOINT ["bash", "-m", "start_with_right_hostname.sh"]
CMD ["/bin/bash"]
