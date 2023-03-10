FROM envoyproxy/envoy-dev:latest

COPY ./service-envoy-w-lrs.yaml /etc/service-envoy-w-lrs.yaml
RUN chmod go+r /etc/service-envoy-w-lrs.yaml

CMD ["/usr/local/bin/envoy", "-c", "/etc/service-envoy-w-lrs.yaml", "--service-node", "${HOSTNAME}", "--service-cluster", "http_service"]