# Adaptive container with the CK interface
# Concept: https://arxiv.org/abs/2011.01149

FROM ubuntu:20.04

# Contact
LABEL maintainer="Grigori Fursin <grigori@octoml.ai>"

# Shell info
SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/bin/bash", "-c"]

# Set noninteractive mode for apt (do not use ENV)
ARG DEBIAN_FRONTEND=noninteractive

# Notes: https://runnable.com/blog/9-common-dockerfile-mistakes
# Install system dependencies
RUN apt update && \
    apt install -y --no-install-recommends \
           apt-utils \
           git wget zip bzip2 libz-dev libbz2-dev cmake curl unzip \
           openssh-client vim mc tree \
           gcc g++ autoconf autogen libtool make libc6-dev build-essential \
           libssl-dev libbz2-dev libffi-dev \
           python3 python3-pip python3-dev \
           sudo && rm -rf /var/lib/apt/lists/*;

# Prepare a user with a user group with a random id
RUN groupadd -g 1111 ckuser
RUN useradd -u 2222 -g ckuser --create-home --shell /bin/bash ckuser
RUN echo "ckuser:ckuser" | chpasswd
RUN adduser ckuser sudo
RUN echo "ckuser   ALL=(ALL)  NOPASSWD:ALL" >> /etc/sudoers

# Set user
USER ckuser:ckuser
WORKDIR /home/ckuser
ENV PATH="/home/ckuser/.local/bin:${PATH}"
RUN mkdir .ssh

# Install CK
RUN export DUMMY_CK=C
RUN ${DUMMY_CK} pip3 install virtualenv
RUN ${DUMMY_CK} pip3 install ck

# Clone CK repo
RUN ck pull repo:mlcommons@ck-mlops

# Install packages to CK env entries
RUN ck setup kernel --var.install_to_env=yes

RUN ck detect platform.os --platform_init_uoa=generic-linux-dummy
RUN ck detect soft:compiler.python --full_path=/usr/bin/python3

RUN ck detect soft:compiler.gcc --full_path=`which gcc`

RUN ck install package --tags=tool,cmake,prebuilt --quiet

RUN ck install package --tags=lib,python-package,absl
RUN ck install package --tags=lib,python-package,numpy
RUN ck install package --tags=lib,python-package,matplotlib
RUN ck install package --tags=lib,python-package,cython
RUN ck install package --tags=lib,python-package,pillow
RUN ck install package --tags=lib,python-package,opencv-python-headless

RUN ck install package --tags=mlperf,inference,src,r1.0
RUN ck install package --tags=lib,mlperf,loadgen,static

RUN ck install package --tags=lib,tflite,via-cmake,v2.4.1,with.ruy
