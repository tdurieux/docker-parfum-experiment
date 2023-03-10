FROM envoyproxy/envoy-dev:latest

COPY ./ratelimit-envoy.yaml /etc/ratelimit-envoy.yaml
RUN chmod go+r /etc/ratelimit-envoy.yaml
CMD ["/usr/local/bin/envoy", "-c", "/etc/ratelimit-envoy.yaml", "--service-cluster", "ratelimit"]