# To push a new version, run:
# $ docker build -f Dockerfile.rbe.cuda10.0-cudnn7-ubuntu14.04 \
#       --tag "gcr.io/tensorflow-testing/nosla-cuda10.0-cudnn7-ubuntu14.04" .
# $ docker push gcr.io/tensorflow-testing/nosla-cuda10.0-cudnn7-ubuntu14.04

FROM gcr.io/clang-docker-builder/clang-ubuntu14_04
LABEL maintainer="Manuel Klimek <klimek@google.com>"

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates apt-transport-https gnupg-curl && \
    rm -rf /var/lib/apt/lists/* && \
    NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 && \
    NVIDIA_GPGKEY_FPR=ae09fe4bbd223a84b2ccfce3f60f4b3d7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub && \
    apt-key adv --export --no-emit-version -a $NVIDIA_GPGKEY_FPR | tail -n +2 > cudasign.pub && \
    echo "$NVIDIA_GPGKEY_SUM  cudasign.pub" | sha256sum -c --strict - && rm cudasign.pub && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

ENV CUDA_VERSION 10.0.130
ENV CUDA_PKG_VERSION 10-0=$CUDA_VERSION-1
ENV CUDNN_VERSION 7.3.1.20
ENV TENSORRT_VERSION 5.0.2
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.0,driver>=410"
ENV NVIDIA_VISIBLE_DEVICES all
ENV PATH /usr/local/cuda/bin:${PATH}

# TODO(b/110903506): /usr/loca/cuda/lib64/stubs should not be needed in
# LD_LIBRARY_PATH. The stubs/libcuda.so is not meant to used at runtime. The
# correct way to pass the path to bfd-ld is to pass
# -Wl,-rpath-link=/usr/local/cuda/lib64/stubs to all binaries transitively
# depending on libcuda. Optimally, builds targeting cuda would do that
# internally.
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64/stubs

LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-command-line-tools-$CUDA_PKG_VERSION \
        cuda-compat-10-0=410.48-1 \
        cuda-cudart-$CUDA_PKG_VERSION \
        cuda-libraries-$CUDA_PKG_VERSION \
        cuda-libraries-dev-$CUDA_PKG_VERSION \
        cuda-minimal-build-$CUDA_PKG_VERSION \
        cuda-nvml-dev-$CUDA_PKG_VERSION \
        cuda-nvtx-$CUDA_PKG_VERSION \
        libcudnn7=$CUDNN_VERSION-1+cuda10.0 \
        libcudnn7=$CUDNN_VERSION-1+cuda10.0 \
        libcudnn7-dev=$CUDNN_VERSION-1+cuda10.0 \
        nvinfer-runtime-trt-repo-ubuntu1604-$TENSORRT_VERSION-ga-cuda10.0 && \
    apt-get update && apt-get install -y --no-install-recommends \
        libnvinfer5=$TENSORRT_VERSION-1+cuda10.0 \
        libnvinfer-dev=$TENSORRT_VERSION-1+cuda10.0 && \
    ln -s cuda-10.0 /usr/local/cuda && \
    apt-mark hold libcudnn7 && \
    rm -rf /var/lib/apt/lists/*

# TODO(b/110903506): Provide a link to the SONAME of libcuda.so.
# https://github.com/NVIDIA/nvidia-docker/issues/775
RUN ln -s libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1

# Install a newer version of g++:
# - we need a new libstdc++, because new clang versions do not work with a stock
#   ubuntu 14.04 libstdc++.
# - we want to compile with g++-7 to get ahead of LLVM dropping support for
#   gcc 4.8.
RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends g++-7 && \
    rm -rf /var/lib/apt/lists/*

# Copy and run the install scripts.
COPY install/*.sh /install/
ARG DEBIAN_FRONTEND=noninteractive
RUN /install/install_bootstrap_deb_packages.sh
RUN add-apt-repository -y ppa:openjdk-r/ppa && \
    add-apt-repository -y ppa:george-edison55/cmake-3.x
RUN /install/install_deb_packages.sh
RUN /install/install_pip_packages.sh
RUN /install/install_golang.sh

