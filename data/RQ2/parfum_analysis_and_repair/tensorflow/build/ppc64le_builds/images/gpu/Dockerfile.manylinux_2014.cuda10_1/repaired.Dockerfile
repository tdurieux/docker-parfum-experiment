#docker build -f Dockerfile.manylinux_2014.cuda10_1 -t ibmcom/tensorflow-ppc64le:gpu-devel-manylinux2014 .
FROM ibmcom/tensorflow-ppc64le:devel-manylinux2014

#Copied from https://gitlab.com/nvidia/container-images/cuda-ppc64le/blob/centos7/10.1/base/Dockerfile

RUN NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/rhel7/ppc64le/7fa2af80.pub | sed '/^Version/d' > /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA && \
    echo "$NVIDIA_GPGKEY_SUM  /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA" | sha256sum -c --strict -

COPY cuda.repo /etc/yum.repos.d/cuda.repo

ENV CUDA_VERSION 10.1.243

ENV CUDA_PKG_VERSION 10-1-$CUDA_VERSION-1
RUN yum install -y \
        cuda-cudart-$CUDA_PKG_VERSION && \
    ln -s cuda-10.1 /usr/local/cuda && \
    rm -rf /var/cache/yum/*

# nvidia-docker 1.0
LABEL com.nvidia.volumes.needed="nvidia_driver"
LABEL com.nvidia.cuda.version="${CUDA_VERSION}"

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.1"

# Copied from https://gitlab.com/nvidia/container-images/cuda-ppc64le/blob/centos7/10.1/runtime/Dockerfile

RUN yum install -y \
        cuda-libraries-$CUDA_PKG_VERSION && \
    rm -rf /var/cache/yum/*

# Copied from https://gitlab.com/nvidia/container-images/cuda-ppc64le/blob/centos7/10.1/devel/Dockerfile

RUN yum install -y \
        cuda-libraries-dev-$CUDA_PKG_VERSION \
        cuda-nvml-dev-$CUDA_PKG_VERSION \
        cuda-minimal-build-$CUDA_PKG_VERSION \
        cuda-command-line-tools-$CUDA_PKG_VERSION && \
    rm -rf /var/cache/yum/*

ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

# Copied from https://gitlab.com/nvidia/container-images/cuda-ppc64le/blob/centos7/10.1/devel/cudnn7/Dockerfile

ENV CUDNN_VERSION 7.6.5.32
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

# cuDNN license: https://developer.nvidia.com/cudnn/license_agreement
RUN CUDNN_DOWNLOAD_SUM=97b2faf73eedfc128f2f5762784d21467a95b2d5ba719825419c058f427cbf56 && \
    curl -fsSL https://developer.download.nvidia.com/compute/redist/cudnn/v7.6.5/cudnn-10.1-linux-ppc64le-v7.6.5.32.tgz -O && \
    echo "$CUDNN_DOWNLOAD_SUM  cudnn-10.1-linux-ppc64le-v7.6.5.32.tgz" | sha256sum -c - && \
    tar --no-same-owner -xzf cudnn-10.1-linux-ppc64le-v7.6.5.32.tgz -C /usr/local && \
    rm cudnn-10.1-linux-ppc64le-v7.6.5.32.tgz && \
    ldconfig
