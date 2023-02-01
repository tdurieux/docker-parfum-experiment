FROM golang:1.14-buster

RUN apt-get update && apt-get install --no-install-recommends -y protobuf-compiler && rm -rf /var/lib/apt/lists/*;

WORKDIR /build/rpc
CMD ["/bin/bash", "regen.sh"]


