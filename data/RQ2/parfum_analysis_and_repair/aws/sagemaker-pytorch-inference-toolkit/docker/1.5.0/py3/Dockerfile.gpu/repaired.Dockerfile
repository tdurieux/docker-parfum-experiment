FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu16.04
# NCCL_VERSION=2.4.7, CUDNN_VERSION=7.6.2.24
LABEL maintainer="Amazon AI"
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

# Add arguments to achieve the version, python and url
ARG PYTHON_VERSION=3.6.6
ARG PYTORCH_VERSION=1.5.0
ARG TORCHVISION_VERSION=0.6.0
ARG MMS_VERSION=1.0.8

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
 && /opt/conda/bin/conda install -y \
    python=$PYTHON_VERSION \
    cython==0.29.12 \
    ipython==7.7.0 \
    mkl-include==2019.4 \
    mkl==2019.4 \
    numpy==1.16.4 \
    scipy==1.3.0 \
    typing==3.6.4 \
 && /opt/conda/bin/conda clean -ya

RUN conda install -c \
    pytorch magma-cuda101 \
 && conda install -c \
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
 && pip install --no-cache-dir mxnet-model-server==$MMS_VERSION

# Uninstall and re-install torch and torchvision from the PyTorch website
RUN pip uninstall -y torch \
 && pip uninstall -y torchvision \
 && pip install --no-cache-dir torch==$PYTORCH_VERSION+cu101 torchvision==$TORCHVISION_VERSION+cu101 -f https://download.pytorch.org/whl/torch_stable.html

RUN useradd -m model-server \
 && mkdir -p /home/model-server/tmp \
 && chown -R model-server /home/model-server

COPY mms-entrypoint.py /usr/local/bin/dockerd-entrypoint.py
COPY config.properties /home/model-server

RUN chmod +x /usr/local/bin/dockerd-entrypoint.py

RUN pip install --no-cache-dir "sagemaker-pytorch-inference<2"

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/pytorch-1.5.0/license.txt -o /license.txt

RUN conda install -y -c conda-forge pyyaml==5.3.1
RUN pip install --no-cache-dir sagemaker-containers==2.8.6 pillow==7.1.0 awscli

EXPOSE 8080 8081
ENTRYPOINT ["python", "/usr/local/bin/dockerd-entrypoint.py"]
CMD ["mxnet-model-server", "--start", "--mms-config", "/home/model-server/config.properties"]
