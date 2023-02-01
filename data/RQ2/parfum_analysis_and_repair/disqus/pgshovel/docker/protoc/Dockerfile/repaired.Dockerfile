FROM debian:jessie

RUN apt-get update && \
    apt-get install --no-install-recommends -y protobuf-compiler && \
        rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["protoc"]
