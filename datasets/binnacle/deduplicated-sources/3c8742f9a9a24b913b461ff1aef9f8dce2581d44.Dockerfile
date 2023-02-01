# BASE_DISTRIBUTION is used to switch between the old base distribution and distroless base images
ARG BASE_DISTRIBUTION=default

# The following section is used as base image if BASE_DISTRIBUTION=default
FROM istionightly/base_debug as default

# Add CA certificates for SSL connections.
# obtained from debian ca-certs deb using fetch_cacerts.sh
ADD ca-certificates.tgz /

# Copy Envoy bootstrap templates used by pilot-agent
COPY envoy_bootstrap_v2.json /var/lib/istio/envoy/envoy_bootstrap_tmpl.json
COPY envoy_bootstrap_drain.json /var/lib/istio/envoy/envoy_bootstrap_drain.json
COPY gcp_envoy_bootstrap.json /var/lib/istio/envoy/gcp_envoy_bootstrap_tmpl.json

# Sudoers used to allow tcpdump and other debug utilities.
RUN useradd -m --uid 1337 istio-proxy && \
    echo "istio-proxy ALL=NOPASSWD: ALL" >> /etc/sudoers && \
    chown -R istio-proxy /var/lib/istio

# The following section is used as base image if BASE_DISTRIBUTION=distroless
FROM gcr.io/distroless/cc as distroless

# Copy Envoy bootstrap templates used by pilot-agent
COPY envoy_bootstrap_v2.json /var/lib/istio/envoy/envoy_bootstrap_tmpl.json
COPY envoy_bootstrap_drain.json /var/lib/istio/envoy/envoy_bootstrap_drain.json
COPY gcp_envoy_bootstrap.json /var/lib/istio/envoy/gcp_envoy_bootstrap_tmpl.json

# This will build the final image based on either default or distroless from above
FROM ${BASE_DISTRIBUTION}

ARG proxy_version
ARG istio_version

ARG ISTIO_API_SHA=unknown
ARG ENVOY_SHA=unknown
LABEL istio-api-vcs-ref=$ISTIO_API_SHA \
    envoy-vcs-ref=$ENVOY_SHA

# Install Envoy.
ADD envoy /usr/local/bin/envoy

# Environment variables indicating this proxy's version/capabilities as opaque string
ENV ISTIO_META_ISTIO_PROXY_VERSION "1.1.3"
# Environment variable indicating the exact proxy sha - for debugging or version-specific configs 
ENV ISTIO_META_ISTIO_PROXY_SHA $proxy_version
# Environment variable indicating the exact build, for debugging
ENV ISTIO_META_ISTIO_VERSION $istio_version

ADD pilot-agent /usr/local/bin/pilot-agent

ADD envoy_pilot.yaml.tmpl /etc/istio/proxy/envoy_pilot.yaml.tmpl
ADD envoy_policy.yaml.tmpl /etc/istio/proxy/envoy_policy.yaml.tmpl
ADD envoy_telemetry.yaml.tmpl /etc/istio/proxy/envoy_telemetry.yaml.tmpl
ADD istio-iptables.sh /usr/local/bin/istio-iptables.sh

# The pilot-agent will bootstrap Envoy.
ENTRYPOINT ["/usr/local/bin/pilot-agent"]
