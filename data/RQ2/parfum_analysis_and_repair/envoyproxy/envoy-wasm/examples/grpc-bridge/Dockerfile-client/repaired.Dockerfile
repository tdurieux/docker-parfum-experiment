FROM envoyproxy/envoy-dev:latest

COPY ./client/envoy-proxy.yaml /etc/client-envoy-proxy.yaml
RUN chmod go+r /etc/client-envoy-proxy.yaml
CMD ["/usr/local/bin/envoy", "-c", "/etc/client-envoy-proxy.yaml"]