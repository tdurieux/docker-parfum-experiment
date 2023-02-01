#
# Prometheus for Temporal stats
#

FROM gcr.io/mcback/base:latest

RUN \
    mkdir -p /opt/prometheus/ && \
    /dl_to_stdout.sh "https://github.com/prometheus/prometheus/releases/download/v2.26.0/prometheus-2.26.0.linux-$(dpkg --print-architecture).tar.gz" | \
        tar -zx -C /opt/prometheus/ --strip 1 && \
    true

COPY prometheus.yml /opt/prometheus/

# Add unprivileged user the service will run as