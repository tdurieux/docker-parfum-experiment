# -*- Mode: Dockerfile -*-
# Dockerfile for building Python pypi package with musllinux
#
# Usage:
#
# Copy this template file and replace:
# - `{{ TYPE }}` with a valid musllinux type.
#   For now only '_1_1' is allowed.
# - `{{ ARCH }}` with a valid arch, e.g., x86_64 or i686.
# Remove the `.template` suffix from the copy.
#
# Build:
#
#     docker build -t dlite-musllinux -f .github/docker/Dockerfile-musllinux .
#
# Run (for debugging):
#
#     docker run --rm -it \
#        --volume $PWD:/io \
#        --user $(id -u):$(id -g) \
#        dlite-musllinux \
#        /bin/bash
#
FROM quay.io/pypa/musllinux{{ TYPE }}_{{ ARCH }}:latest

COPY requirements.txt /tmp/requirements.txt

RUN apk add --no-cache -u \
  redland \
  rasqal \
  hdf5 \
  swig && \
# Unpack static libraries
# It's necessary to be in /opt/_internal because the internal libraries
# exist here.
  cd /opt/_internal && \
  tar -Jxvf static-libs-for-embedding-only.tar.xz && \
  mkdir -p /ci/pip_cache && \
  for minor in 7 8 9 10; do \
    python3.${minor} -m pip install -U pip && \
    python3.${minor} -m pip install -U setuptools wheel && \
    python3.${minor} -m pip install -U --cache-dir /ci/pip_cache cmake oldest-supported-numpy && \
    python3.${minor} -m pip install --cache-dir /ci/pip_cache --prefer-binary -r /tmp/requirements.txt; \
  done && rm static-libs-for-embedding-only.tar.xz
