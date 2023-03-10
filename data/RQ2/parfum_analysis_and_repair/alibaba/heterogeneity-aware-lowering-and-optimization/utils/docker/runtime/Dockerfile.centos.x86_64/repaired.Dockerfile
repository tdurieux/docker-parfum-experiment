FROM centos:7

RUN yum install -y \
        bzip2 \
        wget \
        python3 \
        yum-utils && \
    yum clean all && \
    rm -rf /var/cache/yum/*

RUN yum install -y centos-release-scl && \
    yum install -y devtoolset-7-gcc-c++-7.3.1 && \
    yum clean all && \
    rm -rf /var/cache/yum/*

SHELL ["/usr/bin/scl", "enable", "devtoolset-7"]
WORKDIR /tmp

# Install CUDA driver dependencies
RUN wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-14.noarch.rpm && \
    rpm -Uvh epel-release*rpm && \
    rm -rf *.rpm
RUN yum install -y opencl-filesystem && \
    yum clean all && \
    rm -rf /var/cache/yum/*

RUN yum-config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-rhel7.repo

# Install CUDA driver
ENV NV_LATEST_VERSION 460.106.00
RUN yum upgrade -y && \
    yum install -y nvidia-driver-latest-${NV_LATEST_VERSION} && \
    yum clean all && \
    rm -rf /var/cache/yum/*

# Install CUDA runtime
ENV NV_CUDA_CUDART_VERSION 11.4.108-1
RUN yum install -y \
        cuda-cudart-11-4-${NV_CUDA_CUDART_VERSION} \
        cuda-compat-11-4 && \
    ln -s cuda-11.4 /usr/local/cuda && \
    yum clean all && \
    rm -rf /var/cache/yum/*

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia:${LD_LIBRARY_PATH}

ENV NV_CUDA_LIB_VERSION 11.4.2-1
ENV NV_NVTX_VERSION 11.4.120-1
ENV NV_LIBNPP_VERSION 11.4.0.110-1
ENV NV_LIBCUBLAS_VERSION 11.6.1.51-1
ENV NV_LIBNCCL_PACKAGE_VERSION 2.11.4-1

RUN yum install -y \
        cuda-libraries-11-4-${NV_CUDA_LIB_VERSION} \
        cuda-nvtx-11-4-${NV_NVTX_VERSION} \
        libnpp-11-4-${NV_LIBNPP_VERSION} \
        libcublas-11-4-${NV_LIBCUBLAS_VERSION} \
        libnccl-${NV_LIBNCCL_PACKAGE_VERSION}+cuda11.4 && \
    yum clean all && \
    rm -rf /var/cache/yum/*

# Install tenssort
ENV NV_CUDNN_VERSION 8.2.4.15-1.cuda11.4
ENV NV_NVINFER_DEV_VERSION=8.2.5-1.cuda11.4
RUN yum install -y  \
        libnvinfer-plugin8-${NV_NVINFER_DEV_VERSION} \
        libnvparsers8-${NV_NVINFER_DEV_VERSION}  \
        libnvinfer8-${NV_NVINFER_DEV_VERSION} && \
    yum clean all && \
    rm -rf /var/cache/yum/*

# Install HALO
ARG HALO_PKG
WORKDIR /tmp
COPY ${HALO_PKG} .
RUN rm -fr /opt/halo && mkdir -p /opt/halo && \
    tar jxf ${HALO_PKG} -C /opt/halo --strip-components=1 && \
    rm /tmp/*
ENV PATH="${PATH}:/opt/halo/bin"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/opt/halo/lib"

WORKDIR /root

RUN echo "source scl_source enable devtoolset-7" >> /etc/bashrc
