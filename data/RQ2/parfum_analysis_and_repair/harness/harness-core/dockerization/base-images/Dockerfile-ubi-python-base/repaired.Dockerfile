# Copyright 2022 Harness Inc. All rights reserved.
# Use of this source code is governed by the PolyForm Free Trial 1.0.0 license
# that can be found in the licenses directory at the root of this repository, also available at
# https://polyformproject.org/wp-content/uploads/2020/05/PolyForm-Free-Trial-1.0.0.txt.

# UBI BASE IMAGE + PYTHON

# Usage: Application runtime base image for python based applications
# Test image locally by running this command:
#
# $ docker build \
#     -f Dockerfile-ubi--java-base" \
#     -t <tag> \
#     .
# Python Application runtime base image
FROM us.gcr.io/platform-205701/ubi/ubi-base:latest

USER root

ENV PYTHON_VERSION=3.8 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    CNB_STACK_ID=com.redhat.stacks.ubi8-python-38 \
    CNB_USER_ID=1001 \
    CNB_GROUP_ID=0 \
    PIP_NO_CACHE_DIR=off

RUN INSTALL_PKGS="bsdtar \
  findutils \
  groff-base \
  glibc-locale-source \
  glibc-langpack-en \
  gettext \
  rsync \
  scl-utils \
  tar \
  unzip \
  xz \
  yum" && \
  mkdir -p ${HOME}/.pki/nssdb && \
  chown -R 1001:0 ${HOME}/.pki && \
  yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS --skip-broken && \
  rpm -V $INSTALL_PKGS && \
  yum -y clean all --enablerepo='*' && rm -rf /var/cache/yum

RUN INSTALL_PKGS="autoconf \
  automake \
  bzip2 \
  gcc-c++ \
  gd-devel \
  gdb \
  git \
  libcurl-devel \
  libpq-devel \
  libxml2-devel \
  libxslt-devel \
  lsof \
  make \
  mariadb-connector-c-devel \
  openssl-devel \
  patch \
  procps-ng \
  npm \
  redhat-rpm-config \
  sqlite-devel \
  unzip \
  wget \
  which \
  zlib-devel" && \
  yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS --skip-broken && \
  rpm -V $INSTALL_PKGS && \
  yum -y clean all --enablerepo='*' && rm -rf /var/cache/yum


RUN INSTALL_PKGS="python38 python38-devel python38-setuptools python38-pip nss_wrapper \
        httpd httpd-devel mod_ssl mod_auth_gssapi mod_ldap \
        mod_session atlas-devel gcc-gfortran libffi-devel libtool-ltdl enchant" && \
    yum -y module enable python38:3.8 httpd:2.4 && \
    yum -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    # Remove redhat-logos-httpd (httpd dependency) to keep image size smaller.
    rpm -e --nodeps redhat-logos-httpd && \
    yum -y clean all --enablerepo='*' && \
    alternatives --set python /usr/bin/python3 && ln -s /usr/bin/pip3 /usr/bin/pip && \
    rm -rf ~/.cache/pip/selfcheck/* && \
    rm -rf ~/.cache/pip/http/* && \
    pip list --outdated && \
    pip install --no-cache-dir -U pip-upgrade-outdated && \
    pip_upgrade_outdated -3 -v -x distlib -x rsa -x docutils && \
    pip list --outdated && \
    pip uninstall -y pip-upgrade-outdated && \
    rm -rf ~/.cache/pip/selfcheck/* && \
    rm -rf ~/.cache/pip/http/*

USER 65534