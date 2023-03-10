FROM nvidia/cudagl:11.2.2-devel-centos7

LABEL maintainer="https://github.com/taichi-dev"

RUN yum install -y git wget && rm -rf /var/cache/yum

# Install cmake 3.x
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y cmake3 && rm -rf /var/cache/yum
RUN ln -s /usr/bin/cmake3 /usr/bin/cmake

# Install gcc 10 (https://git.centos.org/rpms/devtoolset-10-gcc)
RUN yum install -y centos-release-scl && rm -rf /var/cache/yum
RUN yum install -y devtoolset-10-gcc* && rm -rf /var/cache/yum
ENV PATH="/opt/rh/devtoolset-10/root/usr/bin:$PATH"

# Build LLVM/Clang 10 from source
WORKDIR /
RUN wget https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/llvm-10.0.0.src.tar.xz
RUN tar -xf llvm-10.0.0.src.tar.xz &&     rm llvm-10.0.0.src.tar.xz
RUN wget https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/clang-10.0.0.src.tar.xz
RUN tar -xf clang-10.0.0.src.tar.xz &&     rm clang-10.0.0.src.tar.xz
RUN cp -r clang-10.0.0.src llvm-10.0.0.src/tools/clang

WORKDIR /llvm-10.0.0.src/build
RUN cmake .. -DLLVM_ENABLE_RTTI:BOOL=ON -DBUILD_SHARED_LIBS:BOOL=OFF -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86;NVPTX" -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_ENABLE_TERMINFO=OFF
RUN make -j 8 &&     make install
ENV CC="/usr/local/bin/clang"
ENV CXX="/usr/local/bin/clang++"

# Link gcc 10 to build Taichi
WORKDIR /usr/lib/gcc/x86_64-redhat-linux/
RUN ln -s /opt/rh/devtoolset-10/root/usr/lib/gcc/x86_64-redhat-linux/10 10
# Check gcc-10 is used
RUN clang++ -v

# Create non-root user for running the container
RUN useradd -ms /bin/bash dev
WORKDIR /home/dev
USER dev

# Install miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -p /home/dev/miniconda -b
ENV PATH="/home/dev/miniconda/bin:$PATH"

# Set up multi-python environment
RUN conda init bash
RUN conda create -n py36 python=3.6 -y
RUN conda create -n py37 python=3.7 -y
RUN conda create -n py38 python=3.8 -y
RUN conda create -n py39 python=3.9 -y
RUN conda create -n py310 python=3.10 -y

WORKDIR /home/dev
ENV LANG="C.UTF-8"
