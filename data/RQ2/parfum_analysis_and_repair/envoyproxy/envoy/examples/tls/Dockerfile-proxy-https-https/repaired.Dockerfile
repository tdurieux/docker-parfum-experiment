FROM envoyproxy/envoy-dev:latest

COPY ./envoy-https-https.yaml /etc/envoy.yaml
RUN chmod go+r /etc/envoy.yaml
CMD ["/usr/local/bin/envoy", "-c /etc/envoy.yaml"]