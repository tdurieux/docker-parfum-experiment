# Copyright (C) 2020, 2022, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

FROM ghcr.io/oracle/oraclelinux:7-slim AS build_base

ARG VERRAZZANO_APPLICATION_OPERATOR_IMAGE

# Need to use specific WORKDIR to match verrazzano's source packages
WORKDIR /root/go/src/github.com/verrazzano/verrazzano/platform-operator
COPY . .

COPY out/linux_amd64/verrazzano-platform-operator /usr/local/bin/verrazzano-platform-operator

RUN chmod 500 /usr/local/bin/verrazzano-platform-operator \
    && chmod +x scripts/install/*.sh \
    && chmod +x scripts/uninstall/*.sh \
    && chmod +x scripts/uninstall/uninstall-steps/*.sh

# Create the verrazzano-platform-operator image
FROM ghcr.io/oracle/oraclelinux:7-slim

ARG VERRAZZANO_APPLICATION_OPERATOR_IMAGE

# Use olcne13, which is required for kubectl
# Use olcne15, which is required for istioctl
# Use developer/olcne, which is required for helm
RUN yum update -y \
    && yum install -y openssl jq patch wget \
    && yum-config-manager --add-repo https://yum.oracle.com/repo/OracleLinux/OL7/olcne13/x86_64/ \
    && yum-config-manager --add-repo https://yum.oracle.com/repo/OracleLinux/OL7/olcne15/x86_64/ \
    && yum-config-manager --add-repo http://yum.oracle.com/repo/OracleLinux/OL7/developer/olcne/x86_64 \
    && yum install -y kubectl-1.20.11-4.el7 \
    && yum install -y helm-3.8.0-1.el7 \
    && yum install -y istio-istioctl-1.13.2-1.el7 \
    && yum clean all \
    && rm -rf /var/cache/yum

RUN groupadd -r verrazzano \
    && useradd --no-log-init -r -m -d /verrazzano -g verrazzano -u 1000 verrazzano \
    && mkdir /home/verrazzano \
    && chown -R 1000:verrazzano /home/verrazzano

# install Rancher system-tools (used by uninstall)
RUN wget https://github.com/rancher/system-tools/releases/download/v0.1.1-rc7/system-tools_linux-amd64 \
    -O /usr/local/bin/system-tools \
    && chmod +x /usr/local/bin/system-tools

# Copy the operator binary
COPY --from=build_base --chown=verrazzano:verrazzano /usr/local/bin/verrazzano-platform-operator /usr/local/bin/verrazzano-platform-operator

# Copy the Verrazzano install and uninstall scripts