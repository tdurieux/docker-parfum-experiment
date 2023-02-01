#include "final_base.docker"
#include "golang_base.docker"

FROM ${GOLANG_BASE} as builder

#include "default_args.docker"

#define _ENTRYPOINT_ /usr/local/bin/sgx-sw/intel-sgx-epchook
ARG EP=_ENTRYPOINT_
ARG CMD=sgx_epchook
ARG NFD_HOOK=intel-sgx-epchook
ARG SRC_DIR=/usr/local/bin/sgx-sw

#include "nfdhook_build.docker"

FROM ${FINAL_BASE}

#include "default_labels.docker"

LABEL name='intel-sgx-initcontainer'
LABEL summary='Intel® SGX NFD hook for Kubernetes'
LABEL description='The SGX EPC memory available on each node is registered as a Kubernetes extended resource using node-feature-discovery (NFD). A custom NFD source hook is installed as part of SGX device plugin operator deployment and NFD is configured to register the SGX EPC memory extended resource reported by the hook'

#include "nfdhook_end.docker"