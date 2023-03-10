FROM envoyproxy/envoy-dev:latest
COPY ./envoy.yaml /etc/envoy.yaml
COPY ./envoy_filter_http_wasm_example.wasm /etc/envoy_filter_http_wasm_example.wasm
RUN chmod go+r /etc/envoy.yaml
CMD /usr/local/bin/envoy -c /etc/envoy.yaml -l debug --service-cluster proxy