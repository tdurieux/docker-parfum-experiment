# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

FROM centos:7.6.1810 as builder
WORKDIR /home

RUN yum update -y
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y \
    cpio sudo python3-pip python3-setuptools wget \
    boost \
    boost-thread \
    boost-devel \
    gcc gcc-c++ make autoconf automake libtool \
    kmod && rm -rf /var/cache/yum
RUN yum -y install gcc automake autoconf libtool && rm -rf /var/cache/yum
RUN yum -y install make && rm -rf /var/cache/yum
ARG LIBUSB_VER=v1.0.22
ARG LIBUSB_REPO=https://github.com/libusb/libusb/archive/${LIBUSB_VER}.tar.gz
SHELL ["/bin/bash", "-c"]
RUN wget -O - ${LIBUSB_REPO} | tar xz && \
    cd libusb* && \
    ./autogen.sh enable_udev=no && \
    make -j $(nproc) && \
    cp ./libusb/.libs/libusb-1.0.so /usr/lib64/libusb-1.0.so.0

ARG OPENVINO_VER=2020.2.120
ARG OPENVINO_REPO=http://registrationcenter-download.intel.com/akdlm/irc_nas/16612/l_openvino_toolkit_p_${OPENVINO_VER}.tgz

RUN wget -O - ${OPENVINO_REPO} | tar xz && \
    cd l_openvino_toolkit* && \
    sed -i 's/decline/accept/g' silent.cfg && \
    ./install.sh -s silent.cfg

RUN cd /opt/intel/openvino/deployment_tools/tools/deployment_manager && \
    python3 deployment_manager.py --targets=hddl --output_dir=/home --archive_name=hddl && \
    mkdir -p /home/opt/intel && \
    cd /home/opt/intel && \
    tar xvf /home/hddl.tar.gz && rm /home/hddl.tar.gz
RUN ls /home/opt/intel

FROM centos:7.6.1810

SHELL ["/bin/bash", "-c"]
RUN yum update -y
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y sudo && rm -rf /var/cache/yum
RUN yum install -y nasm \
    boost \
    boost-thread \
    boost-devel \
    autoconf automake make libtool kmod \
    redhat-lsb-core-4.1-27.el7.centos.1.x86_64 && rm -rf /var/cache/yum


COPY --from=builder /usr/lib64/libusb-1.0.so.0 /usr/lib64/libusb-1.0.so.0
COPY --from=builder /home/opt/intel /opt/intel/hddl
RUN sed -i '/"device_snapshot_mode"/ s/none/full/' /opt/intel/hddl/deployment_tools/inference_engine/external/hddl/config/hddl_service.config
RUN sed -i '/"abort_if_hw_reset_failed"/ s/true/false/' /opt/intel/hddl/deployment_tools/inference_engine/external/hddl/config/hddl_autoboot.config
COPY start.sh ./
COPY ./hddllog ./
CMD ["./start.sh"]

