# Release of upstream Istio this is based on
ARG ISTIO_VERSION=1.X.Y

# Version is the base image version from the TLD Makefile (cilium/istio/Makefile.core.mk)
ARG BASE_VERSION=1.5-dev.3

# Pre-built cilium-envoy image from updated Istio deps
ARG CILIUM_ENVOY_SHA=5fd04721d8db90e1d5f3ad1ac8ba4f6ac91e623a

FROM quay.io/cilium/cilium-envoy:${CILIUM_ENVOY_SHA} as cilium-envoy

#
# Pre-built Istio image (non-TPROXY)
#
FROM istio/proxyv2:${ISTIO_VERSION} as istio

#
# Please keep in sync with cilium/istio/pilot/docker/Dockerfile.proxyv2:
#

# The following section is used as base image if BASE_DISTRIBUTION=default
FROM docker.io/istio/base:${BASE_VERSION} as default

# Environment variable indicating the exact proxy sha - for debugging or version-specific configs
ARG CILIUM_ENVOY_SHA
ENV ISTIO_META_ISTIO_PROXY_SHA ${CILIUM_ENVOY_SHA}
# Environment variable indicating the exact build, for debugging
ARG ISTIO_VERSION
ENV ISTIO_META_ISTIO_VERSION ${ISTIO_VERSION}

# This sidecar will use TPROXY for interception
ENV ISTIO_META_INTERCEPTION_MODE TPROXY

# pilot-agent and envoy may run with effective uid 0 in order to run envoy with
# CAP_NET_ADMIN, so any iptables rule matching on "-m owner --uid-owner
# istio-proxy" will not match connections from those processes anymore.
# Instead, rely on the process's effective gid being istio-proxy and create a
# "-m owner --gid-owner istio-proxy" iptables rule in istio-iptables.
# hadolint ignore=DL3002
USER 0:1337

COPY --from=istio /etc/istio /etc/istio
COPY --from=istio /var/lib/istio /var/lib/istio
COPY --from=istio /usr/local/bin/pilot-agent /usr/local/bin/pilot-agent
COPY --from=istio /usr/local/bin/istio-iptables /usr/local/bin/istio-iptables
COPY --from=cilium-envoy /usr/bin/cilium-envoy /usr/local/bin/envoy
RUN chgrp 1337 /usr/local/bin/envoy && chmod 2755 /usr/local/bin/envoy

# Override the Envoy bootstrap to configure Envoy to use API v2 and to define
# the "xds-grpc-cilium" cluster used by the Cilium filters to connect to Cilium
# agent via a Unix domain socket.
# This file is adapted from Istio's API v2 bootstrap:
# $ wget https://raw.githubusercontent.com/istio/istio/1.2.2/tools/packaging/common/envoy_bootstrap_v2.json
# $ patch -o envoy_bootstrap_tmpl.json < envoy_bootstrap_v2.patch
COPY envoy_bootstrap_tmpl.json /var/lib/istio/envoy/envoy_bootstrap_tmpl.json

# TODO: /var/lib/istio/envoy/gcp_envoy_bootstrap_tmpl.json not yet adapted for Cilium