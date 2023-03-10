FROM envoyproxy/envoy-dev:latest

COPY ./gzip-envoy.yaml /etc/gzip-envoy.yaml
RUN chmod go+r /etc/gzip-envoy.yaml
CMD ["/usr/local/bin/envoy", "-c", "/etc/gzip-envoy.yaml", "--service-cluster", "gzip"]