FROM ubuntu:18.04
LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get purge --autoremove -y curl && \
rm -rf /var/lib/apt/lists/*

ENV CUDA_VERSION 10.2.89

ENV CUDA_PKG_VERSION 10-2=$CUDA_VERSION-1

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-cudart-$CUDA_PKG_VERSION \
cuda-compat-10-2 && \
ln -s cuda-10.2 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.1 brand=tesla,driver>=384,driver<385 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411"

#add user

RUN groupadd -g 9999 drb && \
    useradd -r -u 9999 -g drb -m -d /home/drb drb

#install packages

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        apt-utils \
        bc \
        build-essential \
        cmake \
        curl \
        dialog \
        g++ \
        gcc \
        gdb \
        git \
        python3-dev \
        software-properties-common \
        time \
        vim \
        wget && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/*

#build llvm

ENV TSAN_BUILD /opt/TsanBuild

#ENV CC $(which gcc)
#ENV CXX $(which g++)

RUN mkdir -p $TSAN_BUILD && \
    cd $TSAN_BUILD && \
    wget https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/llvm-project-10.0.1.tar.xz &&\
    tar xf llvm-project-10.0.1.tar.xz &&\
    mkdir build-llvm &&\
    cd build-llvm &&\
    cmake -DCMAKE_BUILD_TYPE=Release  \
    -DCMAKE_INSTALL_PREFIX=$PWD/install/ \
    -DLLVM_ENABLE_PROJECTS="clang;compiler-rt;libunwind;openmp"  \
    -DCLANG_OPENMP_NVPTX_DEFAULT_ARCH=sm_35  \
    -DLIBOMPTARGET_ENABLE_DEBUG=on  \
    -DLIBOMPTARGET_NVPTX_ENABLE_BCLIB=true  \
    -DLIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES=35,60,70  \
    ../llvm-project-10.0.1/llvm/ &&\
    make -j16 && \
    make install -j16 && rm llvm-project-10.0.1.tar.xz

#set environment

ENV PATH ${TSAN_BUILD}/build-llvm/install/bin:${PATH}
ENV LD_LIBRARY_PATH ${TSAN_BUILD}/build-llvm/install/lib:${LD_LIBRARY_PATH}

USER drb
WORKDIR /home/drb

RUN git clone https://github.com/LLNL/dataracebench.git
