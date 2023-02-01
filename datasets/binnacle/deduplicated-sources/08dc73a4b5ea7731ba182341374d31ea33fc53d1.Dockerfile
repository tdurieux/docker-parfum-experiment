# This Dockerfile provides a starting point for a ROCm installation of 
# MIOpen and tensorflow.

# This Dockerfile uses a multi-stage build
# The first stage is to build the HCC, HIP and other tools we need for the TF build
# The second stage is to do the TF CI build itself
# The separation of stages allows to reduce the size of the final docker image
# by copying over only the packages built in the first stage over to the second one


###################################################
# Stage 1 : build the tools needed for the TF build
#     Note: experimental! hip-clang build/install
###################################################

FROM ubuntu:xenial

ARG DEB_ROCM_REPO=http://repo.radeon.com/rocm/apt/debian/
ARG ROCM_PATH=/opt/rocm

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /home/rocm-user
RUN mkdir -p $HOME

RUN apt update && apt install -y wget software-properties-common

# Add rocm repository
RUN apt-get clean all
RUN wget -qO - $DEB_ROCM_REPO/rocm.gpg.key | apt-key add -
RUN sh -c  "echo deb [arch=amd64] $DEB_ROCM_REPO xenial main > /etc/apt/sources.list.d/rocm.list"

# Install misc pkgs
RUN apt-get update --allow-insecure-repositories && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential \
  clang-3.8 \
  clang-format-3.8 \
  clang-tidy-3.8 \
  cmake \
  cmake-qt-gui \
  ssh \
  curl \
  apt-utils \
  pkg-config \
  g++-multilib \
  git \
  libunwind-dev \
  libfftw3-dev \
  libelf-dev \
  libncurses5-dev \
  libpthread-stubs0-dev \
  vim \
  gfortran \
  libboost-program-options-dev \
  libssl-dev \
  libboost-dev \
  libboost-system-dev \
  libboost-filesystem-dev \
  rpm \
  libnuma-dev \
  pciutils \
  virtualenv \
  python-pip \
  python3-pip \
  libxml2 \
  libxml2-dev \
  wget && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Install rocm pkgs
RUN apt-get update --allow-insecure-repositories && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --allow-unauthenticated \
    rocm-dev rocm-libs rocm-utils \
    rocm-profiler cxlactivitylogger && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install packages needed for this image
RUN apt-get update && apt-get install -y sudo python rpm git mercurial libxml2 libxml2-dev

# Build and install LLVM with Clang and LLD. Checkout clang and lld into llvm/tools/ dir.
RUN cd $HOME && git clone --single-branch -b amd-common https://github.com/RadeonOpenCompute/llvm.git
WORKDIR $HOME/llvm/tools
RUN git clone --single-branch -b amd-common http://github.com/radeonopencompute/clang.git
RUN git clone --single-branch -b amd-common https://github.com/RadeonOpenCompute/lld.git
RUN mkdir $HOME/llvm/build
WORKDIR $HOME/llvm/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/opt/rocm/llvm -DLLVM_TARGETS_TO_BUILD="AMDGPU;X86" .. && make -j$(nproc) && sudo make -j$(nproc) install

# Build and install ROCDL
WORKDIR $HOME
RUN git clone --single-branch -b master https://github.com/RadeonOpenCompute/ROCm-Device-Libs
RUN mkdir -p $HOME/ROCm-Device-Libs/build
WORKDIR $HOME/ROCm-Device-Libs/build
ENV LLVM_BUILD=$HOME/llvm/build
RUN CC=$LLVM_BUILD/bin/clang cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_DIR=$LLVM_BUILD -DAMDHSACOD=/opt/rocm/hsa/bin/x86_64/amdhsacod .. && make -j$(nproc) package && sudo dpkg -i ./*.deb

# Build and install comgr
WORKDIR $HOME
RUN git clone --single-branch -b master https://github.com/RadeonOpenCompute/ROCm-CompilerSupport.git
RUN mkdir $HOME/ROCm-CompilerSupport/build
WORKDIR $HOME/ROCm-CompilerSupport/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="/opt/rocm/llvm;/opt/rocm/lib" ../lib/comgr && make -j$(nproc) && cpack -G DEB && sudo dpkg -i ./*.deb

# Build and install HCC
WORKDIR $HOME
RUN git clone --recursive --single-branch -b clang_tot_upgrade https://github.com/RadeonOpenCompute/hcc.git
RUN mkdir -p $HOME/hcc/build
WORKDIR $HOME/hcc/build
RUN cmake -DCMAKE_BUILD_TYPE=Release .. && make -j$(nproc) package && sudo dpkg -i ./*.deb

# Build and install HIP-HCC-RT
WORKDIR $HOME
RUN git clone --single-branch -b master https://github.com/ROCm-Developer-Tools/HIP
RUN mkdir $HOME/HIP/build
WORKDIR $HOME/HIP/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DHIP_COMPILER=clang .. && make -j$(nproc) package && sudo dpkg -i ./*.deb

# Set up environment for hip-clang
ENV HIP_CLANG_PATH=/opt/rocm/llvm/bin
ENV DEVICE_LIB_PATH=/opt/rocm/lib
ENV HIP_CLANG_HCC_COMPAT_MODE=1

# Workaround : build MIOpen from source using fork of the public repo with the temporary fix for issue #1061 ($HOME env not set)
RUN sudo apt-get install -y wget unzip libssl-dev libboost-dev libboost-system-dev libboost-filesystem-dev

RUN cd $HOME && git clone https://github.com/RadeonOpenCompute/rocm-cmake.git
RUN cd $HOME/rocm-cmake && mkdir build && cd build && cmake .. && sudo make package -j$(nproc) && sudo dpkg -i ./rocm-cmake*.deb

RUN cd $HOME && git clone --single-branch -b master https://github.com/ROCmSoftwarePlatform/MIOpenGEMM.git
RUN cd $HOME/MIOpenGEMM && mkdir build && cd build && cmake .. && sudo make package -j$(nproc) && sudo dpkg -i ./miopengemm*.deb

RUN cd $HOME && mkdir half && cd half && sudo wget https://downloads.sourceforge.net/project/half/half/1.12.0/half-1.12.0.zip && sudo unzip *.zip

# Build rocBLAS from source
RUN cd $HOME && git clone --single-branch -b master-rocm-2.3 https://github.com/ROCmSoftwarePlatform/rocBLAS.git && cd rocBLAS && ./install.sh -id --hip-clang
RUN cd $HOME && git clone --single-branch -b master-rocm-2.3 https://github.com/ROCmSoftwarePlatform/hipBLAS.git && cd hipBLAS && ./install.sh -id

# Build rocFFT from source
RUN cd $HOME && git clone --single-branch -b master https://github.com/ROCmSoftwarePlatform/rocFFT.git && cd rocFFT && ./install.sh -id --hip-clang

# Build rocRAND from source
RUN cd $HOME && git clone --single-branch -b master-rocm-2.3 https://github.com/ROCmSoftwarePlatform/rocRAND.git && mkdir rocRAND/build && cd rocRAND/build && CXX=/opt/rocm/hip/bin/hipcc cmake .. && make package -j $(nproc) && dpkg -i ./rocrand*.deb

RUN cd $HOME && git clone --single-branch -b master https://github.com/ROCmSoftwarePlatform/MIOpen.git
RUN cd $HOME/MIOpen && mkdir build && cd build && \
  CXX=/opt/rocm/hip/bin/hipcc cmake \
    -DMIOPEN_BACKEND=HIP \
    -DCMAKE_PREFIX_PATH="/opt/rocm/hcc;/opt/rocm/hip" \
    -DCMAKE_CXX_FLAGS="-isystem /usr/include/x86_64-linux-gnu/ -I/opt/rocm/hcc/include" \
    -DHALF_INCLUDE_DIR=$HOME/half/include \
    -DCMAKE_BUILD_TYPE=Release \
    .. && sudo make package -j$(nproc)

###########################
# Stage 2 : do the TF build
###########################

FROM ubuntu:xenial
MAINTAINER Jeff Poznanovic <jeffrey.poznanovic@amd.com>

ARG DEB_ROCM_REPO=http://repo.radeon.com/rocm/apt/debian/
ARG ROCM_PATH=/opt/rocm

ENV DEBIAN_FRONTEND noninteractive
ENV TF_NEED_ROCM 1
ENV HOME /root/
RUN apt update && apt install -y wget software-properties-common 

# Add rocm repository
RUN apt-get clean all
RUN wget -qO - $DEB_ROCM_REPO/rocm.gpg.key | apt-key add -
RUN sh -c  "echo deb [arch=amd64] $DEB_ROCM_REPO xenial main > /etc/apt/sources.list.d/rocm.list"

# Install misc pkgs
RUN apt-get update --allow-insecure-repositories && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential \
  clang-3.8 \
  clang-format-3.8 \
  clang-tidy-3.8 \
  cmake \
  cmake-qt-gui \
  ssh \
  curl \
  apt-utils \
  pkg-config \
  g++-multilib \
  git \
  libunwind-dev \
  libfftw3-dev \
  libelf-dev \
  libncurses5-dev \
  libpthread-stubs0-dev \
  vim \
  gfortran \
  libboost-program-options-dev \
  libssl-dev \
  libboost-dev \
  libboost-system-dev \
  libboost-filesystem-dev \
  rpm \
  libnuma-dev \
  pciutils \
  virtualenv \
  python-pip \
  python3-pip \
  libxml2 \
  libxml2-dev \
  wget && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Install rocm pkgs
RUN apt-get update --allow-insecure-repositories && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --allow-unauthenticated \
    rocm-dev rocm-libs rocm-utils \
    rocm-profiler cxlactivitylogger && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# COPY and install llvm built in the previous stage
RUN rm -rf /opt/rocm/llvm && mkdir -p /opt/rocm/llvm
COPY --from=tool_builder /opt/rocm/llvm/ /opt/rocm/llvm/

# COPY and install the ROCDL package built in the previous stage
RUN mkdir -p $HOME/pkgs/ROCm-Device-Libs
COPY --from=tool_builder /home/rocm-user/ROCm-Device-Libs/build/*.deb $HOME/pkgs/ROCm-Device-Libs/
RUN cd $HOME/pkgs/ROCm-Device-Libs && dpkg -i *.deb

# COPY and install the comgr package built in the previous stage
RUN mkdir -p $HOME/pkgs/ROCm-CompilerSupport
COPY --from=tool_builder /home/rocm-user/ROCm-Device-Libs/build/*.deb $HOME/pkgs/ROCm-CompilerSupport/
RUN cd $HOME/pkgs/ROCm-CompilerSupport && dpkg -i *.deb

# COPY and install the hcc package built in the previous stage
RUN mkdir -p $HOME/pkgs/hcc
COPY --from=tool_builder /home/rocm-user/hcc/build/*.deb $HOME/pkgs/hcc/
RUN cd $HOME/pkgs/hcc && dpkg -i *.deb

# COPY and install the HIP package built in the previous stage
RUN mkdir -p $HOME/pkgs/HIP
COPY --from=tool_builder /home/rocm-user/HIP/build/*.deb $HOME/pkgs/HIP/
RUN cd $HOME/pkgs/HIP && dpkg -i *.deb

# COPY and install the rocBLAS package built in the previous stage
RUN mkdir -p $HOME/pkgs/rocBLAS
COPY --from=tool_builder /home/rocm-user/rocBLAS/build/release/*.deb $HOME/pkgs/rocBLAS/
RUN cd $HOME/pkgs/rocBLAS && dpkg -i *.deb

# COPY and install the hipBLAS package built in the previous stage
RUN mkdir -p $HOME/pkgs/hipBLAS
COPY --from=tool_builder /home/rocm-user/hipBLAS/build/*.deb $HOME/pkgs/hipBLAS/
RUN cd $HOME/pkgs/hipBLAS && dpkg -i *.deb

# COPY and install the rocFFT package built in the previous stage
RUN mkdir -p $HOME/pkgs/rocFFT
COPY --from=tool_builder /home/rocm-user/rocFFT/build/*.deb $HOME/pkgs/rocFFT/
RUN cd $HOME/pkgs/rocFFT && dpkg -i *.deb

# COPY and install the rocRAND package built in the previous stage
RUN mkdir -p $HOME/pkgs/rocRAND
COPY --from=tool_builder /home/rocm-user/rocBLAS/build/*.deb $HOME/pkgs/rocRAND/
RUN cd $HOME/pkgs/rocRAND && dpkg -i *.deb

# COPY and install the MIOpenGEMM package built in the previous stage
RUN mkdir -p $HOME/pkgs/MIOpenGEMM
COPY --from=tool_builder /home/rocm-user/MIOpenGEMM/build/*.deb $HOME/pkgs/MIOpenGEMM/
RUN cd $HOME/pkgs/MIOpenGEMM && dpkg -i *.deb

# COPY and install the MIOpen package built in the previous stage
RUN mkdir -p $HOME/pkgs/MIOpen
COPY --from=tool_builder /home/rocm-user/MIOpen/build/*.deb $HOME/pkgs/MIOpen/
RUN cd $HOME/pkgs/MIOpen && dpkg -i *.deb

ENV HCC_HOME=$ROCM_PATH/hcc
ENV HIP_PATH=$ROCM_PATH/hip
ENV OPENCL_ROOT=$ROCM_PATH/opencl
ENV PATH="$HCC_HOME/bin:$HIP_PATH/bin:${PATH}"
ENV PATH="$ROCM_PATH/bin:${PATH}"
ENV PATH="$OPENCL_ROOT/bin:${PATH}"

# Add target file to help determine which device(s) to build for
RUN bash -c 'echo -e "gfx803\ngfx900\ngfx906" >> /opt/rocm/bin/target.lst'

# Set up environment for hip-clang
ENV HIP_CLANG_PATH=/opt/rocm/llvm/bin
ENV DEVICE_LIB_PATH=/opt/rocm/lib

# Copy and run the install scripts.
COPY install/*.sh /install/
ARG DEBIAN_FRONTEND=noninteractive
RUN /install/install_bootstrap_deb_packages.sh
RUN add-apt-repository -y ppa:openjdk-r/ppa && \
    add-apt-repository -y ppa:george-edison55/cmake-3.x
RUN /install/install_deb_packages.sh
RUN /install/install_pip_packages.sh
RUN /install/install_bazel.sh
RUN /install/install_golang.sh

# Set up the master bazelrc configuration file.
COPY install/.bazelrc /etc/bazel.bazelrc

# Configure the build for our CUDA configuration.
ENV TF_NEED_ROCM 1

