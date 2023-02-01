# Adaptive container with the CK interface
# Concept: https://arxiv.org/abs/2011.01149

# DOESN'T WORK! Fails with:
#INFO:main:starting TestScenario.Offline
#/usr/include/c++/9/bits/atomic_base.h:416: std::__atomic_base<_IntTp>::__int_type std::__atomic_base<_IntTp>::load(std::memory_order) const [with _ITp = long int; std::__atomic_base<_IntTp>::__int_type = long int; std::memory_order = std::memory_order]: Assertion '__b != memory_order_release' failed.
#./run_local.sh: line 19:    77 Aborted                 (core dumped) ${PYTHON} python/main.py --profile $profile $common_opt --model $model_path $dataset --output $OUTPUT_DIR $EXTRA_OPS $@
#

FROM centos:8

# Contact
LABEL maintainer="Grigori Fursin <grigori@octoml.ai>"

# Shell info
SHELL ["/bin/bash", "-c"]
#ENTRYPOINT ["/bin/bash", "-c"]

# Set noninteractive mode for apt (do not use ENV)
ARG DEBIAN_FRONTEND=noninteractive

# Notes: https://runnable.com/blog/9-common-dockerfile-mistakes
# Install system dependencies with gcc-10 (gcc-8 doesn't compile loadgen)
RUN yum update -y && \
    yum install -y \
           git wget zip bzip2 cmake curl unzip \
           vim mc tree patch \
           gcc-toolset-9-* autoconf libtool make \
           openssl-devel bzip2-devel libffi-devel \
           dnf dnf-plugins-core \
           sudo && rm -rf /var/cache/yum

RUN yum config-manager --set-enabled powertools
RUN dnf install -y python3 python3-pip python3-devel
RUN dnf --enablerepo=powertools install -y libsndfile-devel

# Prepare a user with a user group with a random id
RUN groupadd -g 1111 ckuser
RUN useradd -u 2222 -g ckuser --create-home --shell /bin/bash ckuser
RUN echo "ckuser:ckuser" | chpasswd
RUN echo "ckuser   ALL=(ALL)  NOPASSWD:ALL" >> /etc/sudoers

# Set user
USER ckuser:ckuser
WORKDIR /home/ckuser
ENV PATH="/home/ckuser/.local/bin:${PATH}"
RUN mkdir .ssh

RUN python3 --version

# Switch to gcc-10 for a user
# Toolset gcc-9 doesn't seem to work well with clang/tvm
#ENV PATH=/opt/rh/gcc-toolset-10/root/bin:$PATH
# LIBRARY_PATH is needed to compile TVM via LLVM for std++ lib
#ENV LIBRARY_PATH=/opt/rh/gcc-toolset-10/root/lib/gcc/x86_64-redhat-linux/10

# Grigori tried different ways to enable GCC but they fail
# on CentOS-8 with TVM. Here is another and not very elegant solution:
RUN sudo cp -rf /opt/rh/gcc-toolset-9/root/usr/* /usr

RUN gcc --version
RUN g++ --version

# Need to upgrade pip (otherwise different problems)
RUN python3 -m pip install --upgrade pip --user

# Install CK
RUN export DUMMY_CK=A
RUN ${DUMMY_CK} python3 -m pip install ck --user
RUN ${DUMMY_CK} python3 -m pip install wheel  --user

# Clone private CK repo
RUN ck pull repo:mlcommons@ck-mlops

# Install packages to CK env entries
RUN ck setup kernel --var.install_to_env=yes

RUN ck detect platform.os --platform_init_uoa=generic-linux-dummy
RUN ck detect soft:compiler.python --full_path=/usr/bin/python3

RUN ck detect soft:compiler.gcc --full_path=`which gcc`

RUN python3 -m pip install protobuf --user

RUN ck install package --tags=mlperf,inference,src,octoml.dev

RUN ck install package --tags=lib,python-package,absl

RUN ck install package --tags=lib,python-package,numpy

RUN ck install package --tags=lib,python-package,mlperf,loadgen

RUN ck install package --tags=lib,python-package,matplotlib

RUN ck install package --tags=lib,python-package,cython

RUN ck install package --tags=lib,python-package,opencv-python-headless

RUN ck install package --tags=tool,coco,api

RUN ck install package --tags=imagenet,2012,val,min,non-resized
RUN ck install package --tags=imagenet,2012,aux,from.berkeley

RUN ck install package --tags=lib,python-package,onnxruntime-cpu,1.7.0
RUN ck install package --tags=lib,python-package,onnx,1.9.0

RUN ck install package --tags=model,image-classification,mlperf,onnx,resnet50,v1.5-opset-11

RUN ck install package --tags=lib,python-package,scipy

RUN ck install package --tags=tool,cmake,prebuilt,v3.18.2

# Prebuilt LLVM doesn't seem to work correctly via CK
RUN ck install package --tags=compiler,llvm,src,v12.0.0

RUN ck install package --tags=compiler,tvm,dev --env.CK_HOST_CPU_NUMBER_OF_PROCESSORS=4

# Install MLPerf task requirements
RUN ck run program:mlperf-inference-bench-image-classification-tvm-onnx-cpu --cmd_key=install-python-requirements

# Run TVM-based MLPerf inference benchmark (Offline;Accuracy)
CMD ck run program:mlperf-inference-bench-image-classification-tvm-onnx-cpu \
          --cmd_key=accuracy-offline \
          --env.EXTRA_OPS="--thread 1 --max-batchsize 1"
