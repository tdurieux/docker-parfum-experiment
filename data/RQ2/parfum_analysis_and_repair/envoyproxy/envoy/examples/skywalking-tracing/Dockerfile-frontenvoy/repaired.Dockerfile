FROM envoyproxy/envoy-dev:latest

COPY ./front-envoy-skywalking.yaml /etc/front-envoy.yaml
RUN chmod go+r /etc/front-envoy.yaml
CMD /usr/local/bin/envoy -c /etc/front-envoy.yaml --service-cluster front-proxy