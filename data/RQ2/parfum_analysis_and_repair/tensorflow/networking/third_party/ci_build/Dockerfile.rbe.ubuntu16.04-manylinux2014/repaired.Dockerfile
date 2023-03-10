# Dockerfile to build a manylinux 2014 compliant cross-compiler.
#
# Builds a devtoolset gcc/libstdc++ that targets manylinux 2014 compatible
# glibc (2.17) and system libstdc++ (4.8).

FROM ubuntu:16.04 as devtoolset

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bzip2 \
        cpio \
        curl \
        file \
        flex \
        g++ \
        make \
        patch \
        rpm2cpio \
        unar \
        tar \
        xz-utils \
        && \
    rm -rf /var/lib/apt/lists/*

ADD devtoolset/fixlinks.sh fixlinks.sh
ADD devtoolset/build_devtoolset.sh build_devtoolset.sh
ADD devtoolset/rpm-patch.sh rpm-patch.sh

# Set up a sysroot for glibc 2.17 / libstdc++ 4.8 / devtoolset-7 in /dt7.
RUN /build_devtoolset.sh devtoolset-7 /dt7
# Set up a sysroot for glibc 2.17 / libstdc++ 4.8 / devtoolset-8 in /dt8.
RUN /build_devtoolset.sh devtoolset-8 /dt8

FROM ubuntu:16.04
COPY --from=devtoolset /dt7 /dt7
COPY --from=devtoolset /dt8 /dt8

ARG DEBIAN_FRONTEND=noninteractive

# Install python 3.5/3.6/3.7/3.8.
RUN apt-get update && \
    apt-get install --no-install-recommends -yq software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install --no-install-recommends -yq \
        curl \
        python3.5-dev \
        python3.6-dev \
        python3.7-dev \
        python3.8-dev \
        python3.8-distutils \
        && \
    rm -rf /var/lib/apt/lists/*

RUN curl -f -O https://bootstrap.pypa.io/get-pip.py && \
    python3.5 get-pip.py && \
    python3.6 get-pip.py && \
    python3.7 get-pip.py && \
    python3.8 get-pip.py && \
    rm get-pip.py

RUN mkdir -p "/dt7/usr/include/x86_64-linux-gnu" && \
    ln -s "/usr/include/x86_64-linux-gnu/python3.5m" "/dt7/usr/include/x86_64-linux-gnu/python3.5m" && \
    ln -s "/usr/include/x86_64-linux-gnu/python3.6m" "/dt7/usr/include/x86_64-linux-gnu/python3.6m" && \
    ln -s "/usr/include/x86_64-linux-gnu/python3.7m" "/dt7/usr/include/x86_64-linux-gnu/python3.7m" && \
    ln -s "/usr/include/x86_64-linux-gnu/python3.8" "/dt7/usr/include/x86_64-linux-gnu/python3.8"

RUN mkdir -p "/dt8/usr/include/x86_64-linux-gnu" && \
    ln -s "/usr/include/x86_64-linux-gnu/python3.5m" "/dt8/usr/include/x86_64-linux-gnu/python3.5m" && \
    ln -s "/usr/include/x86_64-linux-gnu/python3.6m" "/dt8/usr/include/x86_64-linux-gnu/python3.6m" && \
    ln -s "/usr/include/x86_64-linux-gnu/python3.7m" "/dt8/usr/include/x86_64-linux-gnu/python3.7m" && \
    ln -s "/usr/include/x86_64-linux-gnu/python3.8" "/dt8/usr/include/x86_64-linux-gnu/python3.8"

# TensorFlow dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        default-jdk-headless \
        git \
        patchelf \
        pkg-config \
        python \
        unzip \
        zip \
        zlib1g-dev \
        && \
    rm -rf /var/lib/apt/lists/*

# Install auditwheel
RUN pip3 install --no-cache-dir -U auditwheel
