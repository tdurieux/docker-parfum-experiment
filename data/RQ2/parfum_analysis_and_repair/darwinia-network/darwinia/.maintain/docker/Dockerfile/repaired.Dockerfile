##
# Only for CI using, for building process please refer to .github/workflows.
##

FROM ubuntu:focal

ARG CI_GIT_TAG
ARG CI_GIT_SHA
ARG CI_BUILD_AT

# See:
# https://github.com/opencontainers/image-spec/blob/main/annotations.md
# https://github.com/paritytech/polkadot/blob/master/scripts/dockerfiles/polkadot_injected_release.Dockerfile