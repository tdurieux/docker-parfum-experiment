# Adaptive container with the CK interface
# Concept: https://arxiv.org/abs/2011.01149

FROM ubuntu:20.04

# Contact
LABEL maintainer="Grigori Fursin <grigori@octoml.ai>"

# Shell info
SHELL ["/bin/bash", "-c"]
#ENTRYPOINT ["/bin/bash", "-c"]

# Set noninteractive mode for apt (do not use ENV)
ARG DEBIAN_FRONTEND=noninteractive

# Notes: https://runnable.com/blog/9-common-dockerfile-mistakes
# Install system dependencies
RUN apt update && \
    apt install -y --no-install-recommends \
           apt-utils \
           git wget zip bzip2 libz-dev libbz2-dev cmake curl unzip \
           openssh-client vim mc tree \
           gcc g++ autoconf autogen libtool make libc6-dev build-essential patch \
           gfortran libblas-dev liblapack-dev \
           libsndfile1-dev libssl-dev libbz2-dev libxml2-dev libtinfo-dev libffi-dev \
           python3 python3-pip python3-dev \
           libtinfo-dev \
           python-is-python3 \
           libncurses-dev \
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
RUN export DUMMY_CK=A
RUN ${DUMMY_CK} pip3 install virtualenv
RUN ${DUMMY_CK} pip3 install ck

# Clone CK repo
RUN ck pull repo:mlcommons@ck-mlops

# Install packages to CK env entries
RUN ck setup kernel --var.install_to_env=yes

RUN ck detect platform.os --platform_init_uoa=generic-linux-dummy
RUN ck detect soft:compiler.python --full_path=/usr/bin/python3

RUN ck detect soft:compiler.gcc --full_path=`which gcc`

RUN ck install package --tags=tool,cmake,prebuilt,v3.18.2

RUN ck install package --tags=lib,python-package,absl
RUN ck install package --tags=lib,python-package,numpy
RUN ck install package --tags=lib,python-package,scipy
RUN ck install package --tags=lib,python-package,matplotlib
RUN ck install package --tags=lib,python-package,cython
RUN ck install package --tags=lib,python-package,pillow
RUN ck install package --tags=lib,python-package,opencv-python-headless

# Need to change to OctoML branch soon
RUN ck install package --tags=mlperf,inference,src,octoml.dev
RUN ck install package --tags=lib,python-package,mlperf,loadgen

RUN ck install package --tags=tool,coco,api

RUN ck install package --tags=dataset,coco,val,2017,full

RUN ck install package --tags=lib,python-package,onnxruntime-cpu,1.7.0
RUN ck install package --tags=lib,python-package,onnx,1.9.0

RUN ck install package --tags=compiler,llvm,prebuilt,v12.0.0

RUN ck install package --tags=compiler,tvm,dev --env.CK_HOST_CPU_NUMBER_OF_PROCESSORS=4

RUN ck install package --tags=model,object-detection,mlperf,onnx,ssd-mobilenet,side.300,non-quantized,opset-8
RUN ck install package --tags=model,object-detection,mlperf,onnx,ssd-mobilenet,side.300,non-quantized,opset-11
RUN ck install package --tags=model,object-detection,mlperf,onnx,ssd-resnet34,side.1200,non-quantized,opset-8

# Install MLPerf task requirements
RUN ck run program:mlperf-inference-bench-object-detection-tvm-onnx-cpu --cmd_key=install-python-requirements

# Run TVM-based MLPerf inference benchmark (Offline;Accuracy)
CMD ck run program:mlperf-inference-bench-object-detection-tvm-onnx-cpu \
          --cmd_key=accuracy-offline \
          --env.MLPERF_TVM_TARGET="llvm -mcpu=znver2" \
          --env.MLPERF_TVM_EXECUTOR=vm \
          --env.EXTRA_OPS="--count 100 --thread 1 --max-batchsize 1"
