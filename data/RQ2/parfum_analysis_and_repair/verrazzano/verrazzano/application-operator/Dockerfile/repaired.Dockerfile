# Copyright (C) 2020, 2021, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

FROM ghcr.io/oracle/oraclelinux:7-slim AS build_base

# Need to use specific WORKDIR to match verrazzano-application-operator's source packages
WORKDIR /root/go/src/github.com/verrazzano/application-operator
COPY . .

COPY out/linux_amd64/verrazzano-application-operator /usr/local/bin/verrazzano-application-operator

RUN chmod 500 /usr/local/bin/verrazzano-application-operator

# Create the verrazzano-application-operator image
FROM ghcr.io/oracle/oraclelinux:7-slim

RUN yum update -y \
    && yum clean all \
    && rm -rf /var/cache/yum

# Copy the operator binary