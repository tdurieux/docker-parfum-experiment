FROM envoyproxy/envoy-dev:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update && apt-get -qq --no-install-recommends install -y bash curl python3 && rm -rf /var/lib/apt/lists/*;

COPY ./envoy-proxy.yaml /etc/envoy.yaml
COPY ./client.py /client.py

RUN chmod go+r /etc/envoy.yaml

EXPOSE 8001

CMD ["/usr/local/bin/envoy", "-c", "/etc/envoy.yaml", "--service-node", "${HOSTNAME}", "--service-cluster", "client"]
