FROM ubuntu:16.04

LABEL maintainer="Amazon AI"

LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    cmake \
    curl \
    git \
    wget \
    vim \
    build-essential \
    jq \
    libglib2.0-0 \
    libgl1-mesa-glx \
    libsm6 \
    libxext6 \
    libxrender-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

# Add arguments to achieve the version, python and url
ARG PYTHON_VERSION=3.6.6
ARG OPEN_MPI_VERSION=4.0.1

RUN wget https://www.open-mpi.org/software/ompi/v4.0/downloads/openmpi-$OPEN_MPI_VERSION.tar.gz && \
    gunzip -c openmpi-$OPEN_MPI_VERSION.tar.gz | tar xf - && \
    cd openmpi-$OPEN_MPI_VERSION && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/home/.openmpi && \
    make all install && \
    cd .. && rm openmpi-$OPEN_MPI_VERSION.tar.gz && rm -rf openmpi-$OPEN_MPI_VERSION

ENV PATH="$PATH:/home/.openmpi/bin"
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/.openmpi/lib/"

RUN ompi_info --parsable --all | grep mpi_built_with_cuda_support:value

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
RUN conda install -c conda-forge awscli==1.16.210 opencv==4.0.1 && \
    conda install -y scikit-learn==0.21.2 \
                     pandas==0.25.0 \
                     pillow==5.4.1 \
                     h5py==2.9.0 \
                     requests==2.22.0 && \
    conda install pytorch==$PYTORCH_VERSION torchvision==$TORCHVISION_VERSION cpuonly -c pytorch && \
    conda clean -ya && \
    pip install --no-cache-dir --upgrade pip --trusted-host pypi.org --trusted-host && \
    ln -s /opt/conda/bin/pip /usr/local/bin/pip3

# Python won???t try to write .pyc or .pyo files on the import of source modules
# Force stdin, stdout and stderr to be totally unbuffered. Good for logging
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib" \
    PYTHONIOENCODING=UTF-8 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN pip install --no-cache-dir fastai==1.0.39

WORKDIR /

# Copy workaround script for incorrect hostname
COPY lib/changehostname.c /
COPY lib/start_with_right_hostname.sh /usr/local/bin/start_with_right_hostname.sh

RUN chmod +x /usr/local/bin/start_with_right_hostname.sh

COPY sagemaker_pytorch_container-1.2-py2.py3-none-any.whl /sagemaker_pytorch_container-1.2-py2.py3-none-any.whl
RUN pip install --no-cache-dir /sagemaker_pytorch_container-1.2-py2.py3-none-any.whl && \
    rm /sagemaker_pytorch_container-1.2-py2.py3-none-any.whl

ENV SAGEMAKER_TRAINING_MODULE sagemaker_pytorch_container.training:main

# Starts framework
ENTRYPOINT ["bash", "-m", "start_with_right_hostname.sh"]
CMD ["/bin/bash"]
