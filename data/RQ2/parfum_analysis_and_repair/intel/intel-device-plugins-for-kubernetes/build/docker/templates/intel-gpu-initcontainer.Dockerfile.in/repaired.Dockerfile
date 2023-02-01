#include "final_base.docker"
#include "golang_base.docker"

FROM ${GOLANG_BASE} as builder

#include "default_args.docker"

#define _ENTRYPOINT_ /usr/local/bin/gpu-sw/intel-gpu-nfdhook
ARG EP=_ENTRYPOINT_
ARG CMD=gpu_nfdhook
ARG NFD_HOOK=intel-gpu-nfdhook
ARG SRC_DIR=/usr/local/bin/gpu-sw

#include "nfdhook_build.docker"

FROM ${FINAL_BASE}

#include "default_labels.docker"

LABEL name='intel-gpu-initcontainer'
LABEL summary='Intel® GPU NFD hook for Kubernetes'
LABEL description='The GPU fractional resources, such as GPU memory is registered as a kubernetes extended resource using node-feature-discovery (NFD). A custom NFD source hook is installed as part of GPU device plugin operator deployment and NFD is configured to register the GPU memory extended resource reported by the hook'

#include "nfdhook_end.docker"