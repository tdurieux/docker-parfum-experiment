FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu18.04

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"

# Specify accept-bind-to-port LABEL for inference pipelines to use SAGEMAKER_BIND_TO_PORT
# https://docs.aws.amazon.com/sagemaker/latest/dg/inference-pipeline-real-time.html
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

ARG MMS_VERSION=1.1.7
ARG PYTHON=python3
ARG PYTHON_VERSION=3.6.13
ARG OPEN_MPI_VERSION=4.0.1
# HF ARGS
ARG PT_INFERENCE_URL=https://pytorch-ei-binaries.s3-us-west-2.amazonaws.com/r1.8.1_inference/20210326-045154/0cef1489a03d1f55f692c38bfb26b5f4f6ecbfa7/gpu/torch-1.8.1-cp36-cp36m-manylinux1_x86_64.whl
ARG TRANSFORMERS_VERSION

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    LD_LIBRARY_PATH="/opt/conda/lib/:${LD_LIBRARY_PATH}:/usr/local/lib" \
    PYTHONIOENCODING=UTF-8 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

ENV PATH /opt/conda/bin:$PATH

RUN apt-get update \
 # TODO: Remove upgrade statements once packages are updated in base image
 && apt-get -y upgrade --only-upgrade systemd openssl \
 && apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    libssl1.1 \
    openssl \
    openjdk-8-jdk-headless \
    vim \
    wget \
    curl \
    emacs \
    unzip \
    git \
    libnuma1 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# py37 is the oldest python version supported by Miniconda 4.10.3, py36 is installed below and will override py37 environment
RUN curl -f -L -o ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py37_4.10.3-Linux-x86_64.sh \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p /opt/conda \
 && rm ~/miniconda.sh \
 && /opt/conda/bin/conda install -c conda-forge \
    python=$PYTHON_VERSION \
 && /opt/conda/bin/conda install -y \
    # conda 4.10.0 requires ruamel_yaml to be installed. Currently pinned at latest.
    ruamel_yaml==0.15.100 \
    cython==0.29.12 \
    botocore \
    mkl-include==2019.4 \
    mkl==2019.4 \
 && /opt/conda/bin/conda clean -ya

RUN pip install --no-cache-dir --upgrade pip --trusted-host pypi.org --trusted-host \
 && ln -s /opt/conda/bin/pip /usr/local/bin/pip3 \
 && pip install --no-cache-dir packaging==20.4 \
    enum-compat==0.0.3 \
    "cryptography>3.2"

RUN wget https://www.open-mpi.org/software/ompi/v4.0/downloads/openmpi-$OPEN_MPI_VERSION.tar.gz \
 && gunzip -c openmpi-$OPEN_MPI_VERSION.tar.gz | tar xf - \
 && cd openmpi-$OPEN_MPI_VERSION \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/home/.openmpi \
 && make all install \
 && cd .. \
 && rm openmpi-$OPEN_MPI_VERSION.tar.gz \
 && rm -rf openmpi-$OPEN_MPI_VERSION

ENV PATH="$PATH:/home/.openmpi/bin"
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/.openmpi/lib/"

WORKDIR /

RUN pip install --no-cache-dir \
    multi-model-server==$MMS_VERSION \
    sagemaker-inference

RUN useradd -m model-server \
 && mkdir -p /home/model-server/tmp \
 && chown -R model-server /home/model-server

COPY mms-entrypoint.py /usr/local/bin/dockerd-entrypoint.py
COPY config.properties /etc/sagemaker-mms.properties

RUN chmod +x /usr/local/bin/dockerd-entrypoint.py

ADD https://raw.githubusercontent.com/aws/deep-learning-containers/master/src/deep_learning_container.py /usr/local/bin/deep_learning_container.py

RUN chmod +x /usr/local/bin/deep_learning_container.py

#################################
# Hugging Face specific section #
#################################

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/pytorch-1.8/license.txt -o /license.txt

# Uninstall and re-install torch and torchvision from the PyTorch website
RUN pip uninstall -y torch \
 && pip install --no-cache-dir -U $PT_INFERENCE_URL

# install Hugging Face libraries and its dependencies
RUN pip install --no-cache-dir \
	transformers[sentencepiece]==${TRANSFORMERS_VERSION} \
	protobuf==3.12.0 \
	"sagemaker-huggingface-inference-toolkit<2"

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
