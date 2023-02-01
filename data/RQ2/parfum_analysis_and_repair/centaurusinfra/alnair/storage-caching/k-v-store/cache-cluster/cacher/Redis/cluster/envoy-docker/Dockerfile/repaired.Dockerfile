FROM envoyproxy/envoy:v1.20-latest

RUN apt-get update -qq && apt-get install --no-install-recommends -yqq redis-tools curl dnsutils gettext-base && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /etc/envoy/
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
EXPOSE 6379
ENTRYPOINT ["/entrypoint.sh"]