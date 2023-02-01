FROM envoyproxy/envoy:v1.10.0

COPY ./envoy.yaml /etc/envoy/envoy.yaml

CMD /usr/local/bin/envoy -c /etc/envoy/envoy.yaml
