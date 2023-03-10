# Dockerfile using an external build (similar with Istio)

ARG BASE=gcr.io/istio-testing/proxyv2:latest-distroless

FROM ${BASE}

COPY krun /usr/local/bin/krun
COPY bootstrap_template.yaml /td_resources/
COPY iptables.sh /td_resources/

# TODO: allow workdir to be determined by app, cd to / for creating the files if root.
WORKDIR /
USER 0

# Add a version variant, since this is different enough in packaging.