FROM ubuntu:16.04

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true
LABEL com.amazonaws.sagemaker.capabilities.multi-models=true

ARG PYTHON=python3
ARG PYTHON_VERSION=3.6.13
ARG OPEN_MPI_VERSION=4.0.1
ARG TS_VERSION="0.3.1"
ARG PT_INFERENCE_URL=https://aws-pytorch-binaries.s3-us-west-2.amazonaws.com/r1.6.0_inference/20200727-223446/b0251e7e070e57f34ee08ac59ab4710081b41918/cpu/torch-1.6.0-cp36-cp36m-manylinux1_x86_64.whl
ARG PT_VISION_URL=https://torchvision-build.s3.amazonaws.com/1.6.0/cpu/torchvision-0.7.0-cp36-cp36m-linux_x86_64.whl

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8
ENV LD_LIBRARY_PATH /opt/conda/lib/:$LD_LIBRARY_PATH
ENV PATH /opt/conda/bin:$PATH
ENV SAGEMAKER_SERVING_MODULE sagemaker_pytorch_serving_container.serving:main
ENV TEMP=/home/model-server/tmp

RUN apt-get update \
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
    vim \
    wget \
    unzip \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;


# https://github.com/docker-library/openjdk/issues/261 https://github.com/docker-library/openjdk/pull/263/files
RUN keytool -importkeystore -srckeystore /etc/ssl/certs/java/cacerts -destkeystore /etc/ssl/certs/java/cacerts.jks -deststoretype JKS -srcstorepass changeit -deststorepass changeit -noprompt; \
    mv /etc/ssl/certs/java/cacerts.jks /etc/ssl/certs/java/cacerts; \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure;


RUN curl -f -L -o ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p /opt/conda \
 && rm ~/miniconda.sh \
 && /opt/conda/bin/conda update conda \
 && /opt/conda/bin/conda install -c conda-forge \
    python=$PYTHON_VERSION \
 && /opt/conda/bin/conda install -y \
    cython==0.29.12 \
    ipython==7.7.0 \
    mkl-include==2019.4 \
    mkl==2019.4 \
    numpy==1.19.1 \
    scipy==1.3.0 \
    typing==3.6.4 \
 && /opt/conda/bin/conda clean -ya


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


RUN conda install -c \
    conda-forge \
    opencv==4.0.1 \
 && conda install -y \
    scikit-learn==0.21.2 \
    pandas==0.25.0 \
    h5py==2.9.0 \
    requests==2.22.0 \
 && conda clean -ya \
 && pip install --no-cache-dir --upgrade pip --trusted-host pypi.org --trusted-host \
 && ln -s /opt/conda/bin/pip /usr/local/bin/pip3 \
 && pip install --no-cache-dir packaging==20.4 \
    enum-compat==0.0.3 \
    "cryptography>3.2"


# Uninstall and re-install torch and torchvision from the PyTorch website
RUN pip uninstall -y torch \
 && pip install --no-cache-dir -U $PT_INFERENCE_URL \
 && pip uninstall -y torchvision \
 && pip install --no-deps --no-cache-dir -U $PT_VISION_URL

RUN pip uninstall -y model-archiver multi-model-server \
 && pip install --no-cache-dir captum \
 && pip install --no-cache-dir torchserve==$TS_VERSION \
 && pip install --no-cache-dir torch-model-archiver==$TS_VERSION

RUN useradd -m model-server \
 && mkdir -p /home/model-server/tmp /opt/ml/model \
 && chown -R model-server /home/model-server /opt/ml/model

COPY torchserve-entrypoint.py /usr/local/bin/dockerd-entrypoint.py
COPY config.properties /home/model-server

RUN chmod +x /usr/local/bin/dockerd-entrypoint.py

ADD https://raw.githubusercontent.com/aws/deep-learning-containers/master/src/deep_learning_container.py /usr/local/bin/deep_learning_container.py

RUN chmod +x /usr/local/bin/deep_learning_container.py

RUN pip install --no-cache-dir "sagemaker-pytorch-inference>=2"

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/pytorch-1.6.0/license.txt -o /license.txt

RUN conda install -y -c conda-forge "pyyaml>5.4,<5.5"
RUN pip install --no-cache-dir \
    "pillow>=8.3.2,<8.4" \
    "awscli<2" \
    ruamel-yaml

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
CMD ["torchserve", "--start", "--ts-config", "/home/model-server/config.properties", "--model-store", "/home/model-server/"]
