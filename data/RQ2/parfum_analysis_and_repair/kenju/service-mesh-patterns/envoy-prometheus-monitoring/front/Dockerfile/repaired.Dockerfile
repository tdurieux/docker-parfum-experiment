FROM envoyproxy/envoy-dev:latest

RUN apt-get update && apt-get -q --no-install-recommends install -y \
    curl && rm -rf /var/lib/apt/lists/*;

COPY ./front-envoy.yaml /etc/front-envoy.yaml

# @doc https://www.envoyproxy.io/docs/envoy/latest/operations/cli
CMD /usr/local/bin/envoy \
    --config-path /etc/front-envoy.yaml \
    --service-cluster front-envoy \
    --service-node front-envoy