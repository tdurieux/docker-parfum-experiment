#
# Copyright (c) 2018 SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

#suse: docker image to be used to create a rootfs
#@OS_VERSION@: Docker image version to build this dockerfile
from docker.io/opensuse/leap

# This dockerfile needs to provide all the componets need to build a rootfs
# Install any package need to create a rootfs (package manager, extra tools)

COPY install-packages.sh config.sh /
# RUN commands
RUN chmod +x /install-packages.sh; /install-packages.sh

# This will install the proper golang to build Kata components