#
# Copyright (c) 2019 SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

# openSUSE Tumbleweed image has only 'latest' tag so ignore DL3006 rule.
# hadolint ignore=DL3006
from opensuse/tumbleweed

# zypper -y or --non-interactive can be used interchangeably here so ignore
# DL3034 rule.
# hadolint ignore=DL3034