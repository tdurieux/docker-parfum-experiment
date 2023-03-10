FROM envoyproxy/envoy:v1.17-latest

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl && \
    rm -rf /var/lib/apt/lists/*
RUN curl -f -Lo - https://github.com/tetratelabs/getenvoy-package/files/3518103/getenvoy-centos-jaegertracing-plugin.tar.gz | tar -xz && mv libjaegertracing.so.0.4.2 /usr/local/lib/libjaegertracing_plugin.so

COPY envoy-front_proxy.yaml /etc/envoy/envoy.yaml
