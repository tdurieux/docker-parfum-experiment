FROM bitnami/minideb

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y ca-certificates && \
    update-ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY tmp/freenas-provisioner /
ENTRYPOINT ["/freenas-provisioner"]
