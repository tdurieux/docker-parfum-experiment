FROM ubuntu:18.04

COPY entrypoint.sh /entrypoint.sh

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y build-essential binutils-aarch64-linux-gnu && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/entrypoint.sh"]
