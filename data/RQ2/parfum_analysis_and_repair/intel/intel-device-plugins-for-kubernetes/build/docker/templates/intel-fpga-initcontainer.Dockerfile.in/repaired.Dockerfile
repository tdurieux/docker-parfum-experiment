#include "final_base.docker"
#include "golang_base.docker"

FROM ${GOLANG_BASE} as builder

#include "default_args.docker"
ARG CRI_HOOK=intel-fpga-crihook

ARG CMD=fpga_crihook
ARG EP=/usr/local/fpga-sw/$CRI_HOOK
#include "default_build.docker"

ARG CMD=fpga_tool
ARG EP=/usr/local/fpga-sw/$CMD
#include "default_build.docker"

ARG SRC_DIR=/usr/local/fpga-sw
ARG DST_DIR=/opt/intel/fpga-sw

RUN echo "{\n\N
    \"hook\" : \"$DST_DIR/$CRI_HOOK\",\n\N
    \"stage\" : [ \"prestart\" ],\n\N
    \"annotation\": [ \"fpga.intel.com/region\" ]\n\N
}\n">>/install_root/$SRC_DIR/$CRI_HOOK.json

#include "toybox_build.docker"

FROM ${FINAL_BASE}

#include "default_labels.docker"