# Dockerfile to build a manylinux 2010 compliant cross-compiler.
#
# Builds a devtoolset gcc/libstdc++ that targets manylinux 2010 compatible
# glibc (2.12) and system libstdc++ (4.4).
#
# To push a new version, run:
# $ docker build -f Dockerfile.rbe.cuda11.4-cudnn8.2-ubuntu20.04-manylinux2014-multipython \
#  --tag "gcr.io/tensorflow-testing/nosla-cuda11.4-cudnn8.2-ubuntu20.04-manylinux2014-multipython" .
# $ docker push gcr.io/tensorflow-testing/nosla-cuda11.4-cudnn8.2-ubuntu20.04-manylinux2014-multipython

FROM nvidia/cuda:11.4.1-cudnn8-devel-ubuntu20.04 as devtoolset

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
FROM nvidia/cuda:11.4.1-cudnn8-devel-ubuntu20.04
COPY --from=devtoolset /dt7 /dt7
COPY --from=devtoolset /dt9 /dt9

# Install TensorRT.
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        libnvinfer-dev=8.0.1-1+cuda11.3 \
        libnvinfer8=8.0.1-1+cuda11.3 \
        libnvinfer-plugin-dev=8.0.1-1+cuda11.3 \
        libnvinfer-plugin8=8.0.1-1+cuda11.3 && \
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
