# The tag for the base image is: 10.1-cudnn7-devel-ubuntu16.04
FROM nvidia/cuda@sha256:4979db047661dc0003594fb20d37cce6d6c7e989252f4e3fb0beb39874a078e2

LABEL maintainer="Amazon AI"

# Add arguments to achieve the version, python and url
ARG PYTHON_VERSION=2.7
ARG OPEN_MPI_VERSION=4.0.1
ARG CUBLAS_VERSION=10.2.1.243-1_amd64

# Python won’t try to write .pyc or .pyo files on the import of source modules
# Force stdin, stdout and stderr to be totally unbuffered. Good for logging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib"
ENV PYTHONIOENCODING=UTF-8
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV HOROVOD_VERSION=0.16.4
ENV PATH="$PATH:/home/.openmpi/bin"
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/.openmpi/lib/"
ENV PATH /opt/conda/bin:$PATH
ENV TORCH_CUDA_ARCH_LIST="3.5 5.2 6.0 6.1 7.0+PTX"
ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
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

# CUBLAS compatible with CUDA 10.1 needs to be downloaded and installed.
# The apt-get package name has changed and using the new name (libcublas10) does
# not give control over the version that is changed. Version being used here is
# 10.2.1.243 compliant with CUDA version 10.1.243.
# CUBLAS versions: https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/libcublas10_${CUBLAS_VERSION}.deb \
 && dpkg -i libcublas10_${CUBLAS_VERSION}.deb \
 && apt-get install -f -y \
 && rm libcublas10_${CUBLAS_VERSION}.deb

# Copy workaround script for incorrect hostname
COPY changehostname.c /
COPY start_with_right_hostname.sh /usr/local/bin/start_with_right_hostname.sh
COPY sagemaker_pytorch_training.tar.gz /sagemaker_pytorch_training.tar.gz

RUN wget https://www.open-mpi.org/software/ompi/v4.0/downloads/openmpi-$OPEN_MPI_VERSION.tar.gz \
 && gunzip -c openmpi-$OPEN_MPI_VERSION.tar.gz | tar xf - \
 && cd openmpi-$OPEN_MPI_VERSION \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/home/.openmpi \
 && make all install \
 && cd .. \
 && rm openmpi-$OPEN_MPI_VERSION.tar.gz \
 && rm -rf openmpi-$OPEN_MPI_VERSION

RUN ompi_info --parsable --all | grep mpi_built_with_cuda_support:value \
 && curl -f -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p /opt/conda \
 && rm ~/miniconda.sh \
 && /opt/conda/bin/conda install -y anaconda \
    python=$PYTHON_VERSION \
    numpy==1.16.4 \
    ipython==5.8.0 \
    mkl==2019.4 \
    mkl-include==2019.4 \
    cython==0.29.12 \
    typing==3.7.4 \
    future==0.17.1 \
 && /opt/conda/bin/conda clean -ya

RUN conda install -c pytorch magma-cuda101==2.5.1 \
 && conda install -c conda-forge \
    awscli==1.17.7 \
    opencv==4.0.1 \
 && conda install -y \
    scikit-learn==0.20.3 \
    pandas==0.24.2 \
    Pillow==6.2.0 \
    h5py==2.9.0 \
    requests==2.22.0 \
 && pip install --no-cache-dir -U \
    scipy==1.2.2 \
    "spyder<4.0" \
    argparse \
 && pip uninstall -y QDarkStyle \
 && conda clean -ya

# The following section uninstalls torch and torchvision before installing the
# custom versions from an S3 bucket. This will need to be removed in the future
RUN /opt/conda/bin/conda config --set ssl_verify False \
 && pip install --no-cache-dir --upgrade pip --trusted-host pypi.org --trusted-host \
    /sagemaker_pytorch_training.tar.gz \
 && pip uninstall torch -y \
 && pip install -U --no-cache-dir \
    https://pytorch-aws.s3.amazonaws.com/pytorch-1.3.1/py2/gpu/torch-1.3.1-cp27-cp27mu-manylinux1_x86_64.whl \
 && pip uninstall -y torchvision \
 && pip install --no-cache-dir \
    https://torchvision-build.s3.amazonaws.com/1.3.1/gpu/torchvision-0.4.2-cp27-cp27mu-linux_x86_64.whl \
 && rm /sagemaker_pytorch_training.tar.gz

# Install Horovod
RUN ldconfig /usr/local/cuda-10.1/targets/x86_64-linux/lib/stubs \
 && HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_PYTORCH=1 \
    pip install --no-cache-dir horovod==${HOROVOD_VERSION} \
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

RUN chmod +x /usr/local/bin/start_with_right_hostname.sh

RUN curl -f -o /license.txt https://aws-dlc-licenses.s3.amazonaws.com/pytorch/license.txt

# Starts framework
ENTRYPOINT ["bash", "-m", "start_with_right_hostname.sh"]
CMD ["/bin/bash"]
