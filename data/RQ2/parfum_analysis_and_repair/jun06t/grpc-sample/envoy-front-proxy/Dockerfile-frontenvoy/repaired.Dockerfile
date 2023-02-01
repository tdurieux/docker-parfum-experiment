FROM envoyproxy/envoy:latest

RUN apt-get update && apt-get -q --no-install-recommends install -y \
    curl && rm -rf /var/lib/apt/lists/*;
CMD /usr/local/bin/envoy -c /etc/front-envoy.yaml --service-cluster front-proxy
