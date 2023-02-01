# Copyright (c) 2017 VMware, Inc. All Rights Reserved.
# SPDX-License-Identifier: BSD-2-Clause
FROM debian:jessie
RUN apt-get update && apt-get install --no-install-recommends -y vim && apt-get clean && rm -rf /var/lib/apt/lists/*;
