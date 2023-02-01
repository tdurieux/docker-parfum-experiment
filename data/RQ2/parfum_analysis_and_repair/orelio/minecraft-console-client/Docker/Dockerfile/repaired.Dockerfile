FROM mono:6.12.0

COPY start-latest.sh /opt/start-latest.sh

RUN apt-get update && \
    apt-get install --no-install-recommends -y jq && \
    mkdir /opt/data && \
    chmod +x /opt/start-latest.sh && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/bin/sh", "-c", "/opt/start-latest.sh"]