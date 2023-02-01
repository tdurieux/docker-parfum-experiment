# pull base image

FROM ubuntu:18.04

# install gcc git fortran package later that only for test
RUN groupadd -g 9999 drb && \
    useradd -r -u 9999 -g drb -m -d /home/drb drb

# Install packages.
# Install packages.
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        apt-utils \
        dialog \
        software-properties-common \
        wget && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    add-apt-repository -y 'deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-12 main' && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        bc \
        build-essential \
        curl \
        gdb \
        git \
        python3-dev \
        time \
        vim \
        gpg wget \
        ninja-build \
        gcc-10 g++-10 gfortran-10 && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/*

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 --slave /usr/bin/g++ g++ /usr/bin/g++-10 --slave /usr/bin/gfortran gfortran /usr/bin/gfortran-10

RUN wget --no-check-certificate -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | \
     gpg --batch --dearmor - | \
     tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null

RUN echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ bionic main' | \
    tee /etc/apt/sources.list.d/kitware.list >/dev/null && \
    apt-get update

RUN rm /usr/share/keyrings/kitware-archive-keyring.gpg && \
    apt-get install --no-install-recommends -y kitware-archive-keyring cmake && rm -rf /var/lib/apt/lists/*;

#Getting prebuilt binary from llvm
RUN curl -f -SL https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.1/llvm-project-12.0.1.src.tar.xz \
 | tar -xJC . && \
 mv  llvm-project-12.0.1.src llvm-12.0.1 && \
 mkdir llvm-12.0.1/build_tree && \
 mkdir llvm-12.0.1/install_tree && \
 cd llvm-12.0.1/build_tree && \
 cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/llvm-12.0.1/install_tree -DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra;compiler-rt;openmp' /llvm-12.0.1/llvm && \
 cmake --build . --target install && \
 echo ‘export PATH=/llvm-12.0.1/install_tree/bin:$PATH’ >> ~/.bashrc && \
 echo ‘export LD_LIBRARY_PATH=/llvm-12.0.1/install_tree/lib:$LD_LIBRARY_PATH’ >> ~/.bashrc


# Setup environment.
RUN ln -s /llvm-12.0.1/install_tree/bin/clang /usr/bin/clang
RUN ln -s /llvm-12.0.1/install_tree/bin/clang /usr/bin/clang++
ENV CC  /usr/bin/clang
ENV CXX /usr/bin/clang++
ENV LD_LIBRARY_PATH /llvm-12.0.1/install_tree/lib

USER drb
WORKDIR /home/drb

RUN git clone https://github.com/LLNL/dataracebench.git


