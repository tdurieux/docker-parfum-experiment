#
# Copyright (c) 2018 Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

#@distro@: docker image to be used to create a rootfs
#@OS_VERSION@: Docker image version to build this dockerfile
from @distro@:@OS_VERSION@

# This dockerfile needs to provide all the componets need to build a rootfs
# Install any package need to create a rootfs (package manager, extra tools)

# RUN commands

# This will install the proper golang to build Kata components