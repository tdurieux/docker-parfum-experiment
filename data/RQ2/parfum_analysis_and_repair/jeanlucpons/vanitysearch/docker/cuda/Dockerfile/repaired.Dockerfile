# Multistage docker build, requires docker 17.05

# CUDA SDK version, and also a prefix of images' tag.
# Check out the list of officially supported tags:
# https://gitlab.com/nvidia/container-images/cuda/blob/master/doc/supported-tags.md
# Format: x.y, e.g.: "10.2".
# Required argument.
ARG CUDA

# builder stage
FROM nvidia/cuda:${CUDA}-devel as builder

COPY . /app

# CUDA Computational Capability.
# Format: x.y, e.g.: "5.2".
# Required argument.
ARG CCAP

RUN cd /app && \
  make \
  CUDA=/usr/local/cuda \
  CXXCUDA=/usr/bin/g++ \
  gpu=1 \
  "CCAP=${CCAP}" \
  all

# runtime stage