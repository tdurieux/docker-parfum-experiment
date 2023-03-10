FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu16.04
# NCCL_VERSION=2.4.7, CUDNN_VERSION=7.6.2.24
LABEL maintainer="Amazon AI"
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

RUN apt-get update && apt-get install -y  --allow-downgrades --allow-change-held-packages --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        libgomp1 \
        libibverbs-dev \
        curl \
        git \
        wget \
        vim \
        jq \
        libsm6 \
        libxext6 \
        libxrender-dev \
        build-essential \
        zlib1g-dev \
        libglib2.0-0 \
        libgl1-mesa-glx \
        openjdk-8-jdk-headless && rm -rf /var/lib/apt/lists/*;

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

# Add arguments to achieve the version, python and url
ARG PYTHON_VERSION=3.6.6

# Install OpenSSH. Allow OpenSSH to talk to containers without asking for confirmation
RUN apt-get install -y --no-install-recommends openssh-client openssh-server && \
    mkdir -p /var/run/sshd && \
    cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new && \
    mv /etc/ssh/ssh_config.new /etc/ssh/ssh_configs && rm -rf /var/lib/apt/lists/*;

RUN curl -f -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod +x ~/miniconda.sh && \
    ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda update conda && \
    /opt/conda/bin/conda install -y python=$PYTHON_VERSION \
	                              numpy==1.16.4 \
	                              scipy==1.3.0 \
	                              ipython==7.7.0 \
	                              mkl==2019.4 \
	                              mkl-include==2019.4 \
	                              cython==0.29.12 \
	                              typing==3.6.4 && \
		/opt/conda/bin/conda clean -ya
ENV PATH /opt/conda/bin:$PATH

ARG PYTORCH_VERSION=1.2.0
ARG TORCHVISION_VERSION=0.4.0
ARG MMS_VERSION=1.0.7
RUN conda install -c pytorch magma-cuda100 && \
    conda install -c conda-forge awscli==1.16.210 opencv==4.0.1 && \
    conda install -y scikit-learn==0.21.2 \
                     pandas==0.25.0 \
                     pillow==5.4.1 \
                     h5py==2.9.0 \
                     requests==2.22.0 && \
    conda install pytorch==$PYTORCH_VERSION torchvision==$TORCHVISION_VERSION cudatoolkit=10.0 -c pytorch && \
    conda clean -ya && \
    /opt/conda/bin/conda config --set ssl_verify False && \
    pip install --no-cache-dir --upgrade pip --trusted-host pypi.org --trusted-host && \
    ln -s /opt/conda/bin/pip /usr/local/bin/pip3 && \
    pip install --no-cache-dir mxnet-model-server==$MMS_VERSION

RUN useradd -m model-server \
    && mkdir -p /home/model-server/tmp \
    && chown -R model-server /home/model-server

COPY docker/$PYTORCH_VERSION/py3/mms-entrypoint.py /usr/local/bin/dockerd-entrypoint.py
COPY docker/$PYTORCH_VERSION/py3/config.properties /home/model-server

RUN chmod +x /usr/local/bin/dockerd-entrypoint.py

COPY dist/sagemaker_pytorch_serving_container-1.2-py2.py3-none-any.whl /sagemaker_pytorch_serving_container-1.2-py2.py3-none-any.whl
RUN pip install --no-cache-dir /sagemaker_pytorch_serving_container-1.2-py2.py3-none-any.whl && \
    rm /sagemaker_pytorch_serving_container-1.2-py2.py3-none-any.whl

ENV SAGEMAKER_SERVING_MODULE sagemaker_pytorch_serving_container.serving:main

EXPOSE 8080 8081
ENV TEMP=/home/model-server/tmp
ENTRYPOINT ["python", "/usr/local/bin/dockerd-entrypoint.py"]
CMD ["mxnet-model-server", "--start", "--mms-config", "/home/model-server/config.properties"]
