FROM envoyproxy/envoy-dev:latest

RUN apt-get update && apt-get install --no-install-recommends -y curl tree && rm -rf /var/lib/apt/lists/*;
COPY ./envoy.yaml /etc/envoy.yaml
RUN chmod go+r /etc/envoy.yaml
COPY enable_delay_fault_injection.sh disable_delay_fault_injection.sh enable_abort_fault_injection.sh disable_abort_fault_injection.sh send_request.sh /
