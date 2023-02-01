# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019-2021 Intel Corporation

FROM centos:8.3.2011

WORKDIR /root/

RUN yum install -y unzip sudo \
        && yum clean all && rm -rf /var/cache/yum

COPY syscfg_package.zip .
RUN mkdir -p /root/syscfg \
        && unzip syscfg_package.zip -d /root/syscfg_package \
        && rpm -ivh --prefix=/usr/bin /root/syscfg_package/Linux_x64/RHEL/RHEL8/*.rpm

ARG username=biosfw
ARG user_dir=/home/$username

RUN useradd -d $user_dir -m -s /bin/bash $username
RUN groupadd sudo
RUN usermod -aG sudo $username
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $username
WORKDIR $user_dir

COPY ./biosfw.sh ./

ENTRYPOINT ["sudo", "./biosfw.sh"]
