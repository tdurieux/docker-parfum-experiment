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

WORKDIR ${IMA_PROXY_INSTALL_PATH}/bin

# Add RPM in a temporary directory inside the container
# Make sure that imaproxy.rpm is available in the directory where "docker build" command
# is being executed
ADD ./imaproxy.rpm /tmp/

# Update/install prereq packages
RUN yum -y upgrade && \
    yum -y install gdb net-tools openssh-clients openssl tar perl zip logrotate bzip2 unzip cronie less libedit-devel && rm -rf /var/cache/yum

# Install the Bridge itself
RUN yum -y install /tmp/imaproxy.rpm && rm -rf /var/cache/yum

# Delete imaproxy.rpm from temporary directory
RUN rm -f /tmp/imaproxy.rpm

ENV LD_LIBRARY_PATH ${IMA_PROXY_INSTALL_PATH}/lib64:${LD_LIBRARY_PATH}
ENV PATH ${IMA_PROXY_INSTALL_PATH}/bin:${PATH}

#Uncomment below USER line to run as a non-root user (but do the above steps 1-4 as well!)
#USER imaproxy:imaproxy

#ENTRYPOINT "/bin/bash"
ENTRYPOINT [ "${IMA_PROXY_INSTALL_PATH}/bin/startProxy.sh" ]



