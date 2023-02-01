# This Dockerfile provides a starting point for a ROCm installation of
# MIOpen and tensorflow.
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
    rocm-dev rocm-libs rocm-utils rocm-cmake \
    rocfft miopen-hip miopengemm rocblas hipblas rocrand \
    rocm-profiler cxlactivitylogger && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Build HCC from source, cleanup the default HCC to avoid issue
#RUN rm -rf /opt/rocm/hcc-1.0 && rm -rf /opt/rocm/lib/*.bc
#RUN cd $HOME && git clone --recursive -b <> https://github.com/RadeonOpenCompute/hcc.git
#RUN cd $HOME && mkdir -p build.hcc && cd build.hcc && cmake -DCMAKE_BUILD_TYPE=Release ../hcc
#RUN cd $HOME/build.hcc && make -j $(nproc) && make package && dpkg -i hcc*.deb
#RUN ln -s /opt/rocm/hcc-1.0 /opt/rocm/hcc

# Build HIP from source
# The switch to rocm2.5 introduces failures on the rocm-xla CI path,
# Need the workaround for issue SWDEV-173477 to fix some of those failures
RUN cd $HOME && git clone -b roc-2.5.x-with-swdev-173477-workaround https://github.com/deven-amd/HIP.git
RUN cd $HOME/HIP && mkdir -p build && cd build && cmake .. && make package -j $(nproc) && dpkg -i ./hip*.deb

# Roll back OpenCL toolset to ROCm2.2 base
RUN cd $HOME && wget http://repo.radeon.com/rocm/apt/2.2/pool/main/r/rocm-opencl/rocm-opencl_1.2.0-2019030702_amd64.deb && \
    wget http://repo.radeon.com/rocm/apt/2.2/pool/main/r/rocm-opencl-dev/rocm-opencl-dev_1.2.0-2019030702_amd64.deb && \
    dpkg -i rocm-opencl*.deb && rm -rf rocm-rocm*.deb

# Set up paths
ENV HCC_HOME=$ROCM_PATH/hcc
ENV HIP_PATH=$ROCM_PATH/hip
ENV OPENCL_ROOT=$ROCM_PATH/opencl
ENV PATH="$HCC_HOME/bin:$HIP_PATH/bin:${PATH}"
ENV PATH="$ROCM_PATH/bin:${PATH}"
ENV PATH="$OPENCL_ROOT/bin:${PATH}"

# Add target file to help determine which device(s) to build for
RUN bash -c 'echo -e "gfx803\ngfx900\ngfx906" >> /opt/rocm/bin/target.lst'

# Build rocBLAS from source
#RUN cd $HOME && git clone -b <> https://github.com/ROCmSoftwarePlatform/rocBLAS.git && cd rocBLAS && ./install.sh -id
#RUN cd $HOME && git clone -b <>https://github.com/ROCmSoftwarePlatform/hipBLAS.git && cd hipBLAS && ./install.sh -id

# Build rocFFT from source
#RUN cd $HOME && git clone -b <> https://github.com/ROCmSoftwarePlatform/rocFFT.git && cd rocFFT && ./install.sh -id

# Build rocRAND from source
#RUN cd $HOME && git clone -b <> https://github.com/ROCmSoftwarePlatform/rocRAND.git && mkdir rocRAND/build && cd rocRAND/build && CXX=hcc cmake .. && make package -j $(nproc) && dpkg -i ./rocrand*.deb

# Build MIOpen from source
#RUN cd $HOME && git clone -b <> https://github.com/RadeonOpenCompute/rocm-cmake.git && cd $HOME/rocm-cmake && mkdir -p build && cd build && cmake .. && make package -j$(nproc) && dpkg -i ./rocm-cmake*.deb
#RUN cd $HOME && git clone -b <> https://github.com/RadeonOpenCompute/clang-ocl.git && cd $HOME/clang-ocl && mkdir -p build && cd build && cmake .. && make package -j$(nproc) && dpkg -i ./rocm-clang-ocl*.deb
#RUN cd $HOME && git clone -b <> https://github.com/ROCmSoftwarePlatform/MIOpenGEMM.git && cd $HOME/MIOpenGEMM && mkdir -p build && cd build && cmake .. && make package -j$(nproc) && dpkg -i ./miopengemm*.deb
#RUN cd $HOME && git clone -b <> https://github.com/ROCmSoftwarePlatform/MIOpen.git
#RUN cd $HOME/MIOpen && cmake -P install_deps.cmake && \
#    mkdir -p build && cd build && \
#    CXX=/opt/rocm/hcc/bin/hcc cmake -DMIOPEN_BACKEND=HIP -DCMAKE_PREFIX_PATH="/opt/rocm/hcc;/opt/rocm/hip" -D#CMAKE_CXX_FLAGS="-isystem /usr/include/x86_64-linux-gnu/" .. -DMIOPEN_MAKE_BOOST_PUBLIC=ON && \
#    make -j $(nproc) && make package && dpkg -i ./MIOpen*.deb

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

# Configure the build for our ROCm configuration.
ENV TF_NEED_ROCM 1

# This is a temporary workaround to fix Out-Of-Memory errors we are running into with XLA perf tests
# By default, HIP runtime "hides" 256MB from the TF Runtime, but with recent changes (update to ROCm2.3, dynamic loading of roc* libs, et al)
# it seems that we need to up the threshold slightly to 320MB
ENV HIP_HIDDEN_FREE_MEM=320
