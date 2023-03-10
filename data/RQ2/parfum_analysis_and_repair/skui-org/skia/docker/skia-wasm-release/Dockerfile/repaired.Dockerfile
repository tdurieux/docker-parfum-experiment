# Dockerfile for building the WASM libraries used by jsfiddle.skia.org and debugger.skia.org
FROM gcr.io/skia-public/emsdk-base:prod as builder

# Checkout Skia.
RUN mkdir -p /tmp/skia \
  && cd /tmp/skia \
  && fetch skia

# Set fake identity for git rebase. See thread in
# https://skia-review.googlesource.com/c/buildbot/+/286537/5/docker/Dockerfile#46
RUN cd /tmp/skia/skia \
    && git config user.email "skia@skia.org" \
    && git config user.name "Skia"

# HASH must be specified.
ARG HASH
RUN if [ -z "${HASH}" ] ; then echo "HASH must be specified as a --build-arg"; exit 1; fi

RUN cd /tmp/skia/skia \
  && git fetch \
  && git reset --hard ${HASH}

# If patch ref is specified then update the ref to patch in a CL.
ARG PATCH_REF
RUN if [ ! -z "${PATCH_REF}" ] ; then cd /tmp/skia/skia \
    && git fetch https://skia.googlesource.com/skia ${PATCH_REF} \
    && git checkout FETCH_HEAD \
    && git rebase ${HASH}; fi

RUN cd /tmp/skia/skia \
  && gclient sync \
  && ./bin/fetch-gn

# PathKit should be in /tmp/skia/skia/out/pathkit/
RUN /tmp/skia/skia/modules/pathkit/compile.sh

# CanvasKit should be in /tmp/skia/skia/out/canvaskit_wasm
RUN /tmp/skia/skia/modules/canvaskit/compile.sh

# Debugger should be in /tmp/skia/skia/out/debugger_wasm
RUN /tmp/skia/skia/experimental/wasm-skp-debugger/compile.sh

RUN cd /tmp/skia/skia && git rev-parse HEAD > /tmp/VERSION

#############################################################################
# Multi-stage build part 2, in which we only have the compiled results and
# a VERSION in /tmp
# See https://docs.docker.com/develop/develop-images/multistage-build/
#############################################################################