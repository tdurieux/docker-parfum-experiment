# Regent + Legion with CUDA

FROM nvidia/cuda:11.3.0-base-ubuntu20.04

MAINTAINER Sean Treichler <sean@nvidia.com>

RUN dpkg --add-architecture i386 && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends -qq apt-transport-https ca-certificates software-properties-common wget curl && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    add-apt-repository ppa:pypy/ppa -y && \
    wget -nv -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    add-apt-repository -y "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-9 main" && \
    add-apt-repository -y "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-10 main" && \
    add-apt-repository -y "deb http://old-releases.ubuntu.com/ubuntu zesty main" && \
    add-apt-repository -y "deb http://old-releases.ubuntu.com/ubuntu zesty universe" && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends -qq \
      build-essential git time wget \
      libpython3-dev python3-pip pypy3 \
      g++-5 g++-6 g++-7 g++-8 g++-9 \
      gfortran-5 gfortran-6 gfortran-7 gfortran-8 gfortran-9 \
      gcc-multilib g++-multilib \
      clang-7 libclang-7-dev llvm-7-dev libomp-7-dev \
      clang-9 libclang-9-dev llvm-9-dev \
      clang-10 libclang-10-dev llvm-10-dev \
      cmake \
      libncurses5-dev libedit-dev \
      zlib1g-dev zlib1g-dev:i386 \
      mpich libmpich-dev \
      libblas-dev liblapack-dev libhdf5-dev \
      libssl-dev \
      gdb vim && \
    apt-get clean && \
    pip3 install --no-cache-dir --upgrade setuptools && \
    pip3 install --no-cache-dir cffi github3.py numpy qualname && rm -rf /var/lib/apt/lists/*;

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# install a bunch of flavors of CUDA
RUN wget -nv https://developer.download.nvidia.com/compute/cuda/11.2.0/local_installers/cuda_11.2.0_460.27.04_linux.run && \
    bash ./cuda_11.2.0_460.27.04_linux.run --toolkit --silent && \
    rm ./cuda_11.2.0_460.27.04_linux.run && \
    wget -nv https://developer.download.nvidia.com/compute/cuda/11.0.2/local_installers/cuda_11.0.2_450.51.05_linux.run && \
    bash ./cuda_11.0.2_450.51.05_linux.run --toolkit --silent && \
    rm ./cuda_11.0.2_450.51.05_linux.run && \
    wget -nv https://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda_10.2.89_440.33.01_linux.run && \
    bash ./cuda_10.2.89_440.33.01_linux.run --toolkit --silent --override && \
    rm ./cuda_10.2.89_440.33.01_linux.run && \
    wget -nv https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda_9.2.148_396.37_linux && \
    bash ./cuda_9.2.148_396.37_linux --toolkit --silent --override && \
    rm ./cuda_9.2.148_396.37_linux && \
    wget -nv https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run && \
    bash ./cuda_9.0.176_384.81_linux-run --toolkit --silent --override && \
    rm ./cuda_9.0.176_384.81_linux-run && \
    wget -nv https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run && \
    bash ./cuda_8.0.61_375.26_linux-run --tar mxvf ./InstallUtils.pm && \
    PERL5LIB=/ bash ./cuda_8.0.61_375.26_linux-run --toolkit --silent --override && \
    rm ./cuda_8.0.61_375.26_linux-run ./InstallUtils.pm && \
    rm /usr/local/cuda

# install gitlab-runner
RUN wget -O - https://packages.gitlab.com/runner/gitlab-runner/gpgkey | apt-key add - && \
    wget -O /etc/apt/sources.list.d/gitlab-runner.list 'https://packages.gitlab.com/install/repositories/runner/gitlab-runner/config_file.list?os=ubuntu&dist=focal&source=script' && \
    apt-get update && \
    apt-get install -y --no-install-recommends -qq gitlab-runner && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;