# Dockerfile for Ubuntu 16.04 manylinux2010 custom ops with GPU.

FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu16.04 as devtoolset

LABEL maintainer="Amit Patankar <amitpatankar@google.com>"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
      cpio \
      file \
      flex \
      g++ \
      make \
      rpm2cpio \
      unar \
      wget \
      && \
    rm -rf /var/lib/apt/lists/*

ADD devtoolset/fixlinks.sh fixlinks.sh
ADD devtoolset/build_devtoolset.sh build_devtoolset.sh
ADD devtoolset/rpm-patch.sh rpm-patch.sh

# Set up a sysroot for glibc 2.12 / libstdc++ 4.4 / devtoolset-7 in /dt7.
RUN /build_devtoolset.sh devtoolset-7 /dt7
# Set up a sysroot for glibc 2.12 / libstdc++ 4.4 / devtoolset-8 in /dt8.
RUN /build_devtoolset.sh devtoolset-8 /dt8

# TODO(klimek): Split up into two different docker images.
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu16.04

LABEL maintainer="Amit Patankar <amitpatankar@google.com>"

COPY --from=devtoolset /dt7 /dt7
COPY --from=devtoolset /dt8 /dt8

# Install TensorRT.
RUN apt-get update && apt-get install --no-install-recommends -y \
    libnvinfer-dev=5.1.5-1+cuda10.0 \
    libnvinfer5=5.1.5-1+cuda10.0 \
      && \
    rm -rf /var/lib/apt/lists/*

# Copy and run the install scripts.
COPY install/*.sh /install/
ARG DEBIAN_FRONTEND=noninteractive
RUN /install/install_bootstrap_deb_packages.sh
RUN /install/install_deb_packages.sh
RUN /install/install_clang.sh
RUN /install/install_bazel.sh
RUN /install/install_buildifier.sh

ENV TF_NEED_CUDA=1

# Install python 3.6.
RUN add-apt-repository ppa:jonathonf/python-3.6 && \
    apt-get update && apt-get install --no-install-recommends -y \
    python3.6 python3.6-dev python3-pip python3.6-venv && \
    rm -rf /var/lib/apt/lists/* && \
    python3.6 -m pip install pip --upgrade && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 0

RUN /install/install_pip_packages.sh
RUN /install/install_auditwheel.sh

# TODO(klimek): Figure out a better way to get the right include paths
# forwarded when we install new packages.
RUN ln -s "/usr/include/x86_64-linux-gnu/python3.6m" "/dt7/usr/include/x86_64-linux-gnu/python3.6m"
RUN ln -s "/usr/include/x86_64-linux-gnu/python3.6m" "/dt8/usr/include/x86_64-linux-gnu/python3.6m"
