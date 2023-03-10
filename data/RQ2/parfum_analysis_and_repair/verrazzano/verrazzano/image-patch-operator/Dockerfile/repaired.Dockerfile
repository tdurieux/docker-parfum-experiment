# Copyright (C) 2021, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

FROM ghcr.io/oracle/oraclelinux:7-slim as builder

# Need to use specific WORKDIR to match verrazzano-image-patch-operator's source packages
WORKDIR /root/go/src/github.com/verrazzano/verrazzano/image-patch-operator
COPY . .

COPY out/linux_amd64/verrazzano-image-patch-operator /usr/local/bin/verrazzano-image-patch-operator

RUN chmod 500 /usr/local/bin/verrazzano-image-patch-operator

# Create the verrazzano-image-patch-operator image