FROM quay.io/pypa/manylinux2010_x86_64
LABEL maintainer "Garrett Wright"

# ---- The following block adds layers for CUDA --- #
# base
RUN NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 && \
curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/rhel6/x86_64/7fa2af80.pub | sed '/^Version/d' > /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA && \
    echo "$NVIDIA_GPGKEY_SUM /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA" | sha256sum -c -

COPY ci/manylinux2010/cuda.repo /etc/yum.repos.d/cuda.repo

ENV CUDA_VERSION 10.1.243

ENV CUDA_PKG_VERSION 10-1-$CUDA_VERSION-1
# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN yum install -y \
cuda-cudart-$CUDA_PKG_VERSION \
cuda-compat-10-1 \
&& \
    ln -s cuda-10.1 /usr/local/cuda && \
    rm -rf /var/cache/yum/*

# nvidia-docker 1.0
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.1 brand=tesla,driver>=384,driver<385 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411"

#runtime
RUN yum install -y \
        cuda-libraries-$CUDA_PKG_VERSION \
cuda-nvtx-$CUDA_PKG_VERSION \
    libcublas10-10.2.1.243-1 \
    && \
    rm -rf /var/cache/yum/*

# devel
RUN yum install -y \
        cuda-nvml-dev-$CUDA_PKG_VERSION \
        cuda-command-line-tools-$CUDA_PKG_VERSION \
cuda-libraries-dev-$CUDA_PKG_VERSION \
        cuda-minimal-build-$CUDA_PKG_VERSION \
        libcublas-devel-10.2.1.243-1 \
        && \
    rm -rf /var/cache/yum/*

ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

# /CUDA #


# Okay, so now we can begin our code's stuff.
# ugh cmake, gross
RUN mkdir cmake-3.18.0-Linux-x86_64 && \
    cd cmake-3.18.0-Linux-x86_64 && \
    curl -fsSL https://github.com/Kitware/CMake/releases/download/v3.18.0/cmake-3.18.0-Linux-x86_64.sh -o cmake-3.18.0-Linux-x86_64.sh && \
    chmod +x cmake-3.18.0-Linux-x86_64.sh && \
    ./cmake-3.18.0-Linux-x86_64.sh   --skip-license

# We need to build the CUDA code now.
# assume we are building container in the root of the git repo...
COPY . /io
WORKDIR /io
# setup a build area, configures/generates makefiles
RUN mkdir build && \
    cd build && \
    /cmake-3.18.0-Linux-x86_64/bin/cmake ../ && \
    make install
# push the lib onto the path
#ENV LD_LIBRARY_PATH /io/lib:$LD_LIBRARY_PATH

CMD ["/bin/bash"]