# A image for building paddle binaries
# Use cuda devel base image for both cpu and gpu environment
# When you modify it, please be aware of cudnn-runtime version
FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu16.04
MAINTAINER PaddlePaddle Authors <paddle-dev@baidu.com>

ARG UBUNTU_MIRROR
RUN /bin/bash -c 'if [[ -n ${UBUNTU_MIRROR} ]]; then sed -i 's#http://archive.ubuntu.com/ubuntu#${UBUNTU_MIRROR}#g' /etc/apt/sources.list; fi'

# ENV variables
ARG WITH_GPU
ARG WITH_AVX

ENV WITH_GPU=${WITH_GPU:-ON}
ENV WITH_AVX=${WITH_AVX:-ON}

ENV HOME /root
# Add bash enhancements
COPY ./paddle/scripts/docker/root/ /root/

ENV PATH=/usr/local/gcc-8.2/bin:$PATH
RUN rm -rf /temp_gcc82 && rm -rf /gcc-8.2.0.tar.xz && rm -rf /gcc-8.2.0

# Prepare packages for Python
# apt install openmpi: In order to run a single test of pslib coverage
RUN apt-get update && \
    apt-get install --no-install-recommends -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev openmpi-bin openmpi-doc libopenmpi-dev && rm -rf /var/lib/apt/lists/*;

# gcc8.2
RUN wget -q https://paddle-docker-tar.bj.bcebos.com/home/users/tianshuo/bce-python-sdk-0.8.27/gcc-8.2.0.tar.xz && \
  tar -xvf gcc-8.2.0.tar.xz && \
  cd gcc-8.2.0 && \
  sed -i 's#ftp://gcc.gnu.org/pub/gcc/infrastructure/#https://paddle-ci.gz.bcebos.com/#g' ./contrib/download_prerequisites && \
  unset LIBRARY_PATH CPATH C_INCLUDE_PATH PKG_CONFIG_PATH CPLUS_INCLUDE_PATH INCLUDE && \
  ./contrib/download_prerequisites && \
  cd .. && mkdir temp_gcc82 && cd temp_gcc82 && \
  ../gcc-8.2.0/configure --prefix=/usr/local/gcc-8.2 --enable-threads=posix --disable-checking --disable-multilib && \
  make -j8 && make install && rm gcc-8.2.0.tar.xz

ENV PATH=/usr/local/gcc-8.2/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/gcc-8.2/lib64:$LD_LIBRARY_PATH
RUN rm -rf /temp_gcc82 && rm -rf /gcc-8.2.0.tar.xz && rm -rf /gcc-8.2.0

# Install Python3.6
RUN mkdir -p /root/python_build/ && wget -q https://www.sqlite.org/2018/sqlite-autoconf-3250300.tar.gz && \
    tar -zxf sqlite-autoconf-3250300.tar.gz && cd sqlite-autoconf-3250300 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" -prefix=/usr/local && make -j8 && make install && cd ../ && rm sqlite-autoconf-3250300.tar.gz && \
    wget -q https://www.python.org/ftp/python/3.6.0/Python-3.6.0.tgz && \
    tar -xzf Python-3.6.0.tgz && cd Python-3.6.0 && \
    CFLAGS="-Wformat" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local/ --enable-shared > /dev/null && \
    make -j8 > /dev/null && make altinstall > /dev/null && rm Python-3.6.0.tgz

# Install Python3.7
RUN wget -q https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz && \
    tar -xzf Python-3.7.0.tgz && cd Python-3.7.0 && \
    CFLAGS="-Wformat" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local/ --enable-shared > /dev/null && \
    make -j8 > /dev/null && make altinstall > /dev/null && rm Python-3.7.0.tgz
RUN rm -r /root/python_build

RUN apt-get update && \
    apt-get install --no-install-recommends -y --allow-downgrades --allow-change-held-packages \
    patchelf python3 python3-dev python3-pip \
    git python-pip python-dev python-opencv openssh-server bison \
    wget unzip unrar tar xz-utils bzip2 gzip coreutils ntp \
    curl sed grep graphviz libjpeg-dev zlib1g-dev \
    python-matplotlib gcc-4.8 g++-4.8 \
    automake locales clang-format swig \
    liblapack-dev liblapacke-dev \
    clang-3.8 llvm-3.8 libclang-3.8-dev \
    net-tools libtool && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*;

# install cmake
WORKDIR /home
RUN wget -q https://cmake.org/files/v3.16/cmake-3.16.0-Linux-x86_64.tar.gz
RUN tar -zxvf cmake-3.16.0-Linux-x86_64.tar.gz && rm cmake-3.16.0-Linux-x86_64.tar.gz
RUN rm cmake-3.16.0-Linux-x86_64.tar.gz
ENV PATH=/home/cmake-3.16.0-Linux-x86_64/bin:$PATH

# Install Python2.7.15 to replace original python
WORKDIR /home
ENV version=2.7.15
RUN wget https://www.python.org/ftp/python/$version/Python-$version.tgz
RUN tar -xvf Python-$version.tgz && rm Python-$version.tgz
WORKDIR /home/Python-$version
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-unicode=ucs4 --enable-shared CFLAGS=-fPIC --prefix=/usr/local/python2.7.15
RUN make && make install

RUN echo "export PATH=/usr/local/python2.7.15/include:${PATH}" >> ~/.bashrc
RUN echo "export PATH=/usr/local/python2.7.15/bin:${PATH}" >> ~/.bashrc
RUN echo "export LD_LIBRARY_PATH=/usr/local/python2.7.15/lib:${LD_LIBRARY_PATH}" >> ~/.bashrc
RUN echo "export CPLUS_INCLUDE_PATH=/usr/local/python2.7.15/include/python2.7:$CPLUS_INCLUDE_PATH" >> ~/.bashrc
ENV PATH=/usr/local/python2.7.15/include:${PATH}
ENV PATH=/usr/local/python2.7.15/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/python2.7.15/lib:${LD_LIBRARY_PATH}
ENV CPLUS_INCLUDE_PATH=/usr/local/python2.7.15/include/python2.7:$CPLUS_INCLUDE_PATH
RUN mv /usr/bin/python /usr/bin/python.bak
RUN ln -s /usr/local/python2.7.15/bin/python2.7 /usr/local/bin/python
RUN ln -s /usr/local/python2.7.15/bin/python2.7 /usr/bin/python
WORKDIR /home
RUN wget https://files.pythonhosted.org/packages/b0/d1/8acb42f391cba52e35b131e442e80deffbb8d0676b93261d761b1f0ef8fb/setuptools-40.6.2.zip
RUN apt-get -y --no-install-recommends install unzip && rm -rf /var/lib/apt/lists/*;
RUN unzip setuptools-40.6.2.zip
WORKDIR /home/setuptools-40.6.2
RUN python setup.py build
RUN python setup.py install
WORKDIR /home

RUN wget https://files.pythonhosted.org/packages/69/81/52b68d0a4de760a2f1979b0931ba7889202f302072cc7a0d614211bc7579/pip-18.0.tar.gz && tar -zxvf pip-18.0.tar.gz && rm pip-18.0.tar.gz
WORKDIR pip-18.0
RUN python setup.py install && \
  python3.7 setup.py install && \
  python3.6 setup.py install && \
  python3 setup.py install

WORKDIR /home
RUN rm Python-$version.tgz setuptools-40.6.2.zip pip-18.0.tar.gz && \
    rm -r Python-$version setuptools-40.6.2 pip-18.0

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

# Install TensorRT
# following TensorRT.tar.gz is not the default official one, we do two miny changes:
# 1. Remove the unnecessary files to make the library small. TensorRT.tar.gz only contains include and lib now,
#    and its size is only one-third of the official one.
# 2. Manually add ~IPluginFactory() in IPluginFactory class of NvInfer.h, otherwise, it couldn't work in paddle.
#    See https://github.com/PaddlePaddle/Paddle/issues/10129 for details.

RUN wget -q https://paddlepaddledeps.bj.bcebos.com/TensorRT-6.0.1.5.Ubuntu-16.04.x86_64-gnu.cuda-10.1.cudnn7.tar.gz --no-check-certificate && \
    tar -zxf TensorRT-6.0.1.5.Ubuntu-16.04.x86_64-gnu.cuda-10.1.cudnn7.tar.gz -C /usr/local && \
    cp -rf /usr/local/TensorRT-6.0.1.5/include/* /usr/include/ && cp -rf /usr/local/TensorRT-6.0.1.5/lib/* /usr/lib/ && rm TensorRT-6.0.1.5.Ubuntu-16.04.x86_64-gnu.cuda-10.1.cudnn7.tar.gz

# Install patchelf-0.10
RUN wget https://paddle-ci.gz.bcebos.com/patchelf-0.10.tar.gz && \
    tar -zxvf patchelf-0.10.tar.gz && cd patchelf-0.10 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j8 && make install && rm patchelf-0.10.tar.gz

# git credential to skip password typing
RUN git config --global credential.helper store

# Fix locales to en_US.UTF-8
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

# FIXME: due to temporary ipykernel dependency issue, specify ipykernel jupyter
# version util jupyter fixes this issue.

# specify sphinx version as 1.5.6 and remove -U option for [pip install -U
# sphinx-rtd-theme] since -U option will cause sphinx being updated to newest
# version(1.7.1 for now), which causes building documentation failed.
RUN pip3 --no-cache-dir install -U wheel py-cpuinfo==5.0.0 && \
    pip3 --no-cache-dir install -U docopt PyYAML sphinx==1.5.6  && \
    pip3 --no-cache-dir install sphinx-rtd-theme==0.1.9 recommonmark  && \
    pip3.6 --no-cache-dir install -U wheel py-cpuinfo==5.0.0  && \
    pip3.6 --no-cache-dir install -U docopt PyYAML sphinx==1.5.6  && \
    pip3.6 --no-cache-dir install sphinx-rtd-theme==0.1.9 recommonmark  && \
    pip3.7 --no-cache-dir install -U wheel py-cpuinfo==5.0.0  && \
    pip3.7 --no-cache-dir install -U docopt PyYAML sphinx==1.5.6  && \
    pip3.7 --no-cache-dir install sphinx-rtd-theme==0.1.9 recommonmark  && \
    pip --no-cache-dir install -U wheel py-cpuinfo==5.0.0  && \
    pip --no-cache-dir install -U docopt PyYAML sphinx==1.5.6  && \
    pip --no-cache-dir install sphinx-rtd-theme==0.1.9 recommonmark

RUN pip3 --no-cache-dir install pre-commit==1.10.4 ipython==5.3.0  && \
    pip3 --no-cache-dir install ipykernel==4.6.0 jupyter==1.0.0  && \
    pip3 --no-cache-dir install opencv-python  && \
    pip3.6 --no-cache-dir install pre-commit==1.10.4 ipython==5.3.0  && \
    pip3.6 --no-cache-dir install ipykernel==4.6.0 jupyter==1.0.0  && \
    pip3.6 --no-cache-dir install opencv-python  && \
    pip3.7 --no-cache-dir install pre-commit==1.10.4 ipython==5.3.0  && \
    pip3.7 --no-cache-dir install ipykernel==4.6.0 jupyter==1.0.0  && \
    pip3.7 --no-cache-dir install opencv-python  && \
    pip --no-cache-dir install pre-commit==1.10.4 ipython==5.3.0  && \
    pip --no-cache-dir install ipykernel==4.6.0 jupyter==1.0.0  && \
    pip --no-cache-dir install  opencv-python

#For docstring checker
RUN pip3 --no-cache-dir install pylint pytest astroid isort
RUN pip3.6 --no-cache-dir install pylint pytest astroid isort
RUN pip3.7 --no-cache-dir install pylint pytest astroid isort
RUN pip --no-cache-dir install pylint pytest astroid isort LinkChecker

RUN pip3 --no-cache-dir install coverage
RUN pip3.6 --no-cache-dir install coverage
RUN pip3.7 --no-cache-dir install coverage
RUN pip --no-cache-dir install coverage

COPY ./python/requirements.txt /root/
RUN pip3 --no-cache-dir install -r /root/requirements.txt
RUN pip3.6 --no-cache-dir install -r /root/requirements.txt
RUN pip3.7 --no-cache-dir install -r /root/requirements.txt
RUN pip --no-cache-dir install -r /root/requirements.txt

# To fix https://github.com/PaddlePaddle/Paddle/issues/1954, we use
# the solution in https://urllib3.readthedocs.io/en/latest/user-guide.html#ssl-py2
RUN apt-get install --no-install-recommends -y libssl-dev libffi-dev && apt-get clean -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 --no-cache-dir install certifi urllib3[secure]
RUN pip3.6 --no-cache-dir install certifi urllib3[secure]
RUN pip3.7 --no-cache-dir install certifi urllib3[secure]
RUN pip --no-cache-dir install certifi urllib3[secure]



# ar mishandles 4GB files
# https://sourceware.org/bugzilla/show_bug.cgi?id=14625
# remove them when apt-get support 2.27 and higher version
RUN wget -q https://paddle-ci.gz.bcebos.com/binutils_2.27.orig.tar.gz && \
    tar -xzf binutils_2.27.orig.tar.gz && \
    cd binutils-2.27 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j && make install && cd .. && rm -rf binutils-2.27 binutils_2.27.orig.tar.gz

RUN apt-get install --no-install-recommends libprotobuf-dev -y && rm -rf /var/lib/apt/lists/*;
RUN pip --no-cache-dir install -U netifaces==0.10.9

# ccache 3.7.9
RUN wget https://paddle-ci.gz.bcebos.com/ccache-3.7.9.tar.gz && \
    tar xf ccache-3.7.9.tar.gz && mkdir /usr/local/ccache-3.7.9 && cd ccache-3.7.9 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" -prefix=/usr/local/ccache-3.7.9 && \
    make -j8 && make install && \
    ln -s /usr/local/ccache-3.7.9/bin/ccache /usr/local/bin/ccache && rm ccache-3.7.9.tar.gz

RUN wget --no-check-certificate  -q https://paddle-edl.bj.bcebos.com/hadoop-2.7.7.tar.gz && \
     tar -xzf  hadoop-2.7.7.tar.gz && mv hadoop-2.7.7 /usr/local/ && rm hadoop-2.7.7.tar.gz

# Configure OpenSSH server. c.f. https://docs.docker.com/engine/examples/running_ssh_service
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
CMD source ~/.bashrc
EXPOSE 22
