# The tag for the base image is: 10.1-cudnn7-devel-ubuntu16.04
FROM nvidia/cuda@sha256:4979db047661dc0003594fb20d37cce6d6c7e989252f4e3fb0beb39874a078e2

LABEL maintainer="Amazon AI"

ARG PYTHON_VERSION=3.6.6
ARG OPEN_MPI_VERSION=4.0.1
ARG CUBLAS_VERSION=10.2.1.243-1_amd64

# Python won’t try to write .pyc or .pyo files on the import of source modules
# Force stdin, stdout and stderr to be totally unbuffered. Good for logging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/opt/conda/lib"
ENV PYTHONIOENCODING=UTF-8
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH
ENV TORCH_CUDA_ARCH_LIST="3.5 5.2 6.0 6.1 7.0+PTX"
ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
ENV HOROVOD_VERSION=0.16.4
ENV DGLBACKEND=pytorch
ENV CMAKE_PREFIX_PATH="$(dirname $(which conda))/../"
ENV SAGEMAKER_TRAINING_MODULE=sagemaker_pytorch_container.training:main

RUN apt-get update \
 && apt-get install -y  --allow-downgrades --allow-change-held-packages --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    cuda-command-line-tools-10-1 \
    cuda-cufft-10-1 \
    cuda-curand-10-1 \
    cuda-cusolver-10-1 \
    cuda-cusparse-10-1 \
    curl \
    git \
    jq \
    libglib2.0-0 \
    libgl1-mesa-glx \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    libibverbs-dev \
    libhwloc-dev \
    libnuma1 \
    libnuma-dev \
    vim \
    wget \
    zlib1g-dev \
 && apt-get remove -y cuda-cufft-dev-10-1 \
    cuda-curand-dev-10-1 \
    cuda-cusolver-dev-10-1 \
    cuda-npp-dev-10-1 \
    cuda-nvgraph-dev-10-1 \
    cuda-nvjpeg-dev-10-1 \
    cuda-nvrtc-dev-10-1 && rm -rf /var/lib/apt/lists/*;

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/libcublas10_${CUBLAS_VERSION}.deb \
 && dpkg -i libcublas10_${CUBLAS_VERSION}.deb \
 && apt-get install -f -y \
 && rm libcublas10_${CUBLAS_VERSION}.deb

RUN wget https://www.open-mpi.org/software/ompi/v4.0/downloads/openmpi-$OPEN_MPI_VERSION.tar.gz \
 && gunzip -c openmpi-$OPEN_MPI_VERSION.tar.gz | tar xf - \
 && cd openmpi-$OPEN_MPI_VERSION \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/home/.openmpi \
 && make all install \
 && cd .. \
 && rm openmpi-$OPEN_MPI_VERSION.tar.gz \
 && rm -rf openmpi-$OPEN_MPI_VERSION

ENV PATH="$PATH:/home/.openmpi/bin"
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/.openmpi/lib/"

RUN ompi_info --parsable --all | grep mpi_built_with_cuda_support:value \
 && curl -f -L -o ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
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
    future==0.17.1 \
    "pyopenssl>=17.5.0" \
 && conda install -c dglteam -y dgl-cuda10.1==0.4.1 \
 && /opt/conda/bin/conda clean -ya

RUN conda install -c pytorch magma-cuda101==2.5.1 \
 && conda install -c conda-forge \
    opencv==4.0.1 \
 && conda install -y scikit-learn==0.21.2 \
    pandas==0.25.0 \
    Pillow==6.2.0 \
    h5py==2.9.0 \
    requests==2.22.0 \
 && conda clean -ya

WORKDIR /opt/pytorch

# Copy workaround script for incorrect hostname
COPY changehostname.c /
COPY start_with_right_hostname.sh /usr/local/bin/start_with_right_hostname.sh

WORKDIR /root

RUN /opt/conda/bin/conda config --set ssl_verify False \
 && pip install --no-cache-dir --upgrade pip --trusted-host pypi.org --trusted-host \
 && ln -s /opt/conda/bin/pip /usr/local/bin/pip3

# The following section uninstalls torch and torchvision before installing the
# custom versions from an S3 bucket. This will need to be removed in the future
RUN pip install \
    --no-cache-dir smdebug==0.7.2 \
    sagemaker==1.50.17 \
    sagemaker-experiments==0.1.7 \
    --no-cache-dir fastai==1.0.59 \
    awscli \
    scipy==1.2.2 \
 && pip install --no-cache-dir -U https://pytorch-aws.s3.amazonaws.com/pytorch-1.4.0/py3/gpu/torch-1.4.0-cp36-cp36m-manylinux1_x86_64.whl \
 && pip uninstall -y torchvision \
 && pip install --no-cache-dir -U \
    https://torchvision-build.s3.amazonaws.com/1.4.0/py3/gpu/torchvision-0.5.0-cp36-cp36m-linux_x86_64.whl

# Install Horovod
RUN ldconfig /usr/local/cuda-10.1/targets/x86_64-linux/lib/stubs \
 && HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_PYTORCH=1 pip install --no-cache-dir horovod==${HOROVOD_VERSION} \
 && ldconfig

# Configure Open MPI and configure NCCL parameters
RUN mv /home/.openmpi/bin/mpirun /home/.openmpi/bin/mpirun.real \
 && echo '#!/bin/bash' > /home/.openmpi/bin/mpirun \
 && echo 'mpirun.real --allow-run-as-root "$@"' >> /home/.openmpi/bin/mpirun \
 && chmod a+x /home/.openmpi/bin/mpirun \
 && echo "hwloc_base_binding_policy = none" >> /home/.openmpi/etc/openmpi-mca-params.conf \
 && echo "rmaps_base_mapping_policy = slot" >> /home/.openmpi/etc/openmpi-mca-params.conf \
 && echo "btl_tcp_if_exclude = lo,docker0" >> /home/.openmpi/etc/openmpi-mca-params.conf \
 && echo NCCL_DEBUG=INFO >> /etc/nccl.conf \
 && echo NCCL_SOCKET_IFNAME=^docker0 >> /etc/nccl.conf

# Install OpenSSH for MPI to communicate between containers, Allow OpenSSH to talk to containers without asking for confirmation
RUN apt-get install -y --no-install-recommends openssh-client openssh-server \
 && mkdir -p /var/run/sshd \
 && cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new \
 && echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new \
 && mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config && rm -rf /var/lib/apt/lists/*;

WORKDIR /

RUN pip install --no-cache-dir "sagemaker-pytorch-training<2"

RUN chmod +x /usr/local/bin/start_with_right_hostname.sh

RUN curl -f -o /license.txt https://aws-dlc-licenses.s3.amazonaws.com/pytorch-1.4.0/license.txt

# fix safety issues
RUN pip install --no-cache-dir pillow==7.1.0

# Starts framework
ENTRYPOINT ["bash", "-m", "start_with_right_hostname.sh"]
CMD ["/bin/bash"]
