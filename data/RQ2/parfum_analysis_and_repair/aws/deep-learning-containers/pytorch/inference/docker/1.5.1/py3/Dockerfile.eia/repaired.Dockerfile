FROM ubuntu:16.04
LABEL maintainer="Amazon AI"
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true
LABEL dlc_major_version="1"

# Add arguments to achieve the version, python and url
ARG PYTHON=python3
ARG PYTHON_VERSION=3.6.13
ARG PYTORCH_VERSION=1.5.1
ARG TORCHVISION_VERSION=0.6.1
ARG GRAPHVIZ_VERSION=0.13.2
ARG MMS_VERSION=1.1.2
ARG HEALTH_CHECK_VERSION=1.7.0

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8
ENV LD_LIBRARY_PATH /opt/conda/lib/:$LD_LIBRARY_PATH
ENV PATH /opt/conda/bin:$PATH
ENV SAGEMAKER_SERVING_MODULE sagemaker_pytorch_serving_container.serving:main
ENV TEMP=/home/model-server/tmp

RUN apt-get update \
 && apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    emacs \
    git \
    jq \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libgomp1 \
    libibverbs-dev \
    libsm6 \
    libxext6 \
    libxrender-dev \
    openjdk-8-jdk-headless \
    vim \
    wget \
    unzip \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# Install OpenSSH. Allow OpenSSH to talk to containers without asking for confirmation
RUN apt-get install -y --no-install-recommends \
    openssh-client \
    openssh-server \
 && mkdir -p /var/run/sshd \
 && cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new \
 && echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new \
 && mv /etc/ssh/ssh_config.new /etc/ssh/ssh_configs && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L -o ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p /opt/conda \
 && rm ~/miniconda.sh \
 && /opt/conda/bin/conda update conda \
 && /opt/conda/bin/conda install -c \
    conda-forge \
    python=$PYTHON_VERSION \
 && /opt/conda/bin/conda install -y \
    # conda 4.9.2 requires ruamel_yaml to be installed. Currently pinned at latest.
    ruamel_yaml==0.15.100 \
    cython==0.29.12 \
    ipython==7.7.0 \
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
 && /opt/conda/bin/conda config --set ssl_verify False \
 && pip install --no-cache-dir --upgrade pip --trusted-host pypi.org --trusted-host \
 && ln -s /opt/conda/bin/pip /usr/local/bin/pip3 \
 # Torchvision wheel must be installed first, so that PyTorch-EI framework is not overwritten.
 && pip install --no-cache-dir https://download.pytorch.org/whl/cpu/torchvision-0.6.1%2Bcpu-cp36-cp36m-linux_x86_64.whl \
 && pip install --no-cache-dir http://amazonei-pytorcheia.s3.amazonaws.com/releases/v1.0.0/torcheia-1.0.0-cp36-cp36m-manylinux1_x86_64.whl \
 && pip install --no-cache-dir graphviz==$GRAPHVIZ_VERSION \
 && pip install --no-cache-dir multi-model-server==$MMS_VERSION \
 && pip install --no-cache-dir pillow==8.2.0 \
 # pyOpenSSL requires cryptography>=2.3, but all versions <3.3 have vulnerabilities
 && pip install --no-cache-dir -U "cryptography>=3.3"

RUN useradd -m model-server \
 && mkdir -p /home/model-server/tmp \
 && chown -R model-server /home/model-server

COPY mms-entrypoint.py /usr/local/bin/dockerd-entrypoint.py
COPY config.properties /home/model-server

RUN chmod +x /usr/local/bin/dockerd-entrypoint.py

RUN pip install --no-cache-dir "sagemaker-pytorch-inference<2"

RUN HOME_DIR=/root \
 && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
 && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
 && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
 && chmod +x /usr/local/bin/testOSSCompliance \
 && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
 && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} ${PYTHON} \
 && rm -rf ${HOME_DIR}/oss_compliance*

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/pytorch-1.5.1/license.txt -o /license.txt

RUN conda install -y -c conda-forge "pyyaml>=5.4,<5.5" \
 && pip install --no-cache-dir -U \
    "awscli<2"

RUN wget https://amazonei-tools.s3.amazonaws.com/v${HEALTH_CHECK_VERSION}/ei_tools_${HEALTH_CHECK_VERSION}.tar.gz -O /opt/ei_tools_${HEALTH_CHECK_VERSION}.tar.gz \
 && tar -xvf /opt/ei_tools_${HEALTH_CHECK_VERSION}.tar.gz -C /opt/ \
 && rm -rf /opt/ei_tools_${HEALTH_CHECK_VERSION}.tar.gz \
 && chmod a+x /opt/ei_tools/bin/health_check \
 && mkdir -p /opt/ei_health_check/bin \
 && ln -s /opt/ei_tools/bin/health_check /opt/ei_health_check/bin/health_check \
 && ln -s /opt/ei_tools/lib /opt/ei_health_check/lib

COPY default_inference_handler.py /opt/conda/lib/python3.6/site-packages/sagemaker_pytorch_serving_container/default_inference_handler.py

EXPOSE 8080 8081
ENTRYPOINT ["python", "/usr/local/bin/dockerd-entrypoint.py"]
CMD ["multi-model-server", "--start", "--mms-config", "/home/model-server/config.properties"]
