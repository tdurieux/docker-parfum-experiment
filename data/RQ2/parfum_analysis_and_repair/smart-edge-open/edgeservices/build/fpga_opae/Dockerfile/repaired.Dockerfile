# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019-2020 Intel Corporation

FROM centos:7.9.2009

WORKDIR /root/opae

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy

RUN yum install -y gcc gcc-c++ cmake make autoconf automake libxml2 libxml2-devel json-c-devel boost ncurses ncurses-devel ncurses-libs boost-devel libuuid libuuid-devel python2-jsonschema doxygen hwloc-devel libpng12 rsync bc python-devel python-libs python-sphinx unzip which wget python36 epel-release sudo && rm -rf /var/cache/yum
RUN curl -f https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py
RUN python get-pip.py
RUN pip install --no-cache-dir --upgrade pip==20.3.3
RUN pip install --no-cache-dir intelhex

# RT repo
RUN wget https://linuxsoft.cern.ch/cern/centos/7.9.2009/rt/CentOS-RT.repo -O /etc/yum.repos.d/CentOS-RT.repo
RUN wget https://linuxsoft.cern.ch/cern/centos/7.9.2009/os/x86_64/RPM-GPG-KEY-cern -O /etc/pki/rpm-gpg/RPM-GPG-KEY-cern

# install kernel sources to compile DPDK
RUN export isRT=$(uname -r | grep rt -c) && if [ $isRT = "1" ] ; then \
 yum install -y "kernel-rt-devel-uname-r == $(uname -r)"; rm -rf /var/cache/yumelse yum install -y "kernel-devel-uname-r == $(uname -r)"; rm -rf /var/cache/yumfi
RUN mkdir -p /lib/modules/$(uname -r)
RUN ln -s /usr/src/kernels/$(uname -r) /lib/modules/$(uname -r)/build

#create non-root user
ARG username=fpga_opae
ARG user_dir=/home/$username

RUN useradd -d $user_dir -m -s /bin/bash $username
RUN groupadd sudo
RUN usermod -aG sudo $username
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $username
WORKDIR $user_dir

#copy package
COPY OPAE_SDK_1.3.7-5_el7.zip .

#unzip package
RUN unzip OPAE_SDK_1.3.7-5_el7.zip

#install OPAE packages
RUN echo "proxy=$http_proxy/" | sudo tee -a /etc/yum.conf
RUN sudo yum clean expire-cache
RUN sudo -E bash -c 'cd OPAE/installation_packages && yum localinstall -y \
    opae.admin-1.0.3-2.el7.noarch.rpm \
    opae-libs-1.3.7-5.el7.x86_64.rpm opae-tools-1.3.7-5.el7.x86_64.rpm \
    opae-tools-extra-1.3.7-5.el7.x86_64.rpm \
    opae-intel-fpga-driver-2.0.1-10.x86_64.rpm \
    opae-devel-1.3.7-5.el7.x86_64.rpm'

#copy module checking script
COPY check_if_modules_loaded.sh .
RUN export isRT=$(uname -r | grep rt -c) && if [ $isRT = "1" ] ; then sudo yum erase -y "kernel-rt-devel-uname-r == $(uname -r)"; else sudo yum erase -y "kernel-devel-uname-r == $(uname -r)"; fi
RUN sudo rpm -e --nodeps kernel-headers
