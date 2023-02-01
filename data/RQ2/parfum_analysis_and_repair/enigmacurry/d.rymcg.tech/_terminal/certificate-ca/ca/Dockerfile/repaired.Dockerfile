FROM debian:stable-slim
VOLUME /CA
RUN apt-get update -y && apt-get install --no-install-recommends -y openssl && rm -rf /var/lib/apt/lists/*;

COPY ca.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/ca.sh
ENTRYPOINT ["/usr/local/bin/ca.sh"]
