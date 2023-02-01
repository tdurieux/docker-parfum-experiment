FROM ubuntu:18.04
RUN apt update && apt install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN update-ca-certificates
COPY bin/keysync /keysync
CMD []
ENTRYPOINT ["/keysync"]
