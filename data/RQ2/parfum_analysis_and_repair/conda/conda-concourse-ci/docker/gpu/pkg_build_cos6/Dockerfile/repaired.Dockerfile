# Set environment variables during runtime.
ARG CUDA_VER
ARG CENTOS_VER=6
FROM nvidia/cuda:${CUDA_VER}-devel-centos${CENTOS_VER}
MAINTAINER Anthony DiPietro <adipietro@anaconda.com>

# build stages use these, re-set them.
ARG CUDA_VER
ARG CENTOS_VER=6
ENV CUDA_VER=${CUDA_VER} \
    CENTOS_VER=${CENTOS_VER}

# Set the locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set path to CUDA install (this is a symlink to /usr/local/cuda-${CUDA_VER})
ENV CUDA_HOME /usr/local/cuda

# Symlink CUDA headers that were moved from $CUDA_HOME/include to /usr/include
# in CUDA 10.1.
RUN for HEADER_FILE in cublas_api.h cublas.h cublasLt.h cublas_v2.h cublasXt.h nvblas.h; do \
    if [[ ! -f "${CUDA_HOME}/include/${HEADER_FILE}" ]]; \
      then ln -s "/usr/include/${HEADER_FILE}" "${CUDA_HOME}/include/${HEADER_FILE}"; \
    fi; \
    done

# Remove outdated repo URLs
RUN if [[ "$CENTOS_VER" == "6" ]]; then rm -rf /etc/yum.repos.d/CentOS-*; fi
# Add the archived centos6 repo URL