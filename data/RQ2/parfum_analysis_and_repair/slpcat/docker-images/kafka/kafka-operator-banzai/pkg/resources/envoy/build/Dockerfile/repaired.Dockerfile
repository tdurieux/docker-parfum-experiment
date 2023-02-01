FROM envoyproxy/envoy:latest

COPY docker-entrypoint.sh /

RUN chmod 500 /docker-entrypoint.sh

RUN apt-get update && \
    apt-get install --no-install-recommends gettext -y && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/docker-entrypoint.sh"]
