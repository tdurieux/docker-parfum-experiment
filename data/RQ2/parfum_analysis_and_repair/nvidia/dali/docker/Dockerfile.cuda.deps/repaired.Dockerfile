#########################################################################################
## Get manylinux image with any neccessary DALI dependencies.
## It is possible to just use defaults and have a pure manylinux2014 with CUDA on top
## DALI is based on "manylinux2014", official page https://github.com/pypa/manylinux
#########################################################################################
ARG FROM_IMAGE_NAME=quay.io/pypa/manylinux2014_x86_64
ARG CUDA_IMAGE
FROM ${CUDA_IMAGE} as cuda
FROM ${FROM_IMAGE_NAME}

ENV PATH=/usr/local/cuda/bin:${PATH}

ENV NVIDIA_DRIVER_CAPABILITIES=video,compute,utility

# CUDA