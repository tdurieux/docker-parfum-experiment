FROM ubuntu:16.04

LABEL maintainer="Amazon AI"

# Add arguments to achieve the version, python and url
ARG PYTHON_VERSION=2.7
ARG OPEN_MPI_VERSION=4.0.1

# See http://bugs.python.org/issue19846
# Python won’t try to write .pyc or .pyo files on the import of source modules
# Force stdin, stdout and stderr to be totally unbuffered. Good for logging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib"
ENV PYTHONIOENCODING=UTF-8
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV PATH=/opt/conda/bin:$PATH
ENV SAGEMAKER_TRAINING_MODULE=sagemaker_pytorch_container.training:main

WORKDIR /

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    git \
    jq \
    libglib2.0-0 \
    libgl1-mesa-glx \
    libsm6 \
    libxext6 \
    libxrender-dev \
    vim \
    wget \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

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

RUN curl -f -L -o ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p /opt/conda \
 && rm ~/miniconda.sh \
 && /opt/conda/bin/conda install -y -c anaconda \
    python=$PYTHON_VERSION \
    numpy==1.16.4 \
    ipython==5.8.0 \
    mkl==2019.4 \
    mkl-include==2019.4 \
    cython==0.29.12 \
    typing==3.7.4 && \
    /opt/conda/bin/conda clean -ya

RUN conda install -c conda-forge \
    opencv==4.0.1 \
 && conda install -y \
    scikit-learn==0.20.3 \
    pandas==0.24.2 \
    Pillow==6.2.0 \
    h5py==2.9.0 \
    requests==2.22.0 \
 && conda clean -ya \
 && pip install --no-cache-dir --upgrade pip --trusted-host pypi.org --trusted-host

# Copy workaround script for incorrect hostname
COPY changehostname.c /
COPY start_with_right_hostname.sh /usr/local/bin/start_with_right_hostname.sh

# The following section uninstalls torch and torchvision before installing the
# custom versions from an S3 bucket. This will need to be removed in the future
RUN pip install --no-cache-dir \
    awscli \
    scipy==1.2.2 \
    sphinxcontrib-websupport==1.1.2 \
    future \
    "sagemaker-pytorch-training<2" \
 && pip uninstall -y torch \
 && pip install -U --no-cache-dir https://pytorch-aws.s3.amazonaws.com/pytorch-1.4.0/py2/cpu/torch-1.4.0-cp27-cp27mu-manylinux1_x86_64.whl \
 && pip uninstall -y torchvision \
 && pip install --no-cache-dir \
    https://torchvision-build.s3.amazonaws.com/1.4.0/py2/cpu/torchvision-0.5.0%2Bcpu-cp27-cp27mu-linux_x86_64.whl

WORKDIR /

RUN chmod +x /usr/local/bin/start_with_right_hostname.sh

RUN curl -f -o /license.txt https://aws-dlc-licenses.s3.amazonaws.com/pytorch-1.4.0/license.txt

# fix safety issues
RUN pip install --no-cache-dir pillow==6.2.2 urllib3==1.25.8

# Starts framework
ENTRYPOINT ["bash", "-m", "start_with_right_hostname.sh"]
CMD ["/bin/bash"]
