# Copyright (C) 2021 Intel Corporation
# SPDX-License-Identifier: BSD-3-Clause

# https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

# Requires Docker >= 20.10.9, which returns ENOSYS instead of the
# default EPERM on clone3 syscall to ensure that glibc falls back to
# clone syscall. Needed for dpkg and apt to run DPkg::Post-Invoke and
# APT::Update::Post-Invoke as part of /etc/apt/apt.conf.d/docker-clean
# https://github.com/moby/moby/issues/42680
# https://github.com/moby/moby/pull/42681
FROM ubuntu:22.04

# Optionally override uid of default user in container, e.g.,
# docker build --build-arg uid=1001 ...
ARG uid

WORKDIR /work

# Before using a new script, update .github/workflows/container.yml
# to extend the `paths` on which the workflow runs.