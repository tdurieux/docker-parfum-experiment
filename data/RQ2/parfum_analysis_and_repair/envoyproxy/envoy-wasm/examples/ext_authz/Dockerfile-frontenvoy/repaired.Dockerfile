FROM envoyproxy/envoy-dev:latest

RUN apt-get update && apt-get -q --no-install-recommends install -y \
    curl && rm -rf /var/lib/apt/lists/*;
COPY ./config /etc/envoy-config
COPY ./run_envoy.sh /run_envoy.sh
RUN chmod go+r -R /etc/envoy-config \
    && chmod go+rx /run_envoy.sh /etc/envoy-config /etc/envoy-config/*
CMD ["/bin/sh", "/run_envoy.sh"]
