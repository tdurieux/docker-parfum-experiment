FROM ubuntu:20.04

RUN apt update && apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

COPY kubefwd /

WORKDIR /
ENTRYPOINT ["/kubefwd"]
