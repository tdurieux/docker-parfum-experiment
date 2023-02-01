#include "final_base.docker"
#include "golang_base.docker"

FROM ${GOLANG_BASE} as builder

ARG DIR=/intel-device-plugins-for-kubernetes
WORKDIR $DIR
COPY . .

#include "toybox_build.docker"

FROM ${FINAL_BASE}

#include "default_labels.docker"