FROM istionightly/base_debug
ARG proxy_version
ARG istio_version

ARG ISTIO_API_SHA=unknown
ARG ENVOY_SHA=unknown
LABEL istio-api-vcs-ref=$ISTIO_API_SHA \
    envoy-vcs-ref=$ENVOY_SHA

# Environment variables indicating this proxy's version/capabilities as opaque string
ENV ISTIO_META_ISTIO_PROXY_VERSION "1.1.3"
# Environment variable indicating the exact proxy sha - for debugging or version-specific configs
ENV ISTIO_META_ISTIO_PROXY_SHA $proxy_version
# Environment variable indicating the exact build, for debugging
ENV ISTIO_META_ISTIO_VERSION $istio_version

# This sidecar will use TPROXY for interception
ENV ISTIO_META_INTERCEPTION_MODE TPROXY

# Please keep in sync with Dockerfile.v2
# This proxy will use TPROXY interception. Core dump won't work - see issue 5745
# User will need to use the proxy annotation to use this image, as well as the
# original InterceptionMode annotation to run as root and add NET_ADMIN

# This doesn't (yet) extend proxyv2 - need to change the makefile to customize the FROM to match the hub/tag that
# is currently built, or use a base image.

# TODO: evaluate if we should add NET_ADMIN in all cases, to support future firewall
# and dynamic iptable config

ADD envoy /usr/local/bin/envoy

ADD pilot-agent /usr/local/bin/pilot-agent

# pilot-agent and envoy may run with effective uid 0 in order to run envoy with
# CAP_NET_ADMIN, so any iptables rule matching on "-m owner --uid-owner
# istio-proxy" will not match connections from those processes anymore.
# Instead, rely on the process's effective gid being istio-proxy and create a
# "-m owner --gid-owner istio-proxy" iptables rule in istio-iptables.sh.
RUN \
  chgrp 1337 /usr/local/bin/envoy /usr/local/bin/pilot-agent && \
  chmod 2755 /usr/local/bin/envoy /usr/local/bin/pilot-agent

ADD envoy_pilot.yaml.tmpl /etc/istio/proxy/envoy_pilot.yaml.tmpl
ADD envoy_policy.yaml.tmpl /etc/istio/proxy/envoy_policy.yaml.tmpl
ADD envoy_telemetry.yaml.tmpl /etc/istio/proxy/envoy_telemetry.yaml.tmpl
ADD istio-iptables.sh /usr/local/bin/istio-iptables.sh

# Copy Envoy bootstrap templates used by pilot-agent
COPY envoy_bootstrap_v2.json /var/lib/istio/envoy/envoy_bootstrap_tmpl.json
COPY envoy_bootstrap_drain.json /var/lib/istio/envoy/envoy_bootstrap_drain.json
COPY gcp_envoy_bootstrap.json /var/lib/istio/envoy/gcp_envoy_bootstrap_tmpl.json

# Add CA certificates for SSL connections.
# obtained from debian ca-certs deb using fetch_cacerts.sh
ADD ca-certificates.tgz /

# Sudoers used to allow tcpdump and other debug utilities.
RUN useradd -m --uid 1337 istio-proxy && \
    echo "istio-proxy ALL=NOPASSWD: ALL" >> /etc/sudoers && \
    chown -R istio-proxy /var/lib/istio

# The pilot-agent will bootstrap Envoy.
ENTRYPOINT ["/usr/local/bin/pilot-agent"]
