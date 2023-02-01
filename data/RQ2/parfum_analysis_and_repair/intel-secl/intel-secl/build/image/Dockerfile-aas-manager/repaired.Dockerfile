#  Copyright (C) 2021 Intel Corporation
#  SPDX-License-Identifier: BSD-3-Clause

FROM ubuntu:focal

LABEL org.label-schema.name="Authservice Manager" \
      org.label-schema.vendor="Intel Corporation" \
      org.label-schema.license="BSD-3-Clause" \
      org.label-schema.url="https://github.com/intel-secl/intel-secl"

RUN apt-get update -y && apt-get install --no-install-recommends -y curl && apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/*;

RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

COPY tools/aas-manager/populate-users /usr/bin/populate-users

RUN chmod +x kubectl /usr/bin/populate-users
