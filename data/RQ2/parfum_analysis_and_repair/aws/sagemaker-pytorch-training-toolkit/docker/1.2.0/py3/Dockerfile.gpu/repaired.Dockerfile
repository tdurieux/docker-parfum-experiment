FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu16.04

LABEL maintainer="Amazon AI"

LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

ENV HOROVOD_VERSION=0.16.4

RUN apt-get update && apt-get install -y  --allow-downgrades --allow-change-held-packages --no-install-recommends \
        build-essential \
        jq \
        ca-certificates \
        cmake \
        cuda-command-line-tools-10-0 \
        cuda-cublas-10-0 \
        cuda-cufft-10-0 \
        cuda-curand-10-0 \
        cuda-cusolver-10-0 \
        cuda-cusparse-10-0 \
        libglib2.0-0 \
        libgl1-mesa-glx \
        libsm6 \
        libxext6 \
        libxrender-dev \
        libgomp1 \
        libibverbs-dev \
        curl \
        git \
        wget \
        vim \
        build-essential \
        zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get remove -y cuda-cufft-dev-10-0 \
        cuda-curand-dev-10-0 \
        cuda-cusolver-dev-10-0 \
        cuda-npp-dev-10-0 \
        cuda-nvgraph-dev-10-0 \
        cuda-nvjpeg-dev-10-0 \
        cuda-nvrtc-dev-10-0

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

RUN ompi_info --parsable --all | grep mpi_built_with_cuda_support:value && \
    curl -f -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
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
	                              typing==3.6.4 \
	                              future==0.17.1 && \
	/opt/conda/bin/conda clean -ya
ENV PATH /opt/conda/bin:$PATH

RUN conda install -c pytorch magma-cuda100==2.5.1 && \
    conda install -c conda-forge awscli==1.16.210 opencv==4.0.1 && \
    conda install -y scikit-learn==0.21.2 \
                     pandas==0.25.0 \
                     pillow==5.4.1 \
                     h5py==2.9.0 \
                     requests==2.22.0 && \
    conda clean -ya

ARG TORCHVISION_VERSION=0.4.0
WORKDIR /opt/pytorch

ENV TORCH_CUDA_ARCH_LIST="3.5 5.2 6.0 6.1 7.0+PTX"
ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
ENV CMAKE_PREFIX_PATH="$(dirname $(which conda))/../"

RUN pip install --no-cache-dir https://pytorch-deep-learning-container.s3.amazonaws.com/torch-1.2.0-cp36-cp36m-linux_x86_64.whl
RUN pip install --no-cache-dir torchvision==$TORCHVISION_VERSION

WORKDIR /root

RUN /opt/conda/bin/conda config --set ssl_verify False && \
    pip install --no-cache-dir --upgrade pip --trusted-host pypi.org --trusted-host && \
    ln -s /opt/conda/bin/pip /usr/local/bin/pip3

# Install Horovod
RUN ldconfig /usr/local/cuda-10.0/targets/x86_64-linux/lib/stubs && \
    HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_PYTORCH=1 pip install --no-cache-dir horovod==${HOROVOD_VERSION} && \
    ldconfig

# Configure Open MPI and configure NCCL parameters
RUN mv /home/.openmpi/bin/mpirun /home/.openmpi/bin/mpirun.real && \
    echo '#!/bin/bash' > /home/.openmpi/bin/mpirun && \
    echo 'mpirun.real --allow-run-as-root "$@"' >> /home/.openmpi/bin/mpirun && \
    chmod a+x /home/.openmpi/bin/mpirun && \
    echo "hwloc_base_binding_policy = none" >> /home/.openmpi/etc/openmpi-mca-params.conf && \
    echo "rmaps_base_mapping_policy = slot" >> /home/.openmpi/etc/openmpi-mca-params.conf && \
    echo "btl_tcp_if_exclude = lo,docker0" >> /home/.openmpi/etc/openmpi-mca-params.conf && \
    echo NCCL_DEBUG=INFO >> /etc/nccl.conf && \
    echo NCCL_SOCKET_IFNAME=^docker0 >> /etc/nccl.conf

# Install OpenSSH for MPI to communicate between containers, Allow OpenSSH to talk to containers without asking for confirmation
RUN apt-get install -y --no-install-recommends openssh-client openssh-server && \
    mkdir -p /var/run/sshd && \
    cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new && \
    mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config && rm -rf /var/lib/apt/lists/*;

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

COPY dist/sagemaker_pytorch_container-1.2-py2.py3-none-any.whl /sagemaker_pytorch_container-1.2-py2.py3-none-any.whl
RUN pip install --no-cache-dir /sagemaker_pytorch_container-1.2-py2.py3-none-any.whl && \
    rm /sagemaker_pytorch_container-1.2-py2.py3-none-any.whl

ENV SAGEMAKER_TRAINING_MODULE sagemaker_pytorch_container.training:main

# Starts framework
ENTRYPOINT ["bash", "-m", "start_with_right_hostname.sh"]
CMD ["/bin/bash"]
