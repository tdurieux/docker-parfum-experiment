FROM ubuntu:18.04

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"

# Specify accept-bind-to-port LABEL for inference pipelines to use SAGEMAKER_BIND_TO_PORT
# https://docs.aws.amazon.com/sagemaker/latest/dg/inference-pipeline-real-time.html
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

ARG MMS_VERSION=1.1.8
ARG PYTHON=python3.7
ARG PYTHON_VERSION=3.7.10
ARG MAMBA_VERSION=4.12.0-2
# Pin torch neuron version to sdk1.19.1
ARG TORCH_NEURON_VERSION=">=1.10.2,<1.10.3"
# HF ARGS
ARG TRANSFORMERS_VERSION

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    LD_LIBRARY_PATH="/opt/conda/lib/:${LD_LIBRARY_PATH}:/usr/local/lib" \
    PYTHONIOENCODING=UTF-8 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TEMP=/home/model-server/tmp \
    DEBIAN_FRONTEND=noninteractive

ENV PATH /opt/conda/bin:$PATH

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    openssl \
    openjdk-8-jdk-headless \
    vim \
    wget \
    curl \
    emacs \
    unzip \
    git \
    gnupg2 \
    wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN curl -f -L -o ~/mambaforge.sh https://github.com/conda-forge/miniforge/releases/download/${MAMBA_VERSION}/Mambaforge-${MAMBA_VERSION}-Linux-x86_64.sh \
 && chmod +x ~/mambaforge.sh \
 && ~/mambaforge.sh -b -p /opt/conda \
 && rm ~/mambaforge.sh \
 && /opt/conda/bin/conda install -c conda-forge \
    python=$PYTHON_VERSION \
    cython \
    mkl \
    mkl-include \
    botocore \
    # Below 2 are included in miniconda base, but not mamba so need to install
    conda-content-trust \
    charset-normalizer
# Upstream conda looks to have moved to 4.13 which is incompatible with mamba 0.22.1 and will fail the conda-forge installs.
# having "conda update conda" before the "conda -c conda-forge" commands will automatically update conda to 4.13.
# Moving conda update conda" after the "conda -c conda-forge" commands keep conda at 4.12 but will update other packages using
# the current conda 4.12
RUN /opt/conda/bin/conda update -y conda \
   && /opt/conda/bin/conda clean -ya



RUN echo "deb https://apt.repos.neuron.amazonaws.com bionic main" > /etc/apt/sources.list.d/neuron.list
RUN wget -qO - https://apt.repos.neuron.amazonaws.com/GPG-PUB-KEY-AMAZON-AWS-NEURON.PUB | apt-key add -

# Installing Neuron Tools
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
      aws-neuron-tools \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/tmp* \
 && apt-get clean

# Sets up Path for Neuron tools
ENV PATH="/opt/bin/:/opt/aws/neuron/bin:${PATH}"

# Install Neuron PyTorch
# including neuron-cc to be able to compile
RUN pip install --no-cache-dir \
    torch-neuron$TORCH_NEURON_VERSION \


    --extra-index-url=https://pip.repos.neuron.amazonaws.com


RUN pip install --no-cache-dir --upgrade pip --trusted-host pypi.org --trusted-host \
 && ln -s /opt/conda/bin/pip /usr/local/bin/pip3 \
 && pip install --no-cache-dir packaging==20.4 \
    enum-compat==0.0.3 \

    "cryptography>=3.3.2"


WORKDIR /

RUN pip install --no-cache-dir \
    multi-model-server==$MMS_VERSION \
    sagemaker-inference

RUN useradd -m model-server \
 && mkdir -p /home/model-server/tmp \
 && chown -R model-server /home/model-server

COPY neuron-entrypoint.py /usr/local/bin/dockerd-entrypoint.py
COPY neuron-monitor.sh /usr/local/bin/neuron-monitor.sh
COPY config.properties /etc/sagemaker-mms.properties

RUN chmod +x /usr/local/bin/dockerd-entrypoint.py \
 && chmod +x /usr/local/bin/neuron-monitor.sh

ADD https://raw.githubusercontent.com/aws/deep-learning-containers/master/src/deep_learning_container.py /usr/local/bin/deep_learning_container.py

RUN chmod +x /usr/local/bin/deep_learning_container.py

#################################
# Hugging Face specific section #
#################################

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/pytorch-1.10/license.txt -o /license.txt

# install Hugging Face libraries and its dependencies
RUN pip install --no-cache-dir \
	transformers[sentencepiece]==${TRANSFORMERS_VERSION} \
	protobuf==3.12.0 \
	"sagemaker-huggingface-inference-toolkit<3"

RUN HOME_DIR=/root \
 && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
 && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
 && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
 && chmod +x /usr/local/bin/testOSSCompliance \
 && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
 && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} ${PYTHON} \
 && rm -rf ${HOME_DIR}/oss_compliance*

EXPOSE 8080 8081
ENTRYPOINT ["python", "/usr/local/bin/dockerd-entrypoint.py"]
CMD ["serve"]
