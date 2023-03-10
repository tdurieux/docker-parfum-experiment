# -*- Mode: Dockerfile -*-
# Dockerfile for building Python pypi package
#
# Usage:
#
# Copy this template file and replace:
# - `{{ TYPE }}` with a valid manylinux type, e.g., 2010 or 2014.
# - `{{ ARCH }}` with a valid arch, e.g., x86_64 or i686.
# Remove the `.template` suffix from the copy.
#
# Build:
#
#     docker build -t dlite-manylinux -f .github/docker/Dockerfile-manylinux .
#
# Run (for debugging):
#
#     docker run --rm -it \
#        --volume $PWD:/io \
#        --user $(id -u):$(id -g) \
#        dlite-manylinux \
#        /bin/bash
#

# Reference: https://github.com/pypa/manylinux#manylinux2014-centos-7-based
FROM quay.io/pypa/manylinux{{ TYPE }}_{{ ARCH }}:latest

ARG PY_MINORS="7 8 9 10"

COPY requirements.txt /tmp/requirements.txt

{{ EXTRA_PRE }}

# Enable rpmfusion for additional packages
RUN yum update -y && \
  yum localinstall -y --skip-broken \
    https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm --eval %{centos_ver}).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm --eval %{centos_ver}).noarch.rpm && \
  yum install -y \
    redland-devel \
    rasqal-devel \
    swig \
    libcurl-devel \
    libxslt-devel \
    libxml2-devel && \
  if [ "{{ TYPE }}{{ ARCH }}" != "2014i686" ]; then yum install -y hdf5-devel; fi && \
  if [ -f "/etc/yum.repos.d/pgdg-91.repo" ]; then yum install -y postgresql91-devel; fi && \
# Unpack static libraries
# It's necessary to be in /opt/_internal because the internal libraries
# exist here.
  cd /opt/_internal && \
  tar -Jxvf static-libs-for-embedding-only.tar.xz && \
  mkdir -p /ci/pip_cache && \
  if [ -f "/etc/yum.repos.d/pgdg-91.repo" ]; then export PATH="$PATH:/usr/pgsql-9.1/bin"; fi && \
  for minor in ${PY_MINORS}; do \
    python3.${minor} -m pip install -U pip && \
    python3.${minor} -m pip install -U setuptools wheel && \
    python3.${minor} -m pip install -U --cache-dir /ci/pip_cache cmake oldest-supported-numpy && \
    python3.${minor} -m pip install --cache-dir /ci/pip_cache --prefer-binary -r /tmp/requirements.txt; \
  done && rm -rf /var/cache/yum

{{ EXTRA_POST }}
