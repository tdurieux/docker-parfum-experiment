FROM golang:1.11

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y ca-certificates openssl zip && \
  update-ca-certificates && \
  rm -rf /var/lib/apt && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]