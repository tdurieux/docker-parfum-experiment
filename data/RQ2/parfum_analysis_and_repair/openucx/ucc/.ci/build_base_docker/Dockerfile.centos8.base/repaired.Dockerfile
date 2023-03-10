ARG CUDA_VER='11.4.2'
FROM nvidia/cuda:${CUDA_VER}-devel-centos8
#==============================================================================
ARG NVIDIA_ROOT_DIR=/opt/nvidia
ENV SRC_DIR=${NVIDIA_ROOT_DIR}/src
ENV PKG_DIR=${NVIDIA_ROOT_DIR}/pkg
ENV BIN_DIR=${NVIDIA_ROOT_DIR}/bin
ENV WORKLOADS_DIR=${NVIDIA_ROOT_DIR}/workloads
ENV TORCH_UCC_GITHUB_URL=https://github.com/facebookresearch/torch_ucc.git
ENV TORCH_UCC_BRANCH=main
ENV CUDA_HOME=/usr/local/cuda
ENV UCX_GITHUB_URL=https://github.com/openucx/ucx.git
ENV UCX_BRANCH=master
ENV UCX_BUILD_TYPE=release-mt
ENV UCX_INSTALL_DIR=${BIN_DIR}/ucx/build-${UCX_BUILD_TYPE}
ENV UCC_INSTALL_DIR=${BIN_DIR}/ucc/build
#==============================================================================
RUN yum groupinstall -y \
    'Development Tools' \
    'Infiniband Support'
RUN yum config-manager --set-enabled powertools && yum install -y \
    numactl \
    numactl-devel \
    openmpi \
    openmpi-devel \
    openssh-server \
    protobuf-compiler \
    protobuf-devel \
    python36-devel \
    rdma-core-devel \
    vim \
    wget && rm -rf /var/cache/yum
# Remove old UCX
RUN rpm -e --nodeps ucx
ENV PATH=/usr/lib64/openmpi/bin:$PATH
RUN echo "export PATH=\"/usr/lib64/openmpi/bin:\$PATH\"" >> /etc/bashrc && \
    export LD_LIBRARY_PATH=\"/usr/lib64/openmpi/lib:\${LD_LIBRARY_PATH}\" >> /etc/bashrc
RUN cd /tmp && wget https://github.com/Kitware/CMake/releases/download/v3.20.4/cmake-3.20.4-linux-x86_64.sh && \
    chmod +x /tmp/cmake-3.20.4-linux-x86_64.sh && /tmp/cmake-3.20.4-linux-x86_64.sh --skip-license --prefix=/usr && \
    rm -f /tmp/cmake-3.20.4-linux-x86_64.sh
#==============================================================================
# Configure SSH
RUN mkdir -p /var/run/sshd && \
    cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new && \
    mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config && \
    ssh-keygen -A &&  \
    rm -f /run/nologin
#==============================================================================

#==============================================================================
RUN mkdir -p ${SRC_DIR} && \
    mkdir -p ${PKG_DIR} && \
    mkdir -p ${BIN_DIR} && \
    mkdir -p ${WORKLOADS_DIR}

RUN git clone ${TORCH_UCC_GITHUB_URL} ${SRC_DIR} && \
    cd ${SRC_DIR} && \
    git checkout ${TORCH_UCC_BRANCH}

RUN mkdir -p ${SRC_DIR}/ucx && \
    git clone --recursive ${UCX_GITHUB_URL} ${SRC_DIR}/ucx && \
    cd ${SRC_DIR}/ucx && \
    git checkout ${UCX_BRANCH}

COPY . ${SRC_DIR}/ucc
#==============================================================================
# Build UCX
RUN ${SRC_DIR}/ucc/.ci/scripts/build_ucx.sh
ENV PATH=${UCX_INSTALL_DIR}/bin:${PATH}
#==============================================================================
# Configure Python
RUN ${SRC_DIR}/ucc/.ci/scripts/configure_python.sh
#==============================================================================
# Install PyTorch
RUN ${SRC_DIR}/ucc/.ci/scripts/install_torch.sh
#==============================================================================
# Install workloads
WORKDIR ${WORKLOADS_DIR}
RUN git clone https://github.com/facebookresearch/dlrm.git && \
    cd ${WORKLOADS_DIR}/dlrm && \
    pip3 install --no-cache-dir -r ${WORKLOADS_DIR}/dlrm/requirements.txt && \
    pip3 install --no-cache-dir tensorboard
RUN git clone https://github.com/facebookresearch/param.git && \
    pip3 install --no-cache-dir -r ${WORKLOADS_DIR}/param/requirements.txt
