FROM envoyproxy/envoy-dev:latest

COPY ./envoy.yaml /etc/envoy.yaml

RUN apt-get update && apt-get -q --no-install-recommends install -y \
    curl && rm -rf /var/lib/apt/lists/*;

CMD /usr/local/bin/envoy -c /etc/envoy.yaml --service-cluster front-proxy
