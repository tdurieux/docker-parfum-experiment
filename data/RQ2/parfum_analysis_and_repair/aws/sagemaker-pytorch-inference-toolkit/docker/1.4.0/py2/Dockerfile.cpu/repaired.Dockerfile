FROM ubuntu:16.04

LABEL maintainer="Amazon AI"
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true
LABEL com.amazonaws.sagemaker.capabilities.multi-models=true

ARG PYTHON_VERSION=2.7
ARG PYTORCH_VERSION=1.4.0
ARG TORCHVISION_VERSION=0.5.0
ARG MMS_VERSION=1.0.8

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8
ENV LD_LIBRARY_PATH /opt/conda/lib/:$LD_LIBRARY_PATH
ENV PATH /opt/conda/bin:$PATH
ENV SAGEMAKER_SERVING_MODULE sagemaker_pytorch_serving_container.serving:main
ENV TEMP=/home/model-server/tmp

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    git \
    jq \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    openjdk-8-jdk-headless \
    vim \
    wget \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;


RUN curl -f -L -o ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p /opt/conda \
 && rm ~/miniconda.sh \
 && /opt/conda/bin/conda update conda \
 && /opt/conda/bin/conda install -y \
    python=$PYTHON_VERSION \
    cython==0.29.12 \
    ipython==5.8.0 \
    mkl-include==2019.4 \
    mkl==2019.4 \
    numpy==1.16.4 \
    scipy==1.2.1 \
    typing==3.7.4 \
 && /opt/conda/bin/conda clean -ya

RUN conda install -c \
    conda-forge \
    awscli==1.18.23 \
    opencv==4.0.1 \
 && conda install -y \
    scikit-learn==0.20.3 \
    pandas==0.24.2 \
    h5py==2.9.0 \
    requests==2.22.0 \
 && conda install \
    pytorch==$PYTORCH_VERSION \
    torchvision==$TORCHVISION_VERSION cpuonly -c pytorch \
 && conda clean -ya \
 && pip install --no-cache-dir --upgrade pip --trusted-host pypi.org --trusted-host \
 && pip install --no-cache-dir mxnet-model-server==$MMS_VERSION

RUN useradd -m model-server \
 && mkdir -p /home/model-server/tmp \
 && chown -R model-server /home/model-server

COPY mms-entrypoint.py /usr/local/bin/dockerd-entrypoint.py
COPY config.properties /home/model-server

RUN chmod +x /usr/local/bin/dockerd-entrypoint.py

RUN pip install --no-cache-dir "sagemaker-pytorch-inference<2"

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/pytorch-1.4.0/license.txt -o /license.txt

RUN conda install -y -c conda-forge pyyaml==5.3.1
RUN pip install --no-cache-dir sagemaker-containers==2.8.6 pillow==6.2.2 urllib3==1.25.8 awscli==1.18.35

EXPOSE 8080 8081
ENTRYPOINT ["python", "/usr/local/bin/dockerd-entrypoint.py"]
CMD ["mxnet-model-server", "--start", "--mms-config", "/home/model-server/config.properties"]
