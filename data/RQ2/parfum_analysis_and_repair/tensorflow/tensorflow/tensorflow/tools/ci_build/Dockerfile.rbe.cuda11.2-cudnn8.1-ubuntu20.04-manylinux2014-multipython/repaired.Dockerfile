# Dockerfile to build a manylinxu2010/manylinux 2014 compliant cross-compiler.
#
# Builds a devtoolset-7 environment with manylinux2010 compatible glibc (2.12) and
# libstdc++ (4.4) in /dt7.
#
# Builds a devtoolset-9 environment with manylinux2014 compatible glibc (2.17) and
# libstdc++ (4.8) in /dt9.
#
# To push a new version, run:
# $ docker build -f Dockerfile.rbe.cuda11.2-cudnn8.1-ubuntu20.04-manylinux2014-multipython \
#  --tag "gcr.io/tensorflow-testing/nosla-cuda11.2-cudnn8.1-ubuntu20.04-manylinux2014-multipython" .
# $ docker push gcr.io/tensorflow-testing/nosla-cuda11.2-cudnn8.1-ubuntu20.04-manylinux2014-multipython

FROM nvidia/cuda:11.2.1-cudnn8-devel-ubuntu20.04 as devtoolset

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
      cpio \
      file \
      flex \
      g++ \
      make \
      patch \
      rpm2cpio \
      unar \
      wget \
      xz-utils \
      && \
    rm -rf /var/lib/apt/lists/*

ADD devtoolset/fixlinks.sh fixlinks.sh
ADD devtoolset/build_devtoolset.sh build_devtoolset.sh
ADD devtoolset/rpm-patch.sh rpm-patch.sh

# Set up a sysroot for glibc 2.12 / libstdc++ 4.4 / devtoolset-7 in /dt7.
RUN /build_devtoolset.sh devtoolset-7 /dt7
# Set up a sysroot for glibc 2.17 / libstdc++ 4.8 / devtoolset-9 in /dt9.
RUN /build_devtoolset.sh devtoolset-9 /dt9

# TODO(klimek): Split up into two different docker images.
FROM nvidia/cuda:11.2.1-cudnn8-devel-ubuntu20.04
COPY --from=devtoolset /dt7 /dt7
COPY --from=devtoolset /dt9 /dt9

# Install TensorRT.
RUN echo \
    deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 / \
    > /etc/apt/sources.list.d/nvidia-ml.list \
      && \
    apt-get update && apt-get install --no-install-recommends -y \
    libnvinfer-dev=7.2.2-1+cuda11.1 \
    libnvinfer7=7.2.2-1+cuda11.1 \
    libnvinfer-plugin-dev=7.2.2-1+cuda11.1 \
    libnvinfer-plugin7=7.2.2-1+cuda11.1 \
      && \
    rm -rf /var/lib/apt/lists/*

# Copy and run the install scripts.
ARG DEBIAN_FRONTEND=noninteractive

COPY install/install_bootstrap_deb_packages.sh /install/
RUN /install/install_bootstrap_deb_packages.sh

COPY install/install_deb_packages.sh /install/
RUN /install/install_deb_packages.sh

# Install additional packages needed for this image:
# - dependencies to build Python from source
# - patchelf, as it is required by auditwheel
RUN apt-get update && apt-get install --no-install-recommends -y \
    libbz2-dev \
    libffi-dev \
    libgdbm-dev \
    libncurses5-dev \
    libnss3-dev \
    libreadline-dev \
    libsqlite3-dev \
    patchelf \
      && \
    rm -rf /var/lib/apt/lists/*

COPY install/install_bazel.sh /install/
RUN /install/install_bazel.sh

COPY install/build_and_install_python.sh /install/
RUN /install/build_and_install_python.sh "3.7.7"
RUN /install/build_and_install_python.sh "3.8.2"
RUN /install/build_and_install_python.sh "3.9.4"
RUN /install/build_and_install_python.sh "3.10.0"

COPY install/install_pip_packages_by_version.sh /install/
RUN /install/install_pip_packages_by_version.sh "/usr/local/bin/pip3.7"
RUN /install/install_pip_packages_by_version.sh "/usr/local/bin/pip3.8"
RUN /install/install_pip_packages_by_version.sh "/usr/local/bin/pip3.9"
RUN /install/install_pip_packages_by_version.sh "/usr/local/bin/pip3.10"

# Clang is not available for Ubuntu 20.04 in Google mirror so we download the
# official release
ENV CLANG_VERSION="11.0.0"
COPY install/install_latest_clang_ml2014.sh /install/
RUN /install/install_latest_clang_ml2014.sh

# TensorRT 7 for CUDA 11.1 is compatible with CUDA 11.2, but requires
# libnvrtc.so.11.1. See https://github.com/NVIDIA/TensorRT/issues/1064.
# TODO(b/187962120): Remove when upgrading to TensorRT 8.
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/cuda-11.1/lib64"
