#
# Copyright (c) 2020 Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

from docker.io/gentoo/stage3-amd64:latest

#environment variable declaration, etc
@SET_UP@

# This dockerfile needs to provide all the componets need to build a rootfs
# Install any package need to create a rootfs (package manager, extra tools)

# This will install the proper golang to build Kata components