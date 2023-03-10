# Dockerfile to build a manylinux 2010 compliant cross-compiler.
#
# Builds a devtoolset gcc/libstdc++ that targets manylinux 2010 compatible
# glibc (2.12) and system libstdc++ (4.4).
#
# To push a new version, run:
# $ docker build -f Dockerfile.rbe.cuda10.2-cudnn7-ubuntu18.04-manylinux2010-multipython \
#  --tag "gcr.io/tensorflow-testing/nosla-cuda10.2-cudnn7-ubuntu18.04-manylinux2010-multipython" .
# $ docker push gcr.io/tensorflow-testing/nosla-cuda10.2-cudnn7-ubuntu18.04-manylinux2010-multipython

FROM gcr.io/tensorflow-testing/nosla-cuda10.0-cudnn7-ubuntu16.04-manylinux2010

RUN apt-get update
RUN apt-get remove -y --allow-change-held-packages cuda-license-10-0 libcudnn7 libcudnn8 libnccl2 libnccl-dev
RUN apt-get install -y --no-install-recommends --allow-downgrades --allow-change-held-packages \
  libcublas10 \
  libcublas-dev \
  cuda-nvml-dev-10.2 \
  cuda-command-line-tools-10.2 \
  cuda-libraries-dev-10.2 \
  cuda-minimal-build-10.2 \
  libcudnn7=7.6.5.32-1+cuda10.2 \
  libcudnn7-dev=7.6.5.32-1+cuda10.2 && rm -rf /var/lib/apt/lists/*;
RUN rm -f /usr/local/cuda
RUN ln -s /usr/local/cuda-10.2 /usr/local/cuda

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
    patchelf \
      && \
    rm -rf /var/lib/apt/lists/*

COPY install/install_bazel.sh /install/
RUN /install/install_bazel.sh

COPY install/build_and_install_python.sh /install/
RUN /install/build_and_install_python.sh "3.7.7"
RUN /install/build_and_install_python.sh "3.8.2"
RUN /install/build_and_install_python.sh "3.9.0"

COPY install/install_pip_packages_by_version.sh /install/
RUN /install/install_pip_packages_by_version.sh "/usr/local/bin/pip3.7"
RUN /install/install_pip_packages_by_version.sh "/usr/local/bin/pip3.8"
RUN /install/install_pip_packages_by_version.sh "/usr/local/bin/pip3.9"

ENV CLANG_VERSION="r42cab985fd95ba4f3f290e7bb26b93805edb447d"
COPY install/install_latest_clang.sh /install/
RUN /install/install_latest_clang.sh
