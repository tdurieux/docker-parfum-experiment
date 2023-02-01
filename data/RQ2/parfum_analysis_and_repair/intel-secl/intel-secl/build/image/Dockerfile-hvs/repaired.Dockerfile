#  Copyright (C) 2021 Intel Corporation
#  SPDX-License-Identifier: BSD-3-Clause

FROM ubuntu:focal

LABEL org.label-schema.name="Host Verification Service" \
      org.label-schema.vendor="Intel Corporation" \
      org.label-schema.license="BSD-3-Clause" \
      org.label-schema.url="https://github.com/intel-secl/intel-secl"

COPY cmd/hvs/hvs /usr/bin/hvs

COPY build/linux/hvs/*.pem /tmp/

COPY build/linux/hvs/schema /tmp/schema

COPY build/linux/hvs/templates /tmp/templates

COPY build/image/entrypoint-hvs.sh /entrypoint.sh

RUN mkdir -p /opt/hvs/privacyca-aik-requests && chmod +0766 /opt/hvs/privacyca-aik-requests

RUN chmod -R +0644 /tmp/schema /tmp/templates

# Copy upgrade scripts