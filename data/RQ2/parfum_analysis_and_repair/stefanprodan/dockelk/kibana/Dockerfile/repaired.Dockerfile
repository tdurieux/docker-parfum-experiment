FROM kibana:4.6.2

RUN apt-get update && apt-get install --no-install-recommends -y netcat bzip2 && rm -rf /var/lib/apt/lists/*;

COPY config /opt/kibana/config

COPY entrypoint.sh /tmp/entrypoint.sh
RUN chmod +x /tmp/entrypoint.sh

CMD ["/tmp/entrypoint.sh"]
