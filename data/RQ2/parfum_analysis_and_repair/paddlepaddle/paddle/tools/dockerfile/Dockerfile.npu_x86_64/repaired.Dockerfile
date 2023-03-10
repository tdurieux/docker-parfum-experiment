# A image for building paddle binaries
# Use cann 5.0.2.alpha005 and x86_64 for A300t-9000
# Update CANN_VERSION if using other versions
#
# Build: CANN 5.0.2.alpha005
# Download pkgs from https://www.hiascend.com/software/cann/community
# and copy them to current dir first, then run build commands
# cd Paddle/tools/dockerfile
# docker build -f Dockerfile.npu_x86_64  \
# --build-arg CANN_VERSION=5.0.2.alpha005 \
# -t paddlepaddle/paddle:latest-dev-5.0.2.alpha005-gcc82-x86_64 .
#
# docker run -it --pids-limit 409600 \
# -v /usr/local/Ascend/driver:/usr/local/Ascend/driver \
# -v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
# -v /usr/local/dcmi:/usr/local/dcmi \
# paddlepaddle/paddle:latest-dev-5.0.2.alpha005-gcc82-x86_64 /bin/bash

FROM ubuntu:18.04
MAINTAINER PaddlePaddle Authors <paddle-dev@baidu.com>

RUN apt-get update && apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && add-apt-repository ppa:deadsnakes/ppa && add-apt-repository ppa:ubuntu-toolchain-r/test && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y curl wget vim git unzip unrar tar xz-utils libssl-dev bzip2 gzip make libgcc-s1 sudo openssh-server \
            coreutils ntp language-pack-zh-hans python-qt4 libsm6 libxext6 libxrender-dev libgl1-mesa-glx libsqlite3-dev libopenblas-dev \
            bison graphviz libjpeg-dev zlib1g zlib1g-dev automake locales swig net-tools libtool module-init-tools numactl libnuma-dev \
            openssl libffi-dev pciutils libblas-dev gfortran libblas3 liblapack-dev liblapack3 default-jre screen tmux gdb lldb gcc g++ && rm -rf /var/lib/apt/lists/*;

# GCC 8.2
WORKDIR /opt
RUN wget -q https://paddle-ci.gz.bcebos.com/gcc-8.2.0.tar.xz && \
    tar -xvf gcc-8.2.0.tar.xz && cd gcc-8.2.0 && \
    unset LIBRARY_PATH CPATH C_INCLUDE_PATH PKG_CONFIG_PATH CPLUS_INCLUDE_PATH INCLUDE && \
    ./contrib/download_prerequisites && \
    cd .. && mkdir temp_gcc82 && cd temp_gcc82 && \
    ../gcc-8.2.0/configure --prefix=/opt/compiler/gcc-8.2 --enable-threads=posix --disable-checking --disable-multilib && \
    make -j8 && make install && \
    cd .. && rm -rf temp_gcc82 && rm -rf gcc-8.2.0* && \
    cd /usr/lib/x86_64-linux-gnu && \
    mv libstdc++.so.6 libstdc++.so.6.bak && mv libstdc++.so.6.0.25 libstdc++.so.6.0.25.bak && \
    ln -s /opt/compiler/gcc-8.2/lib64/libgfortran.so.5 /usr/lib/x86_64-linux-gnu/libstdc++.so.5 && \
    ln -s /opt/compiler/gcc-8.2/lib64/libstdc++.so.6   /usr/lib/x86_64-linux-gnu/libstdc++.so.6 && \
    cp /opt/compiler/gcc-8.2/lib64/libstdc++.so.6.0.25 /usr/lib/x86_64-linux-gnu && \
    cd /usr/bin && mv gcc gcc.bak && mv g++ g++.bak && \
    ln -s /opt/compiler/gcc-8.2/bin/gcc /usr/bin/gcc && \
    ln -s /opt/compiler/gcc-8.2/bin/g++ /usr/bin/g++ && rm gcc-8.2.0.tar.xz
ENV PATH=/opt/compiler/gcc-8.2/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/compiler/gcc-8.2/lib:/opt/compiler/gcc-8.2/lib64:$LD_LIBRARY_PATH

# cmake 3.16
WORKDIR /opt
RUN wget -q https://cmake.org/files/v3.16/cmake-3.16.0-Linux-x86_64.tar.gz && \
    tar -zxvf cmake-3.16.0-Linux-x86_64.tar.gz && rm cmake-3.16.0-Linux-x86_64.tar.gz && \
    mv cmake-3.16.0-Linux-x86_64 cmake-3.16
ENV PATH=/opt/cmake-3.16/bin:${PATH}

# conda 4.9.2
WORKDIR /opt
ARG CONDA_FILE=Miniconda3-py37_4.9.2-Linux-x86_64.sh
RUN cd /opt && wget -q https://repo.anaconda.com/miniconda/${CONDA_FILE} && chmod +x ${CONDA_FILE}
RUN mkdir /opt/conda && ./${CONDA_FILE} -b -f -p "/opt/conda" && rm -rf ${CONDA_FILE}
ENV PATH=/opt/conda/bin:${PATH}
RUN conda init bash && conda install -n base jupyter jupyterlab

# install pylint and pre-commit
RUN /opt/conda/bin/pip install pre-commit pylint pylint pytest astroid isort coverage qtconsole
# install CANN 5.0.2 requirement
RUN /opt/conda/bin/pip install 'numpy<1.20,>=1.13.3' 'decorator>=4.4.0' 'sympy>=1.4' 'cffi>=1.12.3' 'protobuf>=3.11.3'
RUN /opt/conda/bin/pip install attrs pyyaml pathlib2 scipy requests psutil

# install Paddle requirement
RUN wget https://raw.githubusercontent.com/PaddlePaddle/Paddle/develop/python/requirements.txt -O /root/requirements.txt
RUN /opt/conda/bin/pip install -r /root/requirements.txt && rm -rf /root/requirements.txt
RUN wget https://raw.githubusercontent.com/PaddlePaddle/Paddle/develop/python/unittest_py/requirements.txt -O /root/requirements.txt
RUN /opt/conda/bin/pip install -r /root/requirements.txt && rm -rf /root/requirements.txt

# Install Go and glide
RUN wget -qO- https://paddle-ci.cdn.bcebos.com/go1.8.1.linux-amd64.tar.gz | \
    tar -xz -C /usr/local && \
    mkdir /root/gopath && \
    mkdir /root/gopath/bin && \
    mkdir /root/gopath/src
ENV GOROOT=/usr/local/go GOPATH=/root/gopath
# should not be in the same line with GOROOT definition, otherwise docker build could not find GOROOT.
ENV PATH=${PATH}:${GOROOT}/bin:${GOPATH}/bin
# install glide
RUN curl -f -s -q https://glide.sh/get | sh

# git credential to skip password typing
RUN git config --global credential.helper store

# Fix locales to en_US.UTF-8
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN apt-get install --no-install-recommends libprotobuf-dev -y && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends lsof -y && rm -rf /var/lib/apt/lists/*;

# Older versions of patchelf limited the size of the files being processed and were fixed in this pr.
# https://github.com/NixOS/patchelf/commit/ba2695a8110abbc8cc6baf0eea819922ee5007fa
# So install a newer version here.
RUN wget -q https://paddle-ci.cdn.bcebos.com/patchelf_0.10-2_amd64.deb && \
    dpkg -i patchelf_0.10-2_amd64.deb && rm -rf patchelf_0.10-2_amd64.deb

# Configure OpenSSH server. c.f. https://docs.docker.com/engine/examples/running_ssh_service
RUN mkdir /var/run/sshd && echo 'root:root' | chpasswd && sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
CMD source ~/.bashrc

# ccache 3.7.9
RUN wget https://paddle-ci.gz.bcebos.com/ccache-3.7.9.tar.gz && \
    tar xf ccache-3.7.9.tar.gz && mkdir /usr/local/ccache-3.7.9 && cd ccache-3.7.9 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" -prefix=/usr/local/ccache-3.7.9 && \
    make -j8 && make install && cd .. && rm -rf ccache-3.7.9* && \
    ln -s /usr/local/ccache-3.7.9/bin/ccache /usr/local/bin/ccache && rm ccache-3.7.9.tar.gz

# clang-form 3.8.0
RUN wget https://paddle-ci.cdn.bcebos.com/clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz && \ 
    tar xf clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz && cd clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-16.04 && \
    cp -r * /usr/local && cd .. && rm -rf clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-16.04 && \
    rm -rf clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz

# HwHiAiUser
RUN groupadd HwHiAiUser && \
    useradd -g HwHiAiUser -m -d /home/HwHiAiUser HwHiAiUser

# copy /etc/ascend_install.info to current dir fist
COPY ascend_install.info /etc/ascend_install.info

# copy /usr/local/Ascend/driver/version.info to current dir fist
RUN mkdir -p /usr/local/Ascend/driver
COPY version.info /usr/local/Ascend/driver/version.info

# Download packages from https://www.hiascend.com/software/cann/community and copy them to current dir first
WORKDIR /usr/local/Ascend
ARG CANN_VERSION=5.0.2.alpha005
# update envs for driver
ENV LD_LIBRARY_PATH=/usr/local/Ascend/driver/lib64:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=/usr/local/Ascend/driver/lib64/common:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=/usr/local/Ascend/driver/lib64/driver:$LD_LIBRARY_PATH

# Install Ascend toolkit
COPY Ascend-cann-toolkit_${CANN_VERSION}_linux-x86_64.run /usr/local/Ascend/
RUN chmod +x Ascend-cann-toolkit_${CANN_VERSION}_linux-x86_64.run && \
    ./Ascend-cann-toolkit_${CANN_VERSION}_linux-x86_64.run --install --quiet && \
    rm -rf Ascend-cann-toolkit_${CANN_VERSION}_linux-x86_64.run
# udpate envs for model transformation and operator develop
ENV PATH=/usr/local/Ascend/ascend-toolkit/latest/atc/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/Ascend/ascend-toolkit/latest/atc/lib64:$LD_LIBRARY_PATH
ENV PYTHONPATH=/usr/local/Ascend/ascend-toolkit/latest/pyACL/python/site-packages/acl:$PYTHONPATH
ENV PYTHONPATH=/usr/local/Ascend/ascend-toolkit/latest/atc/python/site-packages:$PYTHONPATH
ENV PYTHONPATH=/usr/local/Ascend/ascend-toolkit/latest/toolkit/python/site-packages:$PYTHONPATH
ENV TOOLCHAIN_HOME=/usr/local/Ascend/ascend-toolkit/latest/toolkit

# Install Ascend NNAE
COPY Ascend-cann-nnae_${CANN_VERSION}_linux-x86_64.run /usr/local/Ascend/
RUN chmod +x Ascend-cann-nnae_${CANN_VERSION}_linux-x86_64.run && \
    ./Ascend-cann-nnae_${CANN_VERSION}_linux-x86_64.run --install --quiet && \
    rm -rf Ascend-cann-nnae_${CANN_VERSION}_linux-x86_64.run
# update envs for third party AI framework develop
ENV PATH=/usr/local/Ascend/nnae/latest/fwkacllib/bin:$PATH
ENV PATH=/usr/local/Ascend/nnae/latest/fwkacllib/ccec_compiler/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/Ascend/nnae/latest/fwkacllib/lib64:$LD_LIBRARY_PATH
ENV PYTHONPATH=/usr/local/Ascend/nnae/latest/fwkacllib/python/site-packages:$PYTHONPATH
ENV ASCEND_AICPU_PATH=/usr/local/Ascend/nnae/latest
ENV ASCEND_OPP_PATH=/usr/local/Ascend/nnae/latest/opp

# DEV image should open error level log
# 0 debug; 1 info; 2 warning; 3 error; 4 null
ENV ASCEND_GLOBAL_LOG_LEVEL=3
RUN rm -rf /usr/local/Ascend/driver

# Clean
RUN apt-get clean -y

EXPOSE 22
