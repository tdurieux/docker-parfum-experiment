FROM envoyproxy/envoy-dev:latest

RUN apt-get update && apt-get -q --no-install-recommends install -y \
    curl && rm -rf /var/lib/apt/lists/*;
COPY ./front-envoy.yaml /etc/front-envoy.yaml
RUN chmod go+r /etc/front-envoy.yaml
CMD ["/usr/local/bin/envoy", "-c",  "/etc/front-envoy.yaml", "--service-cluster", "front-proxy"]
