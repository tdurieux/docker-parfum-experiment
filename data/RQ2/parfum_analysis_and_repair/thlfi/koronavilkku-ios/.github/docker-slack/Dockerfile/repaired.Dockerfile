FROM ubuntu:20.04

RUN apt update && apt install --no-install-recommends -y curl jq && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
