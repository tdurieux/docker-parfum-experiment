# Dockerfile for running rust_icu tests based
# on source that has been mounted in.
ARG DOCKER_REPO=filipfilmar
ARG VERSION=0.0.0
ARG ICU_VERSION_TAG=maint-67
FROM $DOCKER_REPO/rust_icu_$ICU_VERSION_TAG:$VERSION AS buildenv
ARG DOCKER_REPO
ARG VERSION
ARG ICU_VERSION_TAG

# Mount the rust_icu source top level directory here.