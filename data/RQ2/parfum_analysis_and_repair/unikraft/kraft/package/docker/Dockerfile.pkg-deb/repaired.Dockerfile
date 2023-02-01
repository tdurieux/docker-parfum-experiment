# SPDX-License-Identifier: BSD-3-Clause
#
# Authors: Alexander Jung <alexander.jung@neclab.eu>
#
# Copyright (c) 2020, NEC Europe Ltd., NEC Corporation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

ARG PKG_VENDOR=debian
ARG PKG_DISTRIBUTION=stretch-20200224

FROM ${PKG_VENDOR}:${PKG_DISTRIBUTION}

LABEL MAINTAINER="Alexander Jung <alexander.jung@neclab.eu>"

WORKDIR /usr/src/kraft

COPY requirements-dev.txt /tmp/requirements-dev.txt
COPY requirements-pkg-deb.txt /tmp/requirements-pkg-deb.txt

ENV DEBIAN_FRONTEND=noninteractive

RUN set -xe; \
    apt-get update; \
    apt-get install --no-install-recommends -y \
      lsb-release; rm -rf /var/lib/apt/lists/*; \
    RELEASE=$(lsb_release -cs); \
    case ${RELEASE} in \
      trusty \
        apt-get install --no-install-recommends -y \
          python3.5; \
          update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.5 1; \
          ;; \
      sid|focal \
        apt-get install --no-install-recommends -y \
          python3-all \
          python3-pip; \
          update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1; \
          ;; \
      * \
        apt-get install --no-install-recommends -y \
          python3-all \
          python-mock \
          python-pip; \
          ;; \
        esac; \
    apt-get install --no-install-recommends -y \
      build-essential \
      debhelper \
      devscripts \
      equivs \
      libdpkg-perl \
      python \
      python-setuptools \
      python-dev \
      docutils-common \
      dh-exec \
      dh-python \
      devscripts \
      debhelper \
      python-setuptools \
      python3-setuptools \
      python3-dev \
      libncursesw5-dev \
      libyaml-dev \
      flex \
      git \
      wget \
      curl \
      socat \
      patch \
      gawk \
      bison \
      uuid-runtime; \
    case ${RELEASE} in \
      focal \
        pip install --no-cache-dir --upgrade --force-reinstall pip==9.0.3; \
        ;; \
      *) \
        python -m pip install --upgrade --force-reinstall pip==9.0.3; \
        ;; \
     esac; \
    pip install --no-cache-dir -r /tmp/requirements-dev.txt; \
    pip install --no-cache-dir -r /tmp/requirements-pkg-deb.txt; \
    git clone https://github.com/spotify/dh-virtualenv.git /tmp/dh-virtualenv; \
    cd /tmp/dh-virtualenv; \
    git checkout 98b4822; \
    sed -i -e 's/ python-sphinx-rtd-theme/#/g' debian/control; \
    sed -i -e 's/, python-sphinx//g' debian/control; \
    sed -i -e 's/, python-mock//g' debian/control; \
    sed -i -e 's/dh-python,//g' debian/control; \
    sed -i -re "1s/..unstable/~$(lsb_release -cs)) $(lsb_release -cs)/" debian/changelog; \
    DEB_BUILD_OPTIONS=nodoc dpkg-buildpackage -us -uc -b; \
    dpkg -i ../dh-virtualenv_*.deb || apt-get install -yf; \
    rm /usr/bin/virtualenv; \
    ln -s /usr/local/bin/virtualenv /usr/bin/virtualenv

ENV LC_ALL=C.UTF-8
