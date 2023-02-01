FROM debian
ENTRYPOINT ["/usr/local/bin/atlas"]
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY atlas /usr/local/bin/atlas
