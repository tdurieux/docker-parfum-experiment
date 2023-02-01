#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

ARG ORIGINAL_IMAGE=mcr.microsoft.com/vscode/devcontainers/universal@sha256:8fc6883411913acca538ef054c4f6508c4e28745f39ae3d8af6ce327787bb49c
FROM ${ORIGINAL_IMAGE}

ARG PACKAGE_LIST="\
apt \
curl \
openssl \
p11-kit \
krb5-3 \
openldap \
libgssapi-krb5-2 \
tzdata \
"

# Script to iterate through the above list and update packages