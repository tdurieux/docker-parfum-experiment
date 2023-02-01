# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

FROM amazonlinux-2-aarch:base

SHELL ["/bin/bash", "-c"]

# gcc 7.3.1 is the latest version versions `yum --showduplicates list gcc`