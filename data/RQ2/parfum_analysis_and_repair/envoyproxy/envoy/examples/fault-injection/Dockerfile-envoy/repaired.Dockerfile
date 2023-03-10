FROM envoyproxy/envoy-dev:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update \
    && apt-get -qq install --no-install-recommends -y tree curl \
    && apt-get -qq autoremove -y \
    && apt-get -qq clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*
COPY ./envoy.yaml /etc/envoy.yaml
RUN chmod go+r /etc/envoy.yaml
COPY enable_delay_fault_injection.sh disable_delay_fault_injection.sh enable_abort_fault_injection.sh disable_abort_fault_injection.sh send_request.sh /