FROM envoyproxy/envoy:v1.17-latest
COPY envoy-front_proxy.yaml /etc/envoy/envoy.yaml