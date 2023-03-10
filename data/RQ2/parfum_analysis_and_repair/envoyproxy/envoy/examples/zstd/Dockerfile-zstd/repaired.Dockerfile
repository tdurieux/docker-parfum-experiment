FROM envoyproxy/envoy-dev:latest

COPY ./zstd-envoy.yaml /etc/zstd-envoy.yaml
RUN chmod go+r /etc/zstd-envoy.yaml
CMD ["/usr/local/bin/envoy", "-c", "/etc/zstd-envoy.yaml", "--service-cluster", "zstd"]