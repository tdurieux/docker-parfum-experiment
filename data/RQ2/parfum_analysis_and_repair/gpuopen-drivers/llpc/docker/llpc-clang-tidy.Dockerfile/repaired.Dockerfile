#
# Dockerfile for LLPC Continuous Integration.
# Sample invocation:
#    docker build .                                                                                         \
#      --file docker/llpc-clang-tidy.Dockerfile                                                             \
#      --build-arg AMDVLK_IMAGE=us-docker.pkg.dev/stadia-open-source/amdvlk-public-ci/clang_release:nightly \
#      --build-arg LLPC_REPO_NAME=GPUOpen-Drivers/llpc                                                      \
#      --build-arg LLPC_REPO_REF=<GIT_REF>                                                                  \
#      --build-arg LLPC_REPO_SHA=<GIT_SHA>                                                                  \
#      --tag llpc-ci/llpc
#
# Required arguments:
# - AMDVLK_IMAGE: Base image name for prebuilt amdvlk
# - LLPC_REPO_NAME: Name of the llpc repository to clone
# - LLPC_REPO_REF: ref name to checkout
# - LLPC_REPO_SHA: SHA of the commit to checkout
# - LLPC_BASE_REF: ref name for the base of the tested change
#

# Resume build from the specified image.
ARG AMDVLK_IMAGE
FROM "$AMDVLK_IMAGE"

ARG LLPC_REPO_NAME
ARG LLPC_REPO_REF
ARG LLPC_REPO_SHA
ARG LLPC_BASE_REF

# Use bash instead of sh in this docker file.
SHELL ["/bin/bash", "-c"]

COPY docker/update-llpc.sh /vulkandriver/

RUN /vulkandriver/update-llpc.sh
RUN git -C /vulkandriver/drivers/llpc fetch origin "$LLPC_BASE_REF" --update-head-ok

# Run CMake.
WORKDIR /vulkandriver/builds/ci-build
RUN source /vulkandriver/env.sh \
    && cmake .

# Run clang-tidy. Detect failures by searching for a colon. An empty line or "No relevant changes found." signals success.