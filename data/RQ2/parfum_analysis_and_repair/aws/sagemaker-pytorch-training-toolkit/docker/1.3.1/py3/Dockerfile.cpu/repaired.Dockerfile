FROM ubuntu:16.04

LABEL maintainer="Amazon AI"

# Add arguments to achieve the version, python and url
ARG PYTHON_VERSION=3.6.6
ARG OPEN_MPI_VERSION=4.0.1

# Python won’t try to write .pyc or .pyo files on the import of source modules
# Force stdin, stdout and stderr to be totally unbuffered. Good for logging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONIOENCODING=UTF-8
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/opt/conda/lib"
ENV PATH=/opt/conda/bin:$PATH
ENV SAGEMAKER_TRAINING_MODULE=sagemaker_pytorch_container.training:main
ENV DGLBACKEND=pytorch

WORKDIR /

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
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
    software-properties-common \
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

# Copy workaround script for incorrect hostname
COPY changehostname.c /
COPY start_with_right_hostname.sh /usr/local/bin/start_with_right_hostname.sh
COPY sagemaker_pytorch_training.tar.gz /sagemaker_pytorch_training.tar.gz

RUN curl -f -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p /opt/conda \
 && rm ~/miniconda.sh \
 && /opt/conda/bin/conda install -y -c anaconda \
    python=$PYTHON_VERSION \
    numpy==1.16.4 \
    ipython==7.10.1 \
    mkl==2019.4 \
    mkl-include==2019.4 \
    cython==0.29.12 \
    typing==3.6.4 \
    "pyopenssl>=17.5.0" \
 && conda install -c conda-forge \
    awscli==1.17.7 \
    opencv==4.0.1 \
 && conda install -y \
    scikit-learn==0.21.2 \
    pandas==0.25.0 \
    Pillow==6.2.0 \
    h5py==2.9.0 \
    requests==2.22.0 \
 && conda install -c dglteam -y dgl==0.4.1 \
 && /opt/conda/bin/conda clean -ya \
 && conda clean -ya

# The following section uninstalls torch and torchvision before installing the
# custom versions from an S3 bucket. This will need to be removed in the future
RUN pip install --no-cache-dir --upgrade pip --trusted-host pypi.org --trusted-host \
 && ln -s /opt/conda/bin/pip /usr/local/bin/pip3 \
 && pip install --no-cache-dir -U \
    fastai==1.0.59 \
    scipy==1.2.2 \
    smdebug==0.5.0.post0 \
    sagemaker-experiments==0.1.3 \
    /sagemaker_pytorch_training.tar.gz \
 && pip install --no-cache-dir -U https://pytorch-aws.s3.amazonaws.com/pytorch-1.3.1/py3/cpu/torch-1.3.1-cp36-cp36m-manylinux1_x86_64.whl \
 && pip uninstall -y torchvision \
 && pip install --no-cache-dir -U \
    https://torchvision-build.s3.amazonaws.com/1.3.1/cpu/torchvision-0.4.2-cp36-cp36m-linux_x86_64.whl \
 && rm /sagemaker_pytorch_training.tar.gz

RUN chmod +x /usr/local/bin/start_with_right_hostname.sh

RUN curl -f -o /license.txt https://aws-dlc-licenses.s3.amazonaws.com/pytorch/license.txt

# Starts framework
ENTRYPOINT ["bash", "-m", "start_with_right_hostname.sh"]
CMD ["/bin/bash"]
