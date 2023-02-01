# Copyright (c) 2020-present, The kubequery authors
#
# This source code is licensed as defined by the LICENSE file found in the
# root directory of this source tree.
#
# SPDX-License-Identifier: (Apache-2.0 OR GPL-2.0-only)

FROM ubuntu:20.04 AS builder

ARG BASEQUERY_VERSION=5.0.2

ADD https://uptycs-basequery.s3.amazonaws.com/${BASEQUERY_VERSION}/basequery_${BASEQUERY_VERSION}-1.linux_amd64.deb /tmp/basequery.deb

RUN dpkg -i /tmp/basequery.deb

# =====

FROM uptycs/busybox:v1.33.0

ARG BASEQUERY_VERSION
ARG KUBEQUERY_VERSION

LABEL \
  name="kubequery" \
  description="kubequery powered by Osquery" \
  version="${KUBEQUERY_VERSION}" \
  url="https://github.com/Uptycs/kubequery"

# uptycs/busybox comes with this user predefined. We need a non-root user