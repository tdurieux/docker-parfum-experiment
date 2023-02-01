FROM consul:latest
FROM envoyproxy/envoy:v1.8.0
COPY --from=0 /bin/consul /bin/consul
ADD entrypoint.sh /entrypoint.sh
RUN apt-get update && \
    apt-get --assume-yes -y --no-install-recommends install curl && \
    apt-get --assume-yes -y --no-install-recommends install jq && \
    apt-get --assume-yes -y --no-install-recommends install bash && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["/entrypoint.sh"]
