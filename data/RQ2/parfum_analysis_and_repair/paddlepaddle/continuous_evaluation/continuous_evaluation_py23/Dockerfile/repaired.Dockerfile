# A image for building paddle binaries
# Use cuda devel base image for both cpu and gpu environment

# When you modify it, please be aware of cudnn-runtime version
# and libcudnn.so.x in paddle/scripts/docker/build.sh
# Because we use cuda9, otherwise bounch of this can be replaced with
# paddlepaddle/paddle:latest-dev
FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
MAINTAINER PaddlePaddle Authors <paddle-dev@baidu.com>

ARG UBUNTU_MIRROR
RUN /bin/bash -c 'if [[ -n ${UBUNTU_MIRROR} ]]; then sed -i 's#http://archive.ubuntu.com/ubuntu#${UBUNTU_MIRROR}#g' /etc/apt/sources.list; fi'

# ENV variables
ARG WITH_GPU
ARG WITH_AVX
ARG WITH_DOC

ENV WOBOQ OFF
ENV WITH_GPU=${WITH_GPU:-ON}
ENV WITH_AVX=${WITH_AVX:-ON}
ENV WITH_DOC=${WITH_DOC:-OFF}

ENV HOME /root
# Add bash enhancements
COPY ./paddle/scripts/docker/root/ /root/

RUN apt-get update && \
    apt-get install --no-install-recommends -y --allow-downgrades \
    git python-pip python-dev openssh-server bison \
    libnccl2 libnccl-dev \
    wget unzip unrar tar xz-utils bzip2 gzip coreutils ntp \
    curl sed grep graphviz libjpeg-dev zlib1g-dev \
    python-matplotlib gcc-4.8 g++-4.8 \
    automake locales clang-format swig doxygen cmake \
    liblapack-dev liblapacke-dev \
    clang-3.8 llvm-3.8 libclang-3.8-dev \
    net-tools libtool && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*;

# Install Go and glide
RUN wget -qO- https://storage.googleapis.com/golang/go1.8.1.linux-amd64.tar.gz | \
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
RUN wget -qO- https://paddlepaddledeps.bj.bcebos.com/TensorRT-4.0.0.3.Ubuntu-16.04.4.x86_64-gnu.cuda-8.0.cudnn7.0.tar.gz | \
    tar -xz -C /usr/local && \
    cp -rf /usr/local/TensorRT/include /usr && \
    cp -rf /usr/local/TensorRT/lib /usr

# git credential to skip password typing
RUN git config --global credential.helper store

# Fix locales to en_US.UTF-8
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

# FIXME: due to temporary ipykernel dependency issue, specify ipykernel jupyter
# version util jupyter fixes this issue.

# specify sphinx version as 1.5.6 and remove -U option for [pip install -U
# sphinx-rtd-theme] since -U option will cause sphinx being updated to newest
# version(1.7.1 for now), which causes building documentation failed.
RUN pip install --no-cache-dir --upgrade pip==9.0.3 && \
    pip install --no-cache-dir -U wheel && \
    pip install --no-cache-dir -U docopt PyYAML sphinx==1.5.6 && \
    pip install --no-cache-dir sphinx-rtd-theme==0.1.9 recommonmark

RUN pip install --no-cache-dir pre-commit 'ipython==5.3.0' && \
    pip install --no-cache-dir 'ipykernel==4.6.0' 'jupyter==1.0.0' && \
    pip install --no-cache-dir opencv-python

COPY ./python/requirements.txt /root/
RUN pip install --no-cache-dir -r /root/requirements.txt

# To fix https://github.com/PaddlePaddle/Paddle/issues/1954, we use
# the solution in https://urllib3.readthedocs.io/en/latest/user-guide.html#ssl-py2
RUN apt-get install --no-install-recommends -y libssl-dev libffi-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir certifi urllib3[secure]


# Install woboq_codebrowser to /woboq
RUN git clone https://github.com/woboq/woboq_codebrowser /woboq && \
    (cd /woboq \
     cmake -DLLVM_CONFIG_EXECUTABLE=/usr/bin/llvm-config-3.8 \
           -DCMAKE_BUILD_TYPE=Release . \
     make)


# Configure OpenSSH server. c.f. https://docs.docker.com/engine/examples/running_ssh_service
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
EXPOSE 22

# build the app and host it
RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pip mongodb openjdk-8-jdk ccache && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir flask flask-cache pymongo xonsh numpy

RUN apt-get update && apt install --no-install-recommends -y uwsgi nginx supervisor software-properties-common python-software-properties && rm -rf /var/lib/apt/lists/*;

ENV NGINX_MAX_UPLOAD 0

# By default, Nginx listens on port 80.
# To modify this, change LISTEN_PORT environment variable.
# (in a Dockerfile or with an option for `docker run`)
ENV LISTEN_PORT 80

# Which uWSGI .ini file should be used, to make it customizable
ENV UWSGI_INI /app/uwsgi.ini

# URL under which static (not modified by Python) files will be requested
# They will be served by Nginx directly, without being handled by uWSGI
ENV STATIC_URL /static
# Absolute path in where the static files wil be
ENV STATIC_PATH /app/static

# If STATIC_INDEX is 1, serve / with /static/index.html directly (or the static URL configured)
# ENV STATIC_INDEX 1
ENV STATIC_INDEX 0

# Add demo app
RUN git clone --recursive https://github.com/PaddlePaddle/continuous_evaluation

# Make /app/* available to be imported by Python globally to better support several use cases like Alembic migrations.
ENV PYTHONPATH=/app
EXPOSE 80

# development image default do build work
WORKDIR /continuous_evaluation/web/
CMD = ["python3", "main.py"]