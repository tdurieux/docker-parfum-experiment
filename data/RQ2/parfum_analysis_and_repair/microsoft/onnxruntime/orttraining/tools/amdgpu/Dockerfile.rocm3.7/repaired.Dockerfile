FROM rocm/tensorflow:rocm3.7-tf2.1-dev

RUN curl -f https://bazel.build/bazel-release.pub.gpg | apt-key add -
RUN cat /dev/null > /etc/apt/sources.list.d/rocm.list
RUN echo 'deb [arch=amd64] http://repo.radeon.com/rocm/apt/3.7/ xenial main' | tee /etc/apt/sources.list.d/rocm.list

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential autotools-dev \
    make git curl vim wget rsync jq openssh-server openssh-client sudo \
    iputils-ping net-tools ethtool libcap2 \
    automake autoconf libtool flex doxygen \
    perl lsb-release iproute2 pciutils graphviz \
    bc tar git bash pbzip2 pv bzip2 cabextract \
    g++ gcc \
    && apt-get autoremove && rm -rf /var/lib/apt/lists/*;

# sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Labels for the docker
LABEL description="This docker sets up the environment to run ORT Training with AMD GPU"

# CMake
ENV CMAKE_VERSION=3.18.2
RUN cd /usr/local && \
    wget -q -O - https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz | tar zxf -
ENV PATH=/usr/local/cmake-${CMAKE_VERSION}-Linux-x86_64/bin:${PATH}

# WORKSPACE_DIR
ENV WORKSPACE_DIR=/workspace
RUN mkdir -p $WORKSPACE_DIR
WORKDIR $WORKSPACE_DIR

# Infiniband setup, openmpi installed under /usr/mpi/gcc/openmpi-4.0.4rc3 doesn't support multi-thread
ENV MOFED_VERSION=5.1-0.6.6.0
ENV MOFED_OS=ubuntu18.04
ENV MOFED_FILENAME=MLNX_OFED_LINUX-${MOFED_VERSION}-${MOFED_OS}-x86_64
RUN curl -fSsL https://www.mellanox.com/downloads/ofed/MLNX_OFED-${MOFED_VERSION}/${MOFED_FILENAME}.tgz | tar -zxpf -
RUN cd MLNX_OFED_LINUX-${MOFED_VERSION}-${MOFED_OS}-x86_64 && \
    ./mlnxofedinstall --force --user-space-only --without-fw-update --hpc && \
    cd .. && \
    rm -r MLNX_OFED_LINUX-${MOFED_VERSION}-${MOFED_OS}-x86_64

# install miniconda (comes with python 3.7 default)
ARG CONDA_VERSION=4.7.10
ARG CONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh
RUN curl -fSsL --insecure ${CONDA_URL} -o install-conda.sh &&\
    /bin/bash ./install-conda.sh -b -p /opt/conda &&\
    /opt/conda/bin/conda clean -ya
ENV PATH=/opt/conda/bin:${PATH}

ARG NUMPY_VERSION=1.18.5
ARG ONNX_VERSION=1.7.0
RUN conda install -y \
        numpy=${NUMPY_VERSION} \
        cmake \
        ninja \
        pyyaml \
        cffi \
        setuptools \
    && pip install --no-cache-dir wheel tqdm boto3 requests six ipdb h5py html2text nltk progressbar \
        git+https://github.com/NVIDIA/dllogger \
        onnx=="${ONNX_VERSION}"

# GITHUB_DIR
ENV GITHUB_DIR=$WORKSPACE_DIR/github
RUN mkdir -p $GITHUB_DIR

# UCX
WORKDIR $GITHUB_DIR
RUN apt-get -y update && apt-get -y --no-install-recommends install libnuma-dev && rm -rf /var/lib/apt/lists/*;
ARG UCX_VERSION=1.9.0-rc3
ENV UCX_DIR=$WORKSPACE_DIR/ucx-$UCX_VERSION
RUN git clone https://github.com/openucx/ucx.git \
  && cd ucx \
  && git checkout v$UCX_VERSION \
  && ./autogen.sh \
  && mkdir build \
  && cd build \
  && ../contrib/configure-opt --prefix=$UCX_DIR --without-rocm --without-knem --without-cuda \
  && make -j"$(nproc)" \
  && make install

# OpenMPI
# note: require --enable-orterun-prefix-by-default for Azure machine learning compute
# note: disable verbs as we use ucx middleware and don't want btl openib warnings
WORKDIR $GITHUB_DIR
ARG OPENMPI_BASEVERSION=4.0
ARG OPENMPI_VERSION=${OPENMPI_BASEVERSION}.5
ENV OPENMPI_DIR=$WORKSPACE_DIR/openmpi-${OPENMPI_VERSION}
RUN git clone --recursive https://github.com/open-mpi/ompi.git \
  && cd ompi \
  && git checkout v$OPENMPI_VERSION \
  && ./autogen.pl \
  && mkdir build \
  && cd build \
  && ../configure --prefix=$OPENMPI_DIR --with-ucx=$UCX_DIR --without-verbs \
                  --enable-mpirun-prefix-by-default --enable-orterun-prefix-by-default \
                  --enable-mca-no-build=btl-uct --disable-mpi-fortran \
  && make -j"$(nproc)" \
  && make install \
  && ldconfig \
  && test -f ${OPENMPI_DIR}/bin/mpic++

ENV PATH=$OPENMPI_DIR/bin:${PATH}
ENV LD_LIBRARY_PATH=$OPENMPI_DIR/lib:${LD_LIBRARY_PATH}

# Create a wrapper for OpenMPI to allow running as root by default
RUN mv $OPENMPI_DIR/bin/mpirun $OPENMPI_DIR/bin/mpirun.real && \
    echo '#!/bin/bash' > $OPENMPI_DIR/bin/mpirun && \
    echo 'mpirun.real --allow-run-as-root "$@"' >> $OPENMPI_DIR/bin/mpirun && \
    chmod a+x $OPENMPI_DIR/bin/mpirun

# install mpi4py (be sure to link existing /opt/openmpi-xxx)
RUN CC=mpicc MPICC=mpicc pip --no-cache-dir install mpi4py --no-binary mpi4py

ARG CACHE_DATA=2020-12-06

# ONNX Runtime
WORKDIR $GITHUB_DIR
ENV ORT_DIR=$GITHUB_DIR/onnxruntime
RUN git clone --recursive https://github.com/microsoft/onnxruntime.git \
  && cd onnxruntime \
  && python3 tools/ci_build/build.py \
    --cmake_extra_defines ONNXRUNTIME_VERSION=`cat ./VERSION_NUMBER` \
    --build_dir build \
    --config Release \
    --parallel \
    --skip_tests \
    --build_wheel \
    --use_rocm --rocm_home /opt/rocm \
    --mpi_home $OPENMPI_DIR \
    --nccl_home /opt/rocm \
	--enable_training \
  && test -f $ORT_DIR/build/Release/onnxruntime_training_bert \
  && pip install --no-cache-dir $ORT_DIR/build/Release/dist/*.whl \
  && ldconfig

# ONNX Runtime Training Examples
WORKDIR $GITHUB_DIR
RUN git clone -b wezhan/amdgpu https://github.com/microsoft/onnxruntime-training-examples.git \
  && cd onnxruntime-training-examples \
  && git clone --no-checkout https://github.com/NVIDIA/DeepLearningExamples.git \
  && cd DeepLearningExamples \
  && git checkout cf54b787 \
  && cd .. \
  && mv DeepLearningExamples/PyTorch/LanguageModeling/BERT/ ${WORKSPACE_DIR} \
  && rm -rf DeepLearningExamples \
  && cp -r ./nvidia-bert/ort_addon/* ${WORKSPACE_DIR}/BERT

ENV BERT_DIR=${WORKSPACE_DIR}/BERT

# OpenBLAS
WORKDIR $GITHUB_DIR
ARG OpenBLAS_VERSION=0.3.10
ENV OpenBLAS_DIR=$WORKSPACE_DIR/OpenBLAS-${OpenBLAS_VERSION}
RUN git clone https://github.com/xianyi/OpenBLAS.git \
  && cd OpenBLAS \
  && git checkout v$OpenBLAS_VERSION \
  && make TARGET=ZEN \
  && make install PREFIX=$OpenBLAS_DIR

# PyTorch
RUN pip install --no-cache-dir pyyaml
RUN for fn in $(find /opt/rocm/ -name \*.cmake ); do sed --in-place='~' 's/find_dependency(hip)/find_dependency(HIP)/' $fn ; done
WORKDIR $GITHUB_DIR
# ARG PYTORCH_VERSION=1.6.0
# RUN git clone --recursive https://github.com/pytorch/pytorch.git \
#   && cd pytorch \
#   && git checkout v$PYTORCH_VERSION \
#   && git submodule update --recursive \
#   && python3 tools/amd_build/build_amd.py \
#   && OpenBLAS_HOME=$OpenBLAS_DIR BLAS="OpenBLAS" RCCL_DIR=/opt/rocm/rccl/lib/cmake/rccl/ hip_DIR=/opt/rocm/hip/cmake/ PYTORCH_ROCM_ARCH=gfx906 USE_ROCM=ON USE_CUDA=OFF BUILD_CAFFE2_OPS=0 BUILD_TEST=0 python3 setup.py install

# Enable ssh access without password needed
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -i 's/#StrictModes yes/StrictModes no/g' /etc/ssh/sshd_config
RUN sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
RUN sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/g' /etc/ssh/sshd_config

# Start or Restart sshd service
ENTRYPOINT service ssh restart && /bin/bash

# Add model and scripts
ADD model ${WORKSPACE_DIR}/model
ADD script ${WORKSPACE_DIR}/script
RUN chmod a+x ${WORKSPACE_DIR}/script/run_bert.sh

# add locale en_US.UTF-8
RUN apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8

# Workaround an issue in AMD compiler which generates poor GPU ISA
# when the type of kernel parameter is a structure and “pass-by-value” is used
ENV HSA_NO_SCRATCH_RECLAIM=1

# Distributed training related environment variables
ENV HSA_FORCE_FINE_GRAIN_PCIE=1
ENV NCCL_DEBUG=INFO
# ENV NCCL_DEBUG_SUBSYS=INIT,COLL

WORKDIR ${WORKSPACE_DIR}/script
