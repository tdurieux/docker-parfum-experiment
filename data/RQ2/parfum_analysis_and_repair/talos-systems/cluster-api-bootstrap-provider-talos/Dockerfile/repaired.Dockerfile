# syntax = docker/dockerfile-upstream:1.2.0-labs

# Meta args applied to stage base names.

ARG TOOLS
ARG PKGS

# Resolve package images using ${PKGS} to be used later in COPY --from=.

FROM ghcr.io/siderolabs/ca-certificates:${PKGS} AS pkg-ca-certificates
FROM ghcr.io/siderolabs/fhs:${PKGS} AS pkg-fhs

# The base target provides the base for running various tasks against the source
# code