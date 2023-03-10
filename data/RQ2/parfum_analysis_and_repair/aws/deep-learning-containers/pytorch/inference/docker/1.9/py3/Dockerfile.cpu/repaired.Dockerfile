FROM ubuntu:20.04

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true
LABEL com.amazonaws.sagemaker.capabilities.multi-models=true

ARG PYTHON=python3
ARG PYTHON_VERSION=3.8.10
ARG OPEN_MPI_VERSION=4.0.1
ARG TS_VERSION=0.5.3
ARG PT_INFERENCE_URL=https://pytorch-ei-binaries.s3.us-west-2.amazonaws.com/r1.9.1_inference/cpu/torch-1.9.1-cp38-cp38-manylinux1_x86_64.whl
ARG PT_TORCHVISION_URL=https://aws-pytorch-cicd-v3-binaries.s3.us-west-2.amazonaws.com/r1.9.1_aws_v3/torchvision/cpu/torchvision-0.10.1%2Bcpu-cp38-cp38-manylinux1_x86_64.whl
ARG PT_TORCHAUDIO_URL=https://pytorch-ei-binaries.s3.us-west-2.amazonaws.com/r1.9.1_inference/cpu/torchaudio-0.9.1-cp38-cp38-linux_x86_64.whl

ENV LANG C.UTF-8
ENV LD_LIBRARY_PATH /opt/conda/lib/:$LD_LIBRARY_PATH
ENV PATH /opt/conda/bin:$PATH
ENV SAGEMAKER_SERVING_MODULE sagemaker_pytorch_serving_container.serving:main
ENV TEMP=/home/model-server/tmp
# Set MKL_THREADING_LAYER=GNU to prevent issues between torch and numpy/mkl
ENV MKL_THREADING_LAYER=GNU

RUN apt-get update \
# TODO: Remove systemd upgrade once it is updated in base image
 && apt-get -y upgrade --only-upgrade systemd \
 && apt-get install -y --no-install-recommends software-properties-common \
 && add-apt-repository ppa:openjdk-r/ppa \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    emacs \
    git \
    jq \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    openjdk-11-jdk \
    openssl \
    vim \
    wget \
    unzip \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean

# https://github.com/docker-library/openjdk/issues/261 https://github.com/docker-library/openjdk/pull/263/files
RUN keytool -importkeystore -srckeystore /etc/ssl/certs/java/cacerts -destkeystore /etc/ssl/certs/java/cacerts.jks -deststoretype JKS -srcstorepass changeit -deststorepass changeit -noprompt; \
    mv /etc/ssl/certs/java/cacerts.jks /etc/ssl/certs/java/cacerts; \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure;

RUN curl -f -L -o ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p /opt/conda \
 && rm ~/miniconda.sh \
 && /opt/conda/bin/conda install -c conda-forge \
    python=$PYTHON_VERSION \
 && /opt/conda/bin/conda install -y \
    # conda 4.10.0 requires ruamel_yaml to be installed. Currently pinned at latest.
    ruamel_yaml==0.15.100 \
    cython \
    ipython \
    mkl-include \
    mkl \
    parso \
    scipy \
    typing \
 && /opt/conda/bin/conda clean -ya \
 && /opt/conda/bin/conda update conda

# Conda installs links for libtinfo.so.6 and libtinfo.so.6.2 both
# Which causes "/opt/conda/lib/libtinfo.so.6: no version information available" warning
# Removing link for libtinfo.so.6. This change is needed only for ubuntu 20.04-conda, and can be reverted
# once conda fixes the issue: https://github.com/conda/conda/issues/9680
RUN rm -rf /opt/conda/lib/libtinfo.so.6

RUN wget https://www.open-mpi.org/software/ompi/v4.0/downloads/openmpi-$OPEN_MPI_VERSION.tar.gz \
 && gunzip -c openmpi-$OPEN_MPI_VERSION.tar.gz | tar xf - \
 && cd openmpi-$OPEN_MPI_VERSION \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/home/.openmpi \
 && make all install \
 && cd .. \
 && rm openmpi-$OPEN_MPI_VERSION.tar.gz \
 && rm -rf openmpi-$OPEN_MPI_VERSION

# The ENV variables declared below are changed in the previous section
# Grouping these ENV variables in the first section causes
# ompi_info to fail. This is only observed in CPU containers
ENV PATH="$PATH:/home/.openmpi/bin"
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/.openmpi/lib/"
RUN ompi_info --parsable --all | grep mpi_built_with_cuda_support:value

RUN conda install -y -c \
    conda-forge \
    opencv \
    scikit-learn \
    pandas \
    h5py \
    requests \
 && conda clean -ya

RUN pip install --no-cache-dir --upgrade pip --trusted-host pypi.org --trusted-host \
 && ln -s /opt/conda/bin/pip /usr/local/bin/pip3 \
 && pip install --no-cache-dir packaging==20.4 \
    enum-compat==0.0.3 \
    "numpy>=1.22.2" \
    "cryptography>=3.3.2"

# Uninstall and re-install torch and torchvision from the PyTorch website
RUN pip uninstall -y torch \
 && pip install --no-cache-dir -U $PT_INFERENCE_URL \
 && pip uninstall -y torchvision \
 && pip install --no-deps --no-cache-dir -U $PT_TORCHVISION_URL \
 && pip uninstall -y torchaudio \
 && pip install --no-deps --no-cache-dir -U $PT_TORCHAUDIO_URL


RUN conda install -y -c conda-forge "pyyaml>=5.4,<5.5"
RUN pip install --no-cache-dir \
    "Pillow>=9.0.1" \
    "awscli<2" \
    "urllib3>=1.26.5"

RUN pip install --no-cache-dir "sagemaker-pytorch-inference==2.0.6"

RUN pip uninstall -y model-archiver multi-model-server \
 && pip install --no-cache-dir captum \
 && pip install --no-cache-dir torchserve==$TS_VERSION \
 && pip install --no-cache-dir torch-model-archiver==$TS_VERSION

RUN cd tmp/ \
 && rm -rf tmp*

RUN useradd -m model-server \
 && mkdir -p /home/model-server/tmp /opt/ml/model \
 && chown -R model-server /home/model-server /opt/ml/model

COPY torchserve-entrypoint.py /usr/local/bin/dockerd-entrypoint.py
COPY config.properties /home/model-server

RUN chmod +x /usr/local/bin/dockerd-entrypoint.py

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

RUN curl -f -o /license.txt https://aws-dlc-licenses.s3.amazonaws.com/pytorch-1.9/license.txt

EXPOSE 8080 8081
ENTRYPOINT ["python", "/usr/local/bin/dockerd-entrypoint.py"]
CMD ["torchserve", "--start", "--ts-config", "/home/model-server/config.properties", "--model-store", "/home/model-server/"]
