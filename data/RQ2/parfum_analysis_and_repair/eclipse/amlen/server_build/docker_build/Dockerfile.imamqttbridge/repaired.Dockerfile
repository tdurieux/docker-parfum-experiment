# Copyright (c) 2018-2021 Contributors to the Eclipse Foundation
#
# See the NOTICE file(s) distributed with this work for additional
# information regarding copyright ownership.
#
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License 2.0 which is available at
# http://www.eclipse.org/legal/epl-2.0
#
# SPDX-License-Identifier: EPL-2.0
#

#Choose a base image that matches the type of build we are using...
#By default we use: centos7
FROM quay.io/centos/centos:7
# For a RHEL8/CentOS8 distro, we use AlmaLinux:
#FROM quay.io/almalinux/almalinux:8
# For Fedora, the verion changes very often due to their short life
#FROM quay.io/fedora/fedora:35-x86_64

#File author / Maintainer
MAINTAINER ISM Build

WORKDIR ${IMA_BRIDGE_INSTALL_PATH}/bin

#To run as a non-root user
# 1) Create the user and group outside the container with a selected uid/gid
#        groupadd -r -g 465 imabridge
#        useradd -r  -s /sbin/nologin -g imabridge -u 465 imabridge
# 2) Give that user read/write access to any volumes that will be used
# 3) Create a config file so the RPM knows the user
#        RUN echo 'user=imabridge' >/etc/messagesight-bridge-user.cfg
# 4) Uncomment the RUN group/useradd setup lines:
#      (Ensure the numeric uid/gid below match step 1 above)
#        RUN groupadd -r -g 465 imabridge
#        RUN useradd -r  -s /sbin/nologin -g imabridge -u 465 imabridge
# 5) Uncomment the USER line before the entrypoint

# Install packages
RUN yum -y upgrade && \
    yum -y install gdb net-tools openssh-clients openssl tar perl zip logrotate bzip2 unzip cronie less libedit-devel && \
    rpm -iv http://10.90.125.123:9988/RPMS/${IMA_PKG_BRIDGE}.rpm && rm -rf /var/cache/yum

ENV LD_LIBRARY_PATH ${IMA_BRIDGE_INSTALL_PATH}/lib64:${LD_LIBRARY_PATH}
ENV PATH ${IMA_BRIDGE_INSTALL_PATH}/bin:${PATH}

#Uncomment below USER line to run as a non-root user (but do the above steps 1-4 as well!)
#USER imabridge:imabridge

#ENTRYPOINT "/bin/bash"
ENTRYPOINT [ "${IMA_BRIDGE_INSTALL_PATH}/bin/startBridge.sh" ]


