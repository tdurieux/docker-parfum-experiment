# To push a new version, run:
# $ docker build -f Dockerfile.rbe.cuda9.0-cudnn7-ubuntu14.04 \
#       --tag "gcr.io/asci-toolchain/nosla-cuda9.0-cudnn7-ubuntu14.04" .
# $ docker push gcr.io/asci-toolchain/nosla-cuda9.0-cudnn7-ubuntu14.04
#
# TODO(klimek): Include clang in this image so we can also target clang
# builds.

FROM ubuntu:14.04
LABEL maintainer="Manuel Klimek <klimek@google.com>"

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates apt-transport-https gnupg-curl && \
    rm -rf /var/lib/apt/lists/* && \
    NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 && \
    NVIDIA_GPGKEY_FPR=ae09fe4bbd223a84b2ccfce3f60f4b3d7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/7fa2af80.pub && \
    apt-key adv --export --no-emit-version -a $NVIDIA_GPGKEY_FPR | tail -n +2 > cudasign.pub && \
    echo "$NVIDIA_GPGKEY_SUM cudasign.pub" | sha256sum -c --strict - && rm cudasign.pub && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

ENV CUDA_VERSION 9.0.176
ENV CUDA_PKG_VERSION 9-0=$CUDA_VERSION-1
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=9.0"
ENV NCCL_VERSION 2.2.13
ENV CUDNN_VERSION 7.1.4.18

# TODO(b/110903506): /usr/loca/cuda/lib64/stubs should not be needed in
# LD_LIBRARY_PATH. The stubs/libcuda.so is not meant to used at runtime. The
# correct way to pass the path to bfd-ld is to pass
# -Wl,-rpath-link=/usr/local/cuda/lib64/stubs to all binaries transitively
# depending on libcuda. Optimally, builds targeting cuda would do that
# internally.
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/local/cuda/lib64/stubs

LABEL com.nvidia.volumes.needed="nvidia_driver"
LABEL com.nvidia.cuda.version="${CUDA_VERSION}"
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-cudart-$CUDA_PKG_VERSION \
        cuda-libraries-$CUDA_PKG_VERSION \
        cuda-cublas-9-0=9.0.176.4-1 \
        libnccl2=$NCCL_VERSION-1+cuda9.0 \
        cuda-libraries-dev-$CUDA_PKG_VERSION \
        cuda-nvml-dev-$CUDA_PKG_VERSION \
        cuda-minimal-build-$CUDA_PKG_VERSION \
        cuda-command-line-tools-$CUDA_PKG_VERSION \
        cuda-core-9-0=9.0.176.3-1 \
        cuda-cublas-dev-9-0=9.0.176.4-1 \
        libnccl-dev=$NCCL_VERSION-1+cuda9.0 \
        libcudnn7-dev=$CUDNN_VERSION-1+cuda9.0 \
        libcudnn7=$CUDNN_VERSION-1+cuda9.0 && \
    ln -s cuda-9.0 /usr/local/cuda && \
    apt-mark hold libnccl2 && \
    apt-mark hold libcudnn7 libcudnn7-dev && \
    rm -rf /var/lib/apt/lists/*

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

# TODO(b/110903506): Provide a link to the SONAME of libcuda.so.
# https://github.com/NVIDIA/nvidia-docker/issues/775
RUN ln -s libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1

# TODO(klimek): Once the TODO in tensorflow's configure.py to correctly find
# libnccl is resolved, delete this block.
RUN ln -s /usr/lib/x86_64-linux-gnu/libnccl.so /usr/lib/libnccl.so \
 && ln -s /usr/lib/x86_64-linux-gnu/libnccl.so /usr/lib/libnccl.so.2

# Copy and run the install scripts.
COPY install/*.sh /install/
ARG DEBIAN_FRONTEND=noninteractive
RUN /install/install_bootstrap_deb_packages.sh
RUN add-apt-repository -y ppa:openjdk-r/ppa && \
    add-apt-repository -y ppa:george-edison55/cmake-3.x
RUN /install/install_deb_packages.sh
RUN /install/install_pip_packages.sh
RUN /install/install_golang.sh

