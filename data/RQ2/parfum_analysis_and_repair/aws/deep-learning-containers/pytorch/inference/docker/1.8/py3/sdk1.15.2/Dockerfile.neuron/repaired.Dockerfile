FROM ubuntu:18.04

LABEL dlc_major_version="1"
LABEL maintainer="Amazon AI"
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

ARG PYTHON=python3.7
ARG PYTHON_VERSION=3.7.10
ARG TS_VERSION=0.4.0

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
    apt-transport-https \
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
    zlib1g-dev \
    libcap-dev \
    gpg-agent \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/tmp* \
    && apt-get clean

RUN echo "deb https://apt.repos.neuron.amazonaws.com bionic main" > /etc/apt/sources.list.d/neuron.list
RUN wget -qO - https://apt.repos.neuron.amazonaws.com/GPG-PUB-KEY-AMAZON-AWS-NEURON.PUB | apt-key add -

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    aws-neuron-runtime \
    aws-neuron-tools \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/tmp* \
    && apt-get clean


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
    # conda 4.9.2 requires ruamel_yaml to be installed. Currently pinned at latest.
    ruamel_yaml==0.15.100 \
    cython==0.29.12 \
    ipython==7.7.0 \
    mkl-include==2019.4 \
    mkl==2019.4 \
    numpy==1.19.1 \
    scipy==1.3.0 \
    typing==3.6.4 \
    parso==0.8.0 \
 && /opt/conda/bin/conda clean -ya

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

    "cryptography>=3.3.2"

RUN pip install --no-cache-dir -U \
    numpy==1.17.4 \
    scipy==1.2.2 \
    scikit-learn==0.20.3 \
    pandas==0.24.2 \
    h5py==2.10.0 \
    # install PyYAML>=5.4 to avoid conflict with latest awscli
    "pyYAML>=5.4,<5.5" \
    cython==0.29.12 \
    falcon==2.0.0 \
    gunicorn==20.0.4 \
    gevent==1.4.0 \
    requests==2.22.0 \
    grpcio==1.34.1 \
    protobuf==3.16.0 \
    gast==0.2.2 \
    "pillow>=8.3" \
    "awscli<2" \
    boto3

RUN pip install --no-cache-dir neuron-cc[tensorflow] --extra-index-url https://pip.repos.neuron.amazonaws.com \
 && pip install --no-cache-dir "torch-neuron>=1.8.1,<1.8.2" --extra-index-url https://pip.repos.neuron.amazonaws.com \
 && pip install --no-cache-dir torchserve==$TS_VERSION --no-deps \
 && pip install --no-deps --no-cache-dir -U torchvision==0.9.1 \
 # Install TF 1.15.5 to override neuron-cc[tensorflow]'s installation of tensorflow==1.15.0
 && pip install --no-cache-dir -U tensorflow==1.15.5 \
 && pip install --no-cache-dir torch-model-archiver==$TS_VERSION

RUN useradd -m model-server \
 && mkdir -p /home/model-server/tmp /opt/ml/model \
 && chown -R model-server /home/model-server /opt/ml/model

COPY neuron-entrypoint.py /usr/local/bin/dockerd-entrypoint.py
COPY neuron-start.sh /usr/local/bin/neuron-start.sh
COPY config.properties /home/model-server

RUN chmod +x /usr/local/bin/dockerd-entrypoint.py
RUN chmod +x /usr/local/bin/neuron-start.sh

ADD https://raw.githubusercontent.com/aws/deep-learning-containers/master/src/deep_learning_container.py /usr/local/bin/deep_learning_container.py

RUN chmod +x /usr/local/bin/deep_learning_container.py

RUN pip install --no-cache-dir "sagemaker-pytorch-inference>=2"

RUN HOME_DIR=/root \
 && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
 && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
 && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
 && chmod +x /usr/local/bin/testOSSCompliance \
 && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
 && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} ${PYTHON} \
 && rm -rf ${HOME_DIR}/oss_compliance*

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/pytorch-1.8/license.txt -o /license.txt

EXPOSE 8080 8081

ENTRYPOINT ["python", "/usr/local/bin/dockerd-entrypoint.py"]
CMD ["torchserve", "--start", "--ts-config", "/home/model-server/config.properties", "--model-store", "/opt/ml/model"]
