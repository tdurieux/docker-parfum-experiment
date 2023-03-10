# Dockerfile to build a manylinux 2014/2014 compliant cross-compiler.
#
# Builds a devtoolset-7 environment with manylinux2014 compatible
# glibc (2.12) and libstdc++ (4.4) in /dt7.
#
# Builds a devtoolset-9 environment with manylinux2014 compatible
# glibc (2.17) and libstdc++ (4.8) in /dt9.
#
# To build a new version, run:
# $ docker build -f Dockerfile.local-toolchain-ubuntu20.04-manylinux2014 \
#  --tag "local-toolchain-ubuntu20.04-manylinux2014" .

FROM ubuntu:20.04 as local-toolchain-ubuntu20.04-manylinux2014

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
