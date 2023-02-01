# Copyright IBM Corp. All Rights Reserved.
# Copyright 2020 Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

# Description:
#   Docker image for a particular fpc chaincode
#
#  Configuration (build) parameters (for defaults, see below section with ARGs)
#  - extension identifying sgx mode:       HW_EXTENSION
#  - fpc image version:                    FPC_VERSION
#
# expects to be run with the docker context pointed o directory containing chaincode's enclave.so