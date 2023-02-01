# Taken from https://gitlab.com/nvidia/cuda/blob/ubuntu14.04/7.5/devel/Dockerfile
ARG IMAGE_VERSION=someversion
FROM hilbert/cuda_runtime:${IMAGE_VERSION}

MAINTAINER Oleksandr Motsak <malex984+hilbert.cuda.devel@gmail.com>

RUN update.sh \
&& install.sh \
        cuda-core-$CUDA_PKG_VERSION \
        cuda-misc-headers-$CUDA_PKG_VERSION \
        cuda-command-line-tools-$CUDA_PKG_VERSION \
        cuda-license-$CUDA_PKG_VERSION \
        cuda-nvrtc-dev-$CUDA_PKG_VERSION \
        cuda-cusolver-dev-$CUDA_PKG_VERSION \
        cuda-cublas-dev-$CUDA_PKG_VERSION \
        cuda-cufft-dev-$CUDA_PKG_VERSION \
        cuda-curand-dev-$CUDA_PKG_VERSION \
        cuda-cusparse-dev-$CUDA_PKG_VERSION \
        cuda-npp-dev-$CUDA_PKG_VERSION \
        cuda-cudart-dev-$CUDA_PKG_VERSION \
        cuda-driver-dev-$CUDA_PKG_VERSION \
        cuda-samples-$CUDA_PKG_VERSION \
&& cd /tmp && apt-get download gpu-deployment-kit \
&& mkdir /tmp/gpu-deployment-kit && cd /tmp/gpu-deployment-kit \
&& dpkg -x /tmp/gpu-deployment-kit_*.deb . \
&& mv usr/include/nvidia/gdk/* /usr/local/cuda/include \
&& mv usr/src/gdk/nvml/lib/* /usr/local/cuda/lib64/stubs \
&& rm -rf /var/lib/apt/lists/* /tmp/gpu-deployment-kit*

ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs:${LIBRARY_PATH}

##############################################################################
ARG GIT_NOT_CLEAN_CHECK
# Build-time metadata as defined at http://label-schema.org