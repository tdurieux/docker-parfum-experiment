FROM debian

COPY acme-for-appliances /

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN update-ca-certificates

VOLUME [ "/storage" ]

ENTRYPOINT [ "/acme-for-appliances" ]
