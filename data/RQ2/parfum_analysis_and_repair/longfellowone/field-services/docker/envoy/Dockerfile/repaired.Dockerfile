FROM envoyproxy/envoy:latest

RUN apt-get update && \
    apt-get install --no-install-recommends gettext -y && rm -rf /var/lib/apt/lists/*;

COPY /docker/envoy/envoy.yaml /tmpl/envoy.yaml.tmpl
COPY /docker/envoy/entrypoint.sh /

RUN chmod 500 /entrypoint.sh

EXPOSE 9090

ENTRYPOINT ["/entrypoint.sh"]