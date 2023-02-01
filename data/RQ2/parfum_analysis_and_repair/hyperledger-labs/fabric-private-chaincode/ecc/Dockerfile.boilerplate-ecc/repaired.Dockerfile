# Copyright IBM Corp. All Rights Reserved.
# Copyright 2020 Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

# Description:
#   Sets up the template of a docker environment to run FPC chaincode, just missing the chaincode's enclave.so*
#
#  Configuration (build) parameters (for defaults, see below section with ARGs)
#  - fpc image version:          FPC_VERSION
#  - sgxmode:                    SGX_MODE
#  - Chaincode as a Server Port: CAAS_PORT

ARG FPC_VERSION=main

FROM hyperledger/fabric-private-chaincode-ccenv:${FPC_VERSION}

ARG SGX_MODE
ENV SGX_MODE=${SGX_MODE}
# Note: the library copied below is SGX_MODE dependent, so we
# define here a env which makes it easy recognizable which mode
# the container is. No default, though, as we do not control
# the build and rely on a proper value provided from outside.